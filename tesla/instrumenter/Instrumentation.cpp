/*! @file Instrumentation.cpp  Miscellaneous instrumentation helpers. */
/*
 * Copyright (c) 2012-2013 Jonathan Anderson
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

#include <tesla/libtesla.h>

#include "Automaton.h"
#include "Instrumentation.h"
#include "Names.h"
#include "State.h"
#include "Transition.h"

#include "llvm/IR/DataLayout.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

using std::string;
using std::vector;

namespace tesla {

//! Find all functions within a module that will be notified of a Fn event.
llvm::SmallVector<llvm::Function*,3>
  FindInstrumentation(const FunctionEvent&, llvm::Module&);

/**
 * Find the function within a given module that receives instrumentation events
 * of a given type.
 *
 * @returns  NULL if no such function exists yet
 */
llvm::Function *FindInstrumentationFn(llvm::Module& M, llvm::StringRef Name,
                                      FunctionEvent::Direction Dir,
                                      FunctionEvent::CallContext Ctx);

/**
 * Map instrumentation arguments into a @ref tesla_key that can be used to
 * look up automata.
 */
llvm::Value* ConstructKey(llvm::IRBuilder<>& Builder, llvm::Module& M,
                          llvm::Function::ArgumentListType& InstrumentationArgs,
                          FunctionEvent FnEventDescription);

StructType* KeyType(Module& M) {
  const char Name[] = "tesla_key";
  StructType *T = M.getTypeByName(Name);

  if (T == NULL) {
    // A struct tesla_key is just a mask and a set of keys.
    vector<Type*> KeyElements(TESLA_KEY_SIZE + 1, RegisterType(M));
    T = StructType::create(KeyElements, Name);
  }

  return T;
}


/// Find (or create) printf() declaration.
Function* Printf(Module& Mod) {
  auto& Ctx = Mod.getContext();

  FunctionType *PrintfType = FunctionType::get(
    IntegerType::get(Ctx, 32),                         // return: int32
    PointerType::getUnqual(IntegerType::get(Ctx, 8)),  // format string: char*
    true);                                             // use varargs

  Function* Printf = cast<Function>(
    Mod.getOrInsertFunction("printf", PrintfType));

  return Printf;
}

const char* Format(Type *T) {
    if (T->isPointerTy()) return " 0x%llx";
    if (T->isIntegerTy()) return " %d";
    if (T->isFloatTy()) return " %f";
    if (T->isDoubleTy()) return " %f";

    assert(false && "Unhandled arg type");
    abort();
}

} /* namespace tesla */


Type* tesla::RegisterType(Module& M) {
    return DataLayout(&M).getIntPtrType(M.getContext());
}

BasicBlock* tesla::CallPrintf(Module& Mod, const Twine& Prefix, Function *F,
                              BasicBlock *InsertBefore) {
  string FormatStr(Prefix.str());
  for (auto& Arg : F->getArgumentList()) FormatStr += Format(Arg.getType());
  FormatStr += "\n";

  auto *Block = BasicBlock::Create(Mod.getContext(), "entry", F, InsertBefore);
  IRBuilder<> Builder(Block);

  ArgVector PrintfArgs(1, Builder.CreateGlobalStringPtr(FormatStr));
  for (auto& Arg : F->getArgumentList()) PrintfArgs.push_back(&Arg);

  Builder.CreateCall(Printf(Mod), PrintfArgs);

  return Block;
}


Value* tesla::Cast(Value *From, StringRef Name, Type *NewType,
                   IRBuilder<>& Builder) {

  assert(From != NULL);
  Type *CurrentType = From->getType();

  if (!CastInst::isCastable(CurrentType, NewType)) {
    string NewTypeName;
    raw_string_ostream NameOut(NewTypeName);
    NewType->print(NameOut);

    report_fatal_error(
      "Instrumentation argument "
      + (Name.empty() ? "" : ("'" + Name + "' "))
      + "cannot be cast to "
      + NewTypeName
    );
  }

  if (isa<PointerType>(CurrentType))
    return Builder.CreatePointerCast(From, NewType);

  else if (isa<IntegerType>(CurrentType))
    return Builder.CreateIntCast(From, NewType, false);

  llvm_unreachable("failed to cast something castable");
}


