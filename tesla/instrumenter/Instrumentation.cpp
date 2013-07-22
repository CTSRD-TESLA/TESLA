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

BasicBlock* MatchPattern(LLVMContext& Ctx, StringRef Name, Function *Fn,
                         BasicBlock *MatchTarget, BasicBlock *NonMatchTarget,
                         Value *Val, const tesla::Argument& Pattern);

BasicBlock *FindBlock(StringRef Name, Function& Fn) {
  for (auto& B : Fn)
    if (B.getName() == Name)
      return &B;

  panic("instrumentation function '" + Fn.getName()
         + "' has no '" + Name + "' block");
}

void FnInstrumentation::AppendInstrumentation(
    const Automaton& A, const FunctionEvent& Ev, TEquivalenceClass& Trans) {

  LLVMContext& Ctx = M.getContext();

  auto Fn = Ev.function();
  assert((Ev.kind() != FunctionEvent::CCall) || (Fn.name() == TargetFn->getName()));
  assert(Ev.direction() == Dir);

  // An instrumentation function should be a linear chain of event pattern
  // matchers and instrumentation blocks. Find the current end of this chain
  // and insert the new instrumentation before it.
  auto *Exit = FindBlock("exit", *InstrFn);
  auto *Instr = BasicBlock::Create(Ctx, A.Name() + ":instr", InstrFn, Exit);
  Exit->replaceAllUsesWith(Instr);

  // We may need to check constant values (e.g. return values).
  size_t i = 0;
  if (Ev.argument().size() > 0)
    for (auto& InstrArg : InstrFn->getArgumentList()) {
      const Argument& Arg = Ev.argument(i);
      MatchPattern(Ctx, (A.Name() + ":match:arg" + Twine(i)).str(), InstrFn,
                   Instr, Exit, &InstrArg, Arg);

      // Ignore the return value, which passed as an argument to InstrFn.
      if (++i == Ev.argument_size())
        break;
    }

  if (Dir == FunctionEvent::Exit && Ev.has_expectedreturnvalue()) {
    const Argument &Arg = Ev.expectedreturnvalue();
    Value *ReturnValue = --(InstrFn->arg_end());
    MatchPattern(Ctx, A.Name() + ":match:retval", InstrFn,
                 Instr, Exit, ReturnValue, Arg);
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
  Builder.CreateCall(UpdateStateFn, Args);
  Builder.CreateBr(Exit);
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

/// Find (or create) tesla_debugging() declaration.
Function* TeslaDebugging(Module& Mod) {
  auto& Ctx = Mod.getContext();

  FunctionType *FnType = FunctionType::get(
    IntegerType::get(Ctx, 32),                          // return: int32
    PointerType::getUnqual(IntegerType::get(Ctx, 8)));  // debug name: char*

  return cast<Function>(Mod.getOrInsertFunction("tesla_debugging", FnType));
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

Function* tesla::CallableInstrumentation(Module& Mod, llvm::StringRef CalledName,
                                         FunctionType *SubType,
                                         FunctionEvent::Direction Dir,
                                         FunctionEvent::CallContext Context,
                                         bool SuppressDebugInstr) {

  LLVMContext& Ctx = Mod.getContext();
  Type *RetType = SubType->getReturnType();

  string Name = (Twine()
    + INSTR_BASE
    + ((Context == FunctionEvent::Callee) ? CALLEE : CALLER)
    + ((Dir == FunctionEvent::Entry) ? ENTER : EXIT)
    + CalledName
  ).str();

  string Tag = (Twine()
    + "["
    + ((Dir == FunctionEvent::Entry) ? "CAL" : "RET")
    + ((Context == FunctionEvent::Callee) ? "E" : "R")
    + "] "
  ).str();


  // Build the instrumentation function's type.
  TypeVector Args(SubType->param_begin(), SubType->param_end());

  if (Dir == FunctionEvent::Exit) {
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
    auto *Entry = CreateInstrPreamble(Mod, InstrFn, Tag + CalledName,
                                      SuppressDebugInstr);
    auto *Exit = BasicBlock::Create(Ctx, "exit", InstrFn);
    IRBuilder<>(Entry).CreateBr(Exit);
    IRBuilder<>(Exit).CreateRetVoid();
  }

  return InstrFn;
}

llvm::Function* tesla::ObjCMethodInstrumentation(llvm::Module& Mod,
                                                 llvm::StringRef Selector,
                                                 llvm::FunctionType* Ty,
                                                 FunctionEvent::Direction Dir,
                                                 FunctionEvent::CallContext Context,
                                                 bool SuppressDebugInstr) {

  
  return CallableInstrumentation(Mod, (Twine() + ".objc_" + Selector +
        ((Context == FunctionEvent::Caller) ? "_caller" : "_callee")).str(),
        Ty, Dir, Context, SuppressDebugInstr);
 
}


Function* tesla::FunctionInstrumentation(Module& Mod, const Function& Subject,
                                         FunctionEvent::Direction Dir,
                                         FunctionEvent::CallContext Context,
                                         bool SuppressDebugInstr) {
  return CallableInstrumentation(Mod, Subject.getName(),
          Subject.getFunctionType(), Dir, Context, SuppressDebugInstr);
}


Function* tesla::StructInstrumentation(Module& Mod, StructType *Type,
                                       StringRef FieldName, size_t FieldIndex,
                                       bool Store, bool SuppressDebugInstr) {

  LLVMContext& Ctx = Mod.getContext();
  StringRef StructName = Type->getName();

  string Name = (Twine()
    + STRUCT_INSTR
    + (Store ? STORE : LOAD)
    + StructName
    + "."
    + FieldName
  ).str();

  // Ensure that the name doesn't include a NULL terminator.
  Name.resize(strnlen(Name.c_str(), Name.length()));

  // The function may already exist...
  //
  // Note: getOrInsertFunction() doesn't seem to return an existing version
  //       of this function; perhaps it's because of the private linkage?
  Function *InstrFn = dyn_cast_or_null<Function>(Mod.getFunction(Name));
  if (InstrFn)
    return InstrFn;

  // The instrumentation function does not exist; we need to build it.
  if (Type->getNumElements() <= FieldIndex)
    panic("struct " + Type->getName() + " does not have "
           + Twine(FieldIndex) + " elements");

  auto *FieldTy = Type->getElementType(FieldIndex);

  // Three arguments: the struct, the new value and a pointer to the field.
  TypeVector Args;
  Args.push_back(PointerType::getUnqual(Type));
  Args.push_back(FieldTy);
  Args.push_back(PointerType::getUnqual(FieldTy));

  auto *Void = Type::getVoidTy(Ctx);
  FunctionType *InstrType = FunctionType::get(Void, Args, false);

  InstrFn = dyn_cast<Function>(Mod.getOrInsertFunction(Name, InstrType));
  assert(InstrFn->empty());

  InstrFn->setLinkage(GlobalValue::PrivateLinkage);

  // Invariant: instrumentation blocks should have two exit blocks: one for
  // normal termination and one for abnormal termination.
  // Debug printf should start with [FGET] or [FSET].
  string Tag = (Twine() + "[F" + (Store ? "SET" : "GET") + "] ").str();
  auto *Entry =
    CreateInstrPreamble(Mod, InstrFn, Tag + StructName + "." + FieldName,
                        SuppressDebugInstr);

  auto *Exit = BasicBlock::Create(Ctx, "exit", InstrFn);
  IRBuilder<>(Entry).CreateBr(Exit);
  IRBuilder<>(Exit).CreateRetVoid();

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
  auto& Ctx = M.getContext();

  Type *IntTy = IntegerType::get(Ctx, 32);
  Type *TransStar = PointerType::getUnqual(TransitionType(M));
  Type *CharStar = PointerType::getUnqual(IntegerType::get(Ctx, 8));

  return StructType::create(Name,
                            IntTy,      // number of possible transitions
                            TransStar,  // transition array
                            CharStar,   // description
                            NULL);
}

BasicBlock* tesla::CreateInstrPreamble(Module& Mod, Function *F,
                                       const Twine& Prefix, bool SuppressDI) {

  auto& Ctx = Mod.getContext();
  auto *Entry = BasicBlock::Create(Ctx, "entry", F);

  if (SuppressDI)
    return Entry;

  auto *Preamble = BasicBlock::Create(Ctx, "preamble", F, Entry);
  auto *PrintBB = BasicBlock::Create(Ctx, "printf", F);
  IRBuilder<> Builder(Preamble);

  // Only print if TESLA_DEBUG indicates that we want output.
  Value *DebugName = Mod.getGlobalVariable("debug_name", true);
  if (!DebugName)
    DebugName = Builder.CreateGlobalStringPtr("tesla.events", "debug_name");

  Value *Debugging = Builder.CreateCall(TeslaDebugging(Mod), DebugName);

  Constant *Zero = ConstantInt::get(IntegerType::get(Ctx, 32), 0);
  Debugging = Builder.CreateICmpNE(Debugging, Zero);

  Builder.CreateCondBr(Debugging, PrintBB, Entry);

  string FormatStr(Prefix.str());
  for (auto& Arg : F->getArgumentList()) FormatStr += Format(Arg.getType());
  FormatStr += "\n";

  ArgVector PrintfArgs(1, Builder.CreateGlobalStringPtr(FormatStr));
  for (auto& Arg : F->getArgumentList()) PrintfArgs.push_back(&Arg);

  IRBuilder<> PrintBuilder(PrintBB);
  PrintBuilder.CreateCall(Printf(Mod), PrintfArgs);
  PrintBuilder.CreateBr(Entry);

  return Entry;
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
      + "cannot be cast from '" + CurrentOut.str()
      + "' to '" + NameOut.str() + "'"
    );
  }

  if (isa<PointerType>(CurrentType))
    return Builder.CreatePointerCast(From, NewType);

  else if (isa<IntegerType>(CurrentType))
    return Builder.CreateIntCast(From, NewType, false);

  llvm_unreachable("failed to cast something castable");
}


BasicBlock* tesla::MatchPattern(LLVMContext& Ctx, StringRef Name, Function *Fn,
                                BasicBlock *MatchTarget,
                                BasicBlock *NonMatchTarget,
                                Value *Val, const tesla::Argument& Pattern) {

  if (Pattern.type() != Argument::Constant)
    return MatchTarget;

  auto *MatchBlock = BasicBlock::Create(Ctx, Name, Fn, MatchTarget);
  MatchTarget->replaceAllUsesWith(MatchBlock);

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

  M.CreateCondBr(Cmp, MatchTarget, NonMatchTarget);

  return MatchBlock;
}


Function* tesla::FindStateUpdateFn(Module& M, Type *IntType) {

  LLVMContext& Ctx = M.getContext();

  Type *Char = IntegerType::get(Ctx, 8);
  Type *CharStar = PointerType::getUnqual(Char);
  Type *TransStar = PointerType::getUnqual(TransitionSetType(M));
  Type *KeyStar = PointerType::getUnqual(KeyType(M));
  Type *Void = Type::getVoidTy(Ctx);

  Constant *Fn = M.getOrInsertFunction("tesla_update_state",
      Void,       // return type
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


Constant* tesla::TeslaContext(AutomatonDescription::Context Context,
                              LLVMContext& Ctx) {
  static Type *IntType = Type::getInt32Ty(Ctx);

  static auto *Global = ConstantInt::get(IntType, TESLA_CONTEXT_GLOBAL);
  static auto *PerThread = ConstantInt::get(IntType, TESLA_CONTEXT_THREAD);

  switch (Context) {
  case AutomatonDescription::Global: return Global;
  case AutomatonDescription::ThreadLocal: return PerThread;
  }
}


Value* tesla::GetArgumentValue(Value* Param, const Argument& ArgDescrip,
                               IRBuilder<>& Builder) {

  switch (ArgDescrip.type()) {
  case Argument::Constant:
    /* constants are handled by instrumentation pattern matchers */
    return NULL;

  case Argument::Any:
    /* ignore: we don't care about this parameter */
    return NULL;

  case Argument::Variable:
    return Param;

  case Argument::Indirect:
    Param = Builder.CreateLoad(Param);
    return GetArgumentValue(Param, ArgDescrip.indirection(), Builder);

  case Argument::Field:
    /* TODO: finish implementing this */
    llvm_unreachable("TESLA: field-indirect instrumentation not implemented");
    return NULL;
  }
}

Value* tesla::ConstructKey(IRBuilder<>& Builder, Module& M,
                           Function::ArgumentListType& InstrArgs,
                           FunctionEvent FnEvent) {

  bool HaveRetVal = FnEvent.has_expectedreturnvalue();
  // The number of hidden arguments, i.e. those that are passed to the function
  // but not present explicitly in the source language.
  const size_t HiddenArgs = ((FnEvent.kind() == FunctionEvent::CCall) ? 0 : 2);
  const size_t TotalArgs = FnEvent.argument_size() + (HaveRetVal ? 1 : 0)
    + HiddenArgs;

  if (InstrArgs.size() != TotalArgs)
    panic(
      "instrumentation for '" + FnEvent.function().name() + "' takes "
      + Twine(InstrArgs.size())
      + " arguments but description in manifest provides "
      + Twine(FnEvent.argument_size())
      + (HaveRetVal ? " and a return value" : "")
    );

  vector<Value*> Args(TotalArgs, NULL);

  // If this is an Objective-C event, then we need to construct the `self` and
  // `_cmd` hidden arguments.  We never care about `_cmd` (it is only relevant
  // for forwarding), but we may care about the receiver.
  // TODO: If we ever care about C++, we should handle `this` here as well.
  if (FnEvent.kind() != FunctionEvent::CCall) {
    int Index = ArgIndex(FnEvent.receiver());
    if (Index >= 0)
      Args[Index] = GetArgumentValue(InstrArgs.begin(), FnEvent.receiver(),
              Builder);
  }

  size_t i = 0;

  for (auto& InstrArg : InstrArgs) {
    // Skip the LLVM arguments that refer to hidden source-language arguments
    // here, as they've already been processed.
    if (i < HiddenArgs) {
      i++;
      continue;
    }

    auto& Arg = (HaveRetVal && (i == (TotalArgs - 1)))
      ? FnEvent.expectedreturnvalue()
      : FnEvent.argument(i - HiddenArgs);
    ++i;

    int Index = ArgIndex(Arg);
    if (Index < 0)
      continue;

    assert(Index < TotalArgs);
    Args[Index] = GetArgumentValue(&InstrArg, Arg, Builder);
  }

  return ConstructKey(Builder, M, Args);
}

Value* tesla::ConstructKey(IRBuilder<>& Builder, Module& M,
                           ArrayRef<Value*> Args) {

  Value *Key = Builder.CreateAlloca(KeyType(M), 0, "key");
  Type *IntPtrTy = IntPtrType(M);
  Type *IntTy = Type::getInt32Ty(M.getContext());

  int KeyMask = 0;

  for (size_t i = 0; i < Args.size(); i++) {
    Value* Arg = Args[i];
    if (Arg == NULL)
      continue;

    assert(i < TESLA_KEY_SIZE);

    Builder.CreateStore(
      Cast(Arg, Twine(i - 1).str(), IntPtrTy, Builder),
      Builder.CreateStructGEP(Key, i));

    KeyMask |= (1 << i);
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
                                      const TEquivalenceClass& Tr) {

  // First convert each individual transition into an llvm::Constant*.
  vector<Constant*> Transitions;
  for (auto T : Tr)
    Transitions.push_back(ConstructTransition(Builder, M, *T));

  // Put them all into a global struct tesla_transitions.
  static StructType *T = TransitionSetType(M);

  Type *IntType = Type::getInt32Ty(M.getContext());
  Constant *Zero = ConstantInt::get(IntType, 0);
  Constant *Zeroes[] = { Zero, Zero };

  Constant *Count = ConstantInt::get(IntType, Transitions.size());

  assert(Tr.size() > 0);
  string Name = "transition_array_" + (*Tr.begin())->String();

  ArrayType *ArrayT = ArrayType::get(TransitionType(M), Transitions.size());
  auto *Array = new GlobalVariable(M, ArrayT, true, GlobalValue::PrivateLinkage,
                                   ConstantArray::get(ArrayT, Transitions),
                                   Name);

  // Create a global variable that points to this structure.
  Constant *ArrayPtr = ConstantExpr::getInBoundsGetElementPtr(Array, Zeroes);

  string Description;
  raw_string_ostream D(Description);
  D << Tr;
  auto *Desc = Builder.CreateGlobalStringPtr(D.str(), Name + "_description");

  Constant *TransitionsInit =
    ConstantStruct::get(T, Count, ArrayPtr, Desc, NULL);

  return new GlobalVariable(M, T, true, GlobalValue::PrivateLinkage,
                            TransitionsInit, "transitions");
}

