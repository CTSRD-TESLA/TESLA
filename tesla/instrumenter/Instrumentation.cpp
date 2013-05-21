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

#include <libtesla.h>

#include "Automaton.h"
#include "Debug.h"
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

/**
 * Map instrumentation arguments into a @ref tesla_key that can be used to
 * look up automata.
 */
llvm::Value* ConstructKey(llvm::IRBuilder<>& Builder, llvm::Module& M,
                          llvm::Function::ArgumentListType& InstrumentationArgs,
                          FunctionEvent FnEventDescription);

//! Construct a @ref tesla_transitions from several @ref tesla_transition.
Constant* ConstructTransitions(IRBuilder<>&, Module&, TEquivalenceClass&);

BasicBlock *FindBlock(StringRef Name, Function& Fn) {
  for (auto& B : Fn)
    if (B.getName() == Name)
      return &B;

  panic("instrumentation function '" + Fn.getName()
         + "' has no '" + Name + "' block");
}

void FnInstrumentation::AppendInstrumentation(
    const Automaton& A, const FunctionEvent& Ev, TEquivalenceClass& Trans) {

  LLVMContext& Ctx = TargetFn->getContext();

  auto Fn = Ev.function();
  assert(Fn.name() == TargetFn->getName());
  assert(Ev.direction() == Dir);

  // An instrumentation function should be a linear chain of event pattern
  // matchers and instrumentation blocks. Find the current end of this chain
  // and insert the new instrumentation before it.
  auto *Exit = FindBlock("exit", *InstrFn);
  auto *Instr = BasicBlock::Create(Ctx, A.Name() + ":instr", InstrFn, Exit);
  Exit->replaceAllUsesWith(Instr);

  // We may need to check constant values (e.g. return values).
  // TODO: check constants besides the return value!
  BasicBlock *FirstPatternMatcher = NULL;
  if (Dir == FunctionEvent::Exit && Ev.has_expectedreturnvalue()) {

    const Argument &Arg = Ev.expectedreturnvalue();
    if (Arg.type() == Argument::Constant) {
      auto *Match = BasicBlock::Create(Ctx, A.Name() + ":match-retval",
                                       InstrFn, Instr);

      Instr->replaceAllUsesWith(Match);
      if (!FirstPatternMatcher)
        FirstPatternMatcher = Match;

      IRBuilder<> Matcher(Match);
      Value *ReturnVal = --(InstrFn->arg_end());
      Value *ExpectedReturnVal = ConstantInt::getSigned(ReturnVal->getType(),
                                                        Arg.value());

      Matcher.CreateCondBr(Matcher.CreateICmpNE(ReturnVal, ExpectedReturnVal),
                           Exit, Instr);
    }
  }

  IRBuilder<> Builder(Instr);
  Type* IntType = Type::getInt32Ty(Ctx);

  vector<Value*> Args;
  Args.push_back(TeslaContext(A.getAssertion().context(), Ctx));
  Args.push_back(ConstantInt::get(IntType, A.ID()));
  Args.push_back(ConstructKey(Builder, M, InstrFn->getArgumentList(), Ev));
  Args.push_back(Builder.CreateGlobalStringPtr(A.Name()));
  Args.push_back(Builder.CreateGlobalStringPtr(A.String()));
  Args.push_back(ConstructTransitions(Builder, M, Trans));

  Function *UpdateStateFn = FindStateUpdateFn(M, IntType);
  assert(Args.size() == UpdateStateFn->arg_size());


  Value *Error = Builder.CreateCall(UpdateStateFn, Args);
  Constant *NoError = ConstantInt::get(IntType, TESLA_SUCCESS);
  Error = Builder.CreateICmpEQ(Error, NoError);

  Builder.CreateCondBr(Error, Exit, FindBlock("die", *InstrFn));
}