Function* tesla::FindStateUpdateFn(Module& M, Type *IntType) {

  LLVMContext& Ctx = M.getContext();

  Type *Char = IntegerType::get(Ctx, 8);
  Type *CharStar = PointerType::getUnqual(Char);
  Type *RegType = RegisterType(M);
  Type *KeyStar = PointerType::getUnqual(KeyType(M));

  Constant *Fn = M.getOrInsertFunction("tesla_update_state",
      IntType,    // return type
      IntType,    // context
      IntType,    // class_id
      KeyStar,    // key
      CharStar,   // name
      CharStar,   // description
      RegType,    // expected_state
      RegType,    // new_state
      NULL
    );

  assert(isa<Function>(Fn));
  return cast<Function>(Fn);
}


SmallVector<Function*,3>
  tesla::FindInstrumentation(const FunctionEvent& FnEvent, Module& M) {

  // Find existing instrumentation stubs.
  SmallVector<FunctionEvent::CallContext,2> Contexts;
  if (FnEvent.context() == FunctionEvent::CallerAndCallee) {
    Contexts.push_back(FunctionEvent::Callee);
    Contexts.push_back(FunctionEvent::Caller);
  } else {
    Contexts.push_back(FnEvent.context());
  }

  SmallVector<FunctionEvent::Direction,2> Directions;
  if (FnEvent.direction() == FunctionEvent::EntryAndExit) {
    Directions.push_back(FunctionEvent::Entry);
    Directions.push_back(FunctionEvent::Exit);
  } else {
    Directions.push_back(FnEvent.direction());
  }

  SmallVector<Function*,3> ToInstrument;
  for (auto C : Contexts)
    for (auto D : Directions)
      ToInstrument.push_back(
        FindInstrumentationFn(M, FnEvent.function().name(), D, C));

  return ToInstrument;
}

Function* tesla::FindInstrumentationFn(Module& M, StringRef Name,
                                       FunctionEvent::Direction Dir,
                                       FunctionEvent::CallContext Ctx) {

  StringRef Prefix;
  switch (Ctx) {
  default:
    // We don't accept e.g. (Entry | Exit); we're looking for one function.
    assert(false && "Bad CallContext passed to FindInstrumentationFn");
    break;

  case FunctionEvent::Callee:
    switch (Dir) {
      default: assert(false && "Unhandled FunctionEvent::Direction");
      case FunctionEvent::Entry:  Prefix = CALLEE_ENTER; break;
      case FunctionEvent::Exit:   Prefix = CALLEE_LEAVE; break;
    }
    break;

  case FunctionEvent::Caller:
    switch (Dir) {
      default: assert(false && "Unhandled FunctionEvent::Direction");
      case FunctionEvent::Entry:  Prefix = CALLER_ENTER; break;
      case FunctionEvent::Exit:   Prefix = CALLER_LEAVE; break;
    }
    break;
  }

  return M.getFunction((Prefix + Name).str());
}


