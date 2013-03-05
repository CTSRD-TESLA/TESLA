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

  Type* IntType = Type::getInt32Ty(M.getContext());

  for (Function *InstrFn : FindInstrumentation(FnEvent, M)) {
    assert(InstrFn != NULL);
    LLVMContext& Ctx = InstrFn->getContext();

    // The instrumentation function should always end in a RetVoid;
    // assert this is so and then trim it so we can add new stuff.
    // FIXME: This relies on an invariant (basic block ordering) that is NOT
    // guaranteed and is liable to change!
    auto& PreviousEndBlock = InstrFn->back();
    assert(PreviousEndBlock.getTerminator()->getNumSuccessors() == 0);
    PreviousEndBlock.getTerminator()->eraseFromParent();

    auto Block = BasicBlock::Create(Ctx, A.Name(), InstrFn);
    IRBuilder<>(&PreviousEndBlock).CreateBr(Block);

    IRBuilder<> Builder(Block);

    auto Die = BasicBlock::Create(Ctx, "die", InstrFn);
    IRBuilder<> ErrorHandler(Die);

    auto *ErrMsg = ErrorHandler.CreateGlobalStringPtr(
      "error in tesla_update_state() for automaton '" + A.Name() + "'");

    ErrorHandler.CreateCall(FindDieFn(M), ErrMsg);
    ErrorHandler.CreateRetVoid();

    auto Next = BasicBlock::Create(Ctx, "next", InstrFn);
    auto Exit = BasicBlock::Create(Ctx, "exit", InstrFn);
    IRBuilder<>(Exit).CreateRetVoid();

    if (FnEvent.has_expectedreturnvalue()) {
      const Argument &Arg = FnEvent.expectedreturnvalue();
      if (Arg.type() == Argument::Constant) {
        Value *ReturnVal = --(InstrFn->arg_end());
        Value *ExpectedReturnVal = ConstantInt::getSigned(ReturnVal->getType(),
            Arg.int_value());
        Builder.CreateCondBr(Builder.CreateICmpNE(ReturnVal,
              ExpectedReturnVal), Exit, Next);
        Builder.SetInsertPoint(Next);
      }
    }
    if (Builder.GetInsertBlock() != Next) {
      Next->removeFromParent();
      delete Next;
    }

    Constant* TransArray[] = {
      ConstructTransition(Builder, M,
                          T.Source().ID(), T.Source().Mask(),
                          T.Destination().ID())
    };
    ArrayRef<Constant*> TransRef(TransArray,
                                 sizeof(TransArray) / sizeof(Constant*));

    vector<Value*> Args;
    Args.push_back(TeslaContext(A.getAssertion().context(), Ctx));
    Args.push_back(ConstantInt::get(IntType, A.ID()));
    Args.push_back(ConstructKey(Builder, M,
                                InstrFn->getArgumentList(),
                                T.FnEvent()));
    Args.push_back(Builder.CreateGlobalStringPtr(A.Name()));
    Args.push_back(Builder.CreateGlobalStringPtr(A.String()));
    Args.push_back(ConstructTransitions(Builder, M, TransRef));

    Function *UpdateStateFn = FindStateUpdateFn(M, IntType);
    assert(Args.size() == UpdateStateFn->arg_size());


    Value *Error = Builder.CreateCall(UpdateStateFn, Args);
    Constant *NoError = ConstantInt::get(IntType, TESLA_SUCCESS);
    Error = Builder.CreateICmpEQ(Error, NoError);

    Builder.CreateCondBr(Error, Exit, Die);
  }

  return true;
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
    report_fatal_error(
      "instrumentation function takes "
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

Constant* tesla::ConstructTransition(IRBuilder<>& Builder,
                                     llvm::Module& M,
                                     uint32_t From, uint32_t Mask,
                                     uint32_t To, bool AlwaysFork) {

  assert(From != To);

  uint32_t Values[] = { From, Mask, To, AlwaysFork };
  Type *IntType = Type::getInt32Ty(M.getContext());

  vector<Constant*> Elements;
  for (size_t i = 0; i < 4; i++)
    Elements.push_back(ConstantInt::get(IntType, Values[i]));

  return ConstantStruct::get(TransitionType(M), Elements);
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