StructType* KeyType(Module& M) {
  const char Name[] = "tesla_key";
  StructType *T = M.getTypeByName(Name);

  if (T == NULL) {
    // A struct tesla_key is just a mask and a set of keys.
    vector<Type*> KeyElements(TESLA_KEY_SIZE, IntPtrType(M));
    KeyElements.push_back(Type::getInt32Ty(M.getContext()));
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


Function* tesla::FunctionInstrumentation(Module& Mod, const Function& Subject,
                                         FunctionEvent::Direction Dir,
                                         FunctionEvent::CallContext Context) {

  LLVMContext& Ctx = Mod.getContext();

  string Name = (Twine()
    + INSTR_BASE
    + ((Context == FunctionEvent::Callee) ? CALLEE : CALLER)
    + ((Dir == FunctionEvent::Entry) ? ENTER : EXIT)
    + Subject.getName()
  ).str();

  string Tag = (Twine()
    + "["
    + ((Dir == FunctionEvent::Entry) ? "CAL" : "RET")
    + ((Context == FunctionEvent::Callee) ? "E" : "R")
    + "] "
  ).str();


  // Build the instrumentation function's type.
  FunctionType *SubType = Subject.getFunctionType();
  TypeVector Args(SubType->param_begin(), SubType->param_end());

  if (Dir == FunctionEvent::Exit) {
    Type *RetType = Subject.getReturnType();
    if (!RetType->isVoidTy())
      Args.push_back(RetType);
  }

  Type *Void = Type::getVoidTy(Ctx);
  FunctionType *InstrType = FunctionType::get(Void, Args, SubType->isVarArg());


  // Find (or build) the instrumentation function.
  auto *InstrFn = dyn_cast<Function>(Mod.getOrInsertFunction(Name, InstrType));
  assert(InstrFn != NULL);

  if (Context == FunctionEvent::Caller)
    InstrFn->setLinkage(GlobalValue::PrivateLinkage);

  // Invariant: instrumentation blocks should have two exit blocks: one for
  // normal termination and one for abnormal termination.
  if (InstrFn->empty()) {
    auto *Entry = BasicBlock::Create(Ctx, "entry", InstrFn);
    IRBuilder<> Builder(Entry);
    // TODO: this output is just temporary.
    CallPrintf(Mod, Builder, Tag + Subject.getName(), InstrFn);

    auto *Exit = BasicBlock::Create(Ctx, "exit", InstrFn);
    Builder.CreateBr(Exit);
    IRBuilder<>(Exit).CreateRetVoid();

    auto *Die = BasicBlock::Create(Ctx, "die", InstrFn);
    IRBuilder<> ErrorHandler(Die);
    auto *EventName = ErrorHandler.CreateGlobalStringPtr(InstrFn->getName());
    ErrorHandler.CreateCall(FindDieFn(Mod), EventName);
    ErrorHandler.CreateRetVoid();
  }

  return InstrFn;
}


Function* tesla::StructInstrumentation(Module& Mod,
                                       Type *ValueType, Type *PtrType,
                                       StringRef StructTypeName,
                                       StringRef FieldName,
                                       bool Store) {

  LLVMContext& Ctx = Mod.getContext();

  string Name = (Twine()
    + STRUCT_INSTR
    + (Store ? STORE : LOAD)
    + StructTypeName
    + "_"
    + FieldName
  ).str();

  string Tag = (Twine()
    + "[F"
    + (Store ? "SET" : "GET")
    + "] "
  ).str();

  // Two arguments: current value and next value.
  TypeVector Args;
  Args.push_back(ValueType);
  Args.push_back(PtrType);

  Type *Void = Type::getVoidTy(Ctx);
  FunctionType *InstrType = FunctionType::get(Void, Args, false);


  // Find (or build) the instrumentation function.
  auto *InstrFn = dyn_cast<Function>(Mod.getOrInsertFunction(Name, InstrType));
  assert(InstrFn != NULL);

  InstrFn->setLinkage(GlobalValue::PrivateLinkage);

  // Invariant: instrumentation blocks should have two exit blocks: one for
  // normal termination and one for abnormal termination.
  if (InstrFn->empty()) {
    auto *Entry = BasicBlock::Create(Ctx, "entry", InstrFn);
    IRBuilder<> Builder(Entry);
    // TODO: this output is just temporary.
    CallPrintf(Mod, Builder, Tag + StructTypeName + "." + FieldName,
               InstrFn);

    auto *Exit = BasicBlock::Create(Ctx, "exit", InstrFn);
    Builder.CreateBr(Exit);
    IRBuilder<>(Exit).CreateRetVoid();

    auto *Die = BasicBlock::Create(Ctx, "die", InstrFn);
    IRBuilder<> ErrorHandler(Die);
    auto *EventName = ErrorHandler.CreateGlobalStringPtr(InstrFn->getName());
    ErrorHandler.CreateCall(FindDieFn(Mod), EventName);
    ErrorHandler.CreateRetVoid();
  }

  return InstrFn;
}


Type* tesla::IntPtrType(Module& M) {
    return DataLayout(&M).getIntPtrType(M.getContext());
}

StructType* tesla::TransitionType(Module& M) {
  const char Name[] = "tesla_transition";
  StructType *T = M.getTypeByName(Name);
  if (T)
    return T;

  // We don't already have it; go find it!
  LLVMContext& Ctx = M.getContext();
  Type *IntType = Type::getInt32Ty(Ctx);

  return StructType::create(Name,
                            IntType,  // from state
                            IntType,  // mask on from's name
                            IntType,  // to state
                            IntType,  // mask on to's name
                            IntType,  // explicit instruction to fork
                            NULL);
}

StructType* tesla::TransitionSetType(Module& M) {
  const char Name[] = "tesla_transitions";
  StructType *T = M.getTypeByName(Name);
  if (T)
    return T;

  // We don't already have it; go find it!
  Type *IntTy = IntegerType::get(M.getContext(), 32);
  Type *TransStar = PointerType::getUnqual(TransitionType(M));

  return StructType::create(Name,
                            IntTy,      // number of possible transitions
                            TransStar,  // transition array
                            NULL);
}

Value* tesla::CallPrintf(Module& Mod, IRBuilder<>& Builder,
                         const Twine& Prefix, Function *F) {

  string FormatStr(Prefix.str());
  for (auto& Arg : F->getArgumentList()) FormatStr += Format(Arg.getType());
  FormatStr += "\n";

  ArgVector PrintfArgs(1, Builder.CreateGlobalStringPtr(FormatStr));
  for (auto& Arg : F->getArgumentList()) PrintfArgs.push_back(&Arg);

  return Builder.CreateCall(Printf(Mod), PrintfArgs);
}


Value* tesla::Cast(Value *From, StringRef Name, Type *NewType,
                   IRBuilder<>& Builder) {

  assert(From != NULL);
  Type *CurrentType = From->getType();

  if (CurrentType == NewType)
    return From;

  if (!CastInst::isCastable(CurrentType, NewType)) {
    string CurrentTypeName;
    raw_string_ostream CurrentOut(CurrentTypeName);
    CurrentType->print(CurrentOut);

    string NewTypeName;
    raw_string_ostream NameOut(NewTypeName);
    NewType->print(NameOut);

    panic(
      "Instrumentation argument "
      + (Name.empty() ? "" : ("'" + Name + "' "))
      + "cannot be cast from '" + CurrentTypeName
      + "' to '" + NewTypeName + "'"
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
  Type *TransStar = PointerType::getUnqual(TransitionSetType(M));
  Type *KeyStar = PointerType::getUnqual(KeyType(M));

  Constant *Fn = M.getOrInsertFunction("tesla_update_state",
      IntType,    // return type
      IntType,    // context
      IntType,    // class_id
      KeyStar,    // key
      CharStar,   // name
      CharStar,   // description
      TransStar,  // transitions data
      NULL
    );

  assert(isa<Function>(Fn));
  return cast<Function>(Fn);
}


Function* tesla::FindDieFn(Module& M) {

  LLVMContext& Ctx = M.getContext();

  Type *Char = IntegerType::get(Ctx, 8);
  Type *CharStar = PointerType::getUnqual(Char);
  Type *Void = Type::getVoidTy(Ctx);

  // TODO: apply 'noreturn' attribute.
  //
  // Currently, if I supply an AttributeSet the Verifier says:
  //   Some attributes in 'noreturn' only apply to functions!
  //
  // Which is odd, since I am only applying them to a function.
  auto *Fn = M.getOrInsertFunction("tesla_die", Void, CharStar, NULL);

  assert(isa<Function>(Fn));
  return cast<Function>(Fn);
}


Constant* tesla::TeslaContext(AutomatonDescription::Context Context,
                              LLVMContext& Ctx) {
  static Type *IntType = Type::getInt32Ty(Ctx);

  static auto *Global = ConstantInt::get(IntType, TESLA_SCOPE_GLOBAL);
  static auto *PerThread = ConstantInt::get(IntType, TESLA_SCOPE_PERTHREAD);

  switch (Context) {
  case AutomatonDescription::Global: return Global;
  case AutomatonDescription::ThreadLocal: return PerThread;
  }
}


Value* tesla::ConstructKey(IRBuilder<>& Builder, Module& M,
                           Function::ArgumentListType& InstrArgs,
                           FunctionEvent FnEvent) {

  bool HaveRetVal = FnEvent.has_expectedreturnvalue();
  const size_t TotalArgs = FnEvent.argument_size() + (HaveRetVal ? 1 : 0);

  if (InstrArgs.size() != TotalArgs)
    panic(
      "instrumentation for '" + FnEvent.function().name() + "' takes "
      + Twine(InstrArgs.size())
      + " arguments but description in manifest provides "
      + Twine(FnEvent.argument_size())
      + (HaveRetVal ? " and a return value" : "")
    );

  vector<Value*> Args(TotalArgs, NULL);

  size_t i = 0;

  for (auto& InstrArg : InstrArgs) {
    auto& Arg = (HaveRetVal && (i == (TotalArgs - 1)))
      ? FnEvent.expectedreturnvalue()
      : FnEvent.argument(i);
    ++i;

    if (Arg.type() != Argument::Variable)
      continue;

    size_t Index = Arg.index();

    assert(Index < TotalArgs);
    Args[Index] = &InstrArg;
  }

  return ConstructKey(Builder, M, Args);
}

Value* tesla::ConstructKey(IRBuilder<>& Builder, Module& M,
                           ArrayRef<Value*> Args) {

  assert(Args.size() <= TESLA_KEY_SIZE);

  Value *Key = Builder.CreateAlloca(KeyType(M), 0, "key");
  Type *IntPtrTy = IntPtrType(M);
  Type *IntTy = Type::getInt32Ty(M.getContext());

  static Constant *Null = ConstantInt::get(IntPtrTy, 0);

  int i = 0;
  int KeyMask = 0;

  for (Value* Arg : Args) {
    Builder.CreateStore(
      (Arg == NULL) ? Null : Cast(Arg, Twine(i - 1).str(), IntPtrTy, Builder),
      Builder.CreateStructGEP(Key, i));

    if (Arg != NULL)
      KeyMask |= (1 << i);

    i++;
  }

  Value *Mask = Builder.CreateStructGEP(Key, TESLA_KEY_SIZE);
  Builder.CreateStore(ConstantInt::get(IntTy, KeyMask), Mask);

  return Key;
}

Constant* tesla::ConstructTransition(IRBuilder<>& Builder, llvm::Module& M,
                                     const Transition& T) {

  uint32_t Flags =
      (T.RequiresInit()           ? TESLA_TRANS_INIT      : 0)
    | (T.RequiresCleanup()        ? TESLA_TRANS_CLEANUP   : 0);

  uint32_t Values[] = {
    (uint32_t) T.Source().ID(),
    T.Source().Mask(),
    (uint32_t) T.Destination().ID(),
    T.Destination().Mask(),
    Flags
  };

  Type *IntType = Type::getInt32Ty(M.getContext());

  vector<Constant*> Elements;
  for (auto Val : Values)
    Elements.push_back(ConstantInt::get(IntType, Val));

  return ConstantStruct::get(TransitionType(M), Elements);
}

Constant* tesla::ConstructTransitions(IRBuilder<>& Builder, Module& M,
                                      TEquivalenceClass& Tr) {

  vector<Constant*> Transitions;
  for (auto T : Tr)
    Transitions.push_back(ConstructTransition(Builder, M, *T));

  return ConstructTransitions(Builder, M, Transitions);
}

Constant* tesla::ConstructTransitions(IRBuilder<>& Builder, Module& M,
                                      ArrayRef<Constant*> Transitions) {

  static StructType *T = TransitionSetType(M);

  Type *IntType = Type::getInt32Ty(M.getContext());
  Constant *Zero = ConstantInt::get(IntType, 0);
  Constant *Zeroes[] = { Zero, Zero };

  Constant *Count = ConstantInt::get(IntType, Transitions.size());

  ArrayType *ArrayT = ArrayType::get(TransitionType(M), Transitions.size());
  auto *Array = new GlobalVariable(M, ArrayT, true, GlobalValue::PrivateLinkage,
                                   ConstantArray::get(ArrayT, Transitions),
                                   "transition_array");

  Constant *ArrayPtr = ConstantExpr::getInBoundsGetElementPtr(Array, Zeroes);

  Constant *TransitionsInit = ConstantStruct::get(T, Count, ArrayPtr, NULL);

  return new GlobalVariable(M, T, true, GlobalValue::PrivateLinkage,
                            TransitionsInit, "transitions");
}