bool tesla::AddInstrumentation(const FnTransition& T, const Automaton& A,
                               Module& M) {

  auto& FnEvent = T.FnEvent();
  auto& Fn = FnEvent.function();

  // Only build instrumentation for functions defined in this module.
  Function *F = M.getFunction(Fn.name());
  if (!F || (F->getBasicBlockList().empty()))
    return false;

  for (Function *InstrFn : FindInstrumentation(FnEvent, M)) {
    assert(InstrFn != NULL);
    LLVMContext& Ctx = InstrFn->getContext();

    // The instrumentation function should always end in a RetVoid;
    // assert this is so and then trim it so we can add new stuff.
    auto& PreviousEndBlock = InstrFn->back();
    assert(PreviousEndBlock.getTerminator()->getNumSuccessors() == 0);
    PreviousEndBlock.getTerminator()->eraseFromParent();

    auto Block = BasicBlock::Create(Ctx, A.Name(), InstrFn);
    IRBuilder<>(&PreviousEndBlock).CreateBr(Block);

    IRBuilder<> Builder(Block);
    Type* IntType = RegisterType(M);

    auto CurrentState = ConstantInt::get(IntType, T.Source().ID());
    auto NextState = ConstantInt::get(IntType, T.Destination().ID());

    Constant *NoError = ConstantInt::get(IntType, 0);

    auto Die = BasicBlock::Create(Ctx, "die", InstrFn);
    // TODO: provide notification of failure
    IRBuilder<>(Die).CreateRetVoid();

    vector<Value*> Args;
    Args.push_back(TeslaContext(A.getAssertion().context(), Ctx));
    Args.push_back(ConstantInt::get(IntType, A.ID()));
    Args.push_back(ConstructKey(Builder, M,
                     InstrFn->getArgumentList(), T.FnEvent()));
    Args.push_back(Builder.CreateGlobalStringPtr(A.Name()));
    Args.push_back(Builder.CreateGlobalStringPtr(A.Description()));
    Args.push_back(CurrentState);
    Args.push_back(NextState);

    Function *UpdateStateFn = FindStateUpdateFn(M, IntType);
    assert(Args.size() == UpdateStateFn->arg_size());

    Value *Error = Builder.CreateCall(UpdateStateFn, Args);
    Error = Builder.CreateICmpNE(Error, NoError);

    auto Exit = BasicBlock::Create(Ctx, "exit", InstrFn);
    IRBuilder<>(Exit).CreateRetVoid();

    Builder.CreateCondBr(Error, Exit, Die);
  }

  return true;
}


Constant* tesla::TeslaContext(Assertion::Context Context, LLVMContext& Ctx) {
  static Type *IntType = IntegerType::get(Ctx, 64);

  static auto *Global = ConstantInt::get(IntType, TESLA_SCOPE_GLOBAL);
  static auto *PerThread = ConstantInt::get(IntType, TESLA_SCOPE_PERTHREAD);

  switch (Context) {
  default:
    // does not return
    report_fatal_error(__FILE__ ":" + Twine(__LINE__) + ": no handler for "
                        + "Assertion::" + Assertion::Context_Name(Context));

  case Assertion::Global: return Global;
  case Assertion::ThreadLocal: return PerThread;
  }
}


Value* tesla::ConstructKey(IRBuilder<>& Builder, Module& M,
                           Function::ArgumentListType& InstrArgs,
                           FunctionEvent FnEvent) {

  bool HaveRetVal = FnEvent.has_expectedreturnvalue();
  const int TotalArgs = FnEvent.argument_size() + (HaveRetVal ? 1 : 0);

  if (InstrArgs.size() != TotalArgs)
    report_fatal_error(
      "Instrumentation takes " + Twine(InstrArgs.size())
      + " but description in manifest has " + Twine(FnEvent.argument_size())
      + " arguments" + (HaveRetVal ? " and a return value" : "")
    );

  vector<Value*> Args(TotalArgs, NULL);

  int i = 0;

  for (auto& InstrArg : InstrArgs) {
    auto& Arg = (HaveRetVal && (i == (TotalArgs - 1)))
      ? FnEvent.expectedreturnvalue()
      : FnEvent.argument(i);
    ++i;

    if (Arg.type() != Argument::Variable)
      continue;

    int Index = Arg.index();

    assert(Index < TotalArgs);
    Args[Index] = &InstrArg;
  }

  return ConstructKey(Builder, M, Args);
}

Value* tesla::ConstructKey(IRBuilder<>& Builder, Module& M,
                           ArrayRef<Value*> Args) {

  assert(Args.size() <= TESLA_KEY_SIZE);

  Value *Key = Builder.CreateAlloca(KeyType(M), 0, "key");
  Type *RegType = RegisterType(M);

  static Constant *Null = ConstantInt::get(RegType, 0);

  int i = 0;
  int KeyMask = 0;

  for (Value* Arg : Args) {
    Builder.CreateStore(
      (Arg == NULL) ? Null : Cast(Arg, Twine(i - 1).str(), RegType, Builder),
      Builder.CreateStructGEP(Key, i));

    if (Arg != NULL)
      KeyMask |= (1 << i);

    i++;
  }

  Value *Mask = Builder.CreateStructGEP(Key, TESLA_KEY_SIZE);
  Builder.CreateStore(ConstantInt::get(RegType, KeyMask), Mask);

  return Key;
}

