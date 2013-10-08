//! @file TranslationFn.cpp  Definition of @ref TranslationFn.
/*
 * Copyright (c) 2013 Jonathan Anderson
 * All rights reserved.
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
 * ("CTSRD"), as part of the DARPA CRASH research programme.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include "Automaton.h"
#include "EventTranslator.h"
#include "Instrumentation.h"
#include "TranslationFn.h"
#include "Names.h"

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Module.h>

using namespace llvm;
using namespace tesla;

using std::string;
using std::vector;


static const char* Format(Type *T) {
    if (T->isPointerTy()) return " %p";
    if (T->isIntegerTy()) return " %d";
    if (T->isFloatTy()) return " %f";
    if (T->isDoubleTy()) return " %f";

    assert(false && "Unhandled arg type");
    abort();
}


TranslationFn* TranslationFn::Create(InstrContext& InstrCtx,
                                     StringRef NameSuffix,
                                     FunctionType *InstrType,
                                     StringRef PrintfPrefix,
                                     GlobalValue::LinkageTypes Linkage) {

  Module& M = InstrCtx.M;

  string Name = (INSTR_BASE + NameSuffix).str();
  auto *InstrFn = dyn_cast<Function>(M.getOrInsertFunction(Name, InstrType));
  InstrFn->setLinkage(Linkage);

  //
  // Invariant: instrumentation functions should have two exit blocks, one for
  // normal termination and one for abnormal termination.
  //
  // The function starts out with the entry block jumping to the exit block.
  // Instrumentation is added in new BasicBlocks in between.
  //
  BasicBlock *EndBlock;

  if (InstrFn->empty()) {
    BasicBlock *Preamble = CreatePreamble(InstrCtx, InstrFn, PrintfPrefix);

    EndBlock = BasicBlock::Create(InstrCtx.Ctx, "exit", InstrFn);

    IRBuilder<>(Preamble).CreateBr(EndBlock);
    IRBuilder<>(EndBlock).CreateRetVoid();

  } else
    EndBlock = FindBlock("exit", *InstrFn);

  return new TranslationFn(InstrCtx, InstrFn, EndBlock);
}


void TranslationFn::InsertCall(ArrayRef<Value*> Args, Instruction *Before) {
  CallInst::Create(InstrFn, Args)->insertBefore(Before);
}
}


EventTranslator TranslationFn::AddInstrumentation(const Automaton& A,
                                                  const FunctionEvent& Ev) {

  //
  // The instrumentation function's parameters include the target's
  // parameters, return value and Objective-C receiver (if any).
  //
  // We need to compile a list of patterns in the same order to match against.
  //
  //! Start with FunctionEvent-specified function arguments.
  vector<Argument> Patterns(Ev.argument().begin(), Ev.argument().end());


  if (Ev.has_expectedreturnvalue()) {
    assert(Ev.direction() == FunctionEvent::Exit);
    Patterns.push_back(Ev.expectedreturnvalue());
  }

  if (Ev.has_receiver()) {
    assert(Ev.kind() == FunctionEvent::ObjCInstanceMessage
       or Ev.kind() == FunctionEvent::ObjCClassMessage
       or Ev.kind() == FunctionEvent::ObjCSuperMessage);

    Patterns.push_back(Ev.receiver());
  }

  return AddInstrumentation(A.Name(), Patterns);
}


EventTranslator TranslationFn::AddInstrumentation(StringRef Label,
                                                  ArrayRef<Argument> Patterns) {
  LLVMContext& Ctx = InstrCtx.Ctx;

  //
  // An instrumentation function is a linear chain of event pattern
  // matchers and instrumentation blocks. Insert the new instrumentation
  // at the end of this chain.
  //
  BasicBlock *Instr = BasicBlock::Create(Ctx, Label + ":instr", InstrFn, End);
  End->replaceAllUsesWith(Instr);

  //
  // Match instrumented values against the given pattern, saving variables
  // to a struct tesla_key.
  //
  Function::ArgumentListType& InstrumentedValues = InstrFn->getArgumentList();
  assert(Patterns.size() == InstrumentedValues.size());

  vector<Value*> KeyArgs(TESLA_KEY_SIZE, NULL);
  IRBuilder<> Builder(Instr);

  size_t i = 0;
  for (Value& Val : InstrumentedValues) {
    const Argument& Pattern = Patterns[i];

    Match(Label + ":match:" + Twine(i), Instr, Pattern, &Val);

    if (Pattern.has_index()) {
      int Index = Pattern.index();

      assert(Index < TESLA_KEY_SIZE);
      assert(KeyArgs[Index] == NULL);
      KeyArgs[Index] = GetArgumentValue(&Val, Pattern, Builder);
    }

    i++;
  }

  Value *Key = ConstructKey(Builder, InstrCtx.M, KeyArgs);

  TerminatorInst *Branch = Builder.CreateBr(End);
  Builder.SetInsertPoint(Branch);

  return EventTranslator(Builder, Key, InstrCtx);
}


BasicBlock* TranslationFn::Match(Twine Label, BasicBlock *InstrBlock,
                                 const Argument& Pattern, Value *Val) {

  if (Pattern.type() != Argument::Constant)
    return InstrBlock;

  BasicBlock *MatchBlock
    = BasicBlock::Create(InstrCtx.Ctx, Label, InstrFn, InstrBlock);

  InstrBlock->replaceAllUsesWith(MatchBlock);

  IRBuilder<> M(MatchBlock);
  Value *PatternValue = ConstantInt::getSigned(Val->getType(), Pattern.value());
  Value *Cmp;

  switch (Pattern.constantmatch()) {
  case Argument::Exact:
    Cmp = M.CreateICmpEQ(Val, PatternValue);
    break;

  case Argument::Flags:
    // test that x contains mask: (val & pattern) == pattern
    Cmp = M.CreateICmpEQ(M.CreateAnd(Val, PatternValue), PatternValue);
    break;

  case Argument::Mask:
    // test that x contains no more than mask: (val & pattern) == val
    Cmp = M.CreateICmpEQ(M.CreateAnd(Val, PatternValue), Val);
    break;
  }

  M.CreateCondBr(Cmp, InstrBlock, End);

  return MatchBlock;
}


BasicBlock* TranslationFn::CreatePreamble(InstrContext& InstrCtx,
                                          Function *InstrFn, Twine Prefix) {

  LLVMContext& Ctx = InstrCtx.Ctx;
  Module& M = InstrCtx.M;

  BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", InstrFn);

  if (InstrCtx.SuppressDebugPrintf)
    return Entry;

  assert(InstrCtx.Debugging != NULL);
  assert(InstrCtx.Printf != NULL);

  BasicBlock *Preamble = BasicBlock::Create(Ctx, "preamble", InstrFn, Entry);
  IRBuilder<> Builder(Preamble);

  //
  // Only print if TESLA_DEBUG indicates that we want output.
  //
  Value *DebugName = M.getGlobalVariable("debug_name", true);
  if (!DebugName)
    DebugName = Builder.CreateGlobalStringPtr("tesla.events", "debug_name");

  Value *Debugging = Builder.CreateCall(InstrCtx.Debugging, DebugName);

  Constant *Zero = ConstantInt::get(IntegerType::get(Ctx, 32), 0);
  Debugging = Builder.CreateICmpNE(Debugging, Zero);

  BasicBlock *PrintBB = BasicBlock::Create(Ctx, "printf", InstrFn, Entry);
  Builder.CreateCondBr(Debugging, PrintBB, Entry);

  string FormatStr(Prefix.str());
  for (Value& Arg : InstrFn->getArgumentList())
    FormatStr += Format(Arg.getType());
  FormatStr += "\n";

  ArgVector PrintfArgs(1, Builder.CreateGlobalStringPtr(FormatStr));
  for (Value& Arg : InstrFn->getArgumentList()) PrintfArgs.push_back(&Arg);

  IRBuilder<> PrintBuilder(PrintBB);
  PrintBuilder.CreateCall(InstrCtx.Printf, PrintfArgs);
  PrintBuilder.CreateBr(Entry);

  return Entry;
}
