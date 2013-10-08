//! @file InstrContext.cpp  Definition of @ref InstrContext.
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

#include "Automaton.h"
#include "InstrContext.h"
#include "TranslationFn.h"

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Module.h>

using namespace llvm;
using namespace tesla;

using std::string;
using std::vector;


static StructType* StructTy(StringRef Name, ArrayRef<Type*> Fields, Module& M) {
  StructType *Ty = M.getTypeByName(Name);

  if (Ty == NULL)
    Ty = StructType::create(Fields, Name);

  assert(Ty->getName() == Name);
  return Ty;
}

InstrContext* InstrContext::Create(Module& M, bool SuppressDebugPrintf)
{
  LLVMContext& Ctx = M.getContext();

  Type *VoidTy = Type::getVoidTy(Ctx);

  IntegerType *CharTy = IntegerType::getInt8Ty(Ctx);
  PointerType *CharPtrTy = PointerType::getUnqual(CharTy);
  PointerType *CharPtrPtrTy = PointerType::getUnqual(CharPtrTy);

  IntegerType *Int32Ty = IntegerType::getInt32Ty(Ctx);
  IntegerType *IntPtrTy = DataLayout(&M).getIntPtrType(Ctx);

  // A struct tesla_key is a mask and a set of keys.
  vector<Type*> KeyElements(TESLA_KEY_SIZE, IntPtrTy);
  KeyElements.push_back(Int32Ty);
  StructType *KeyTy = StructTy("tesla_key", KeyElements, M);
  PointerType *KeyPtrTy = PointerType::getUnqual(KeyTy);

  // "from" state and mask, "to" state and mask, flags
  Type *TransFields[] = { Int32Ty, Int32Ty, Int32Ty, Int32Ty, Int32Ty };
  StructType *TransitionTy = StructTy("tesla_transition", TransFields, M);
  PointerType *TransPtrTy = PointerType::getUnqual(TransitionTy);

  // length, array of transitions
  Type *TransSetF[] = { Int32Ty, TransPtrTy };
  StructType *TransitionSetTy = StructTy("tesla_transitions", TransSetF, M);

  // name, alphabet size, transitions, description, symbol names
  Type *AutomFields[] = {
    CharPtrTy, Int32Ty, TransPtrTy, CharPtrTy, CharPtrPtrTy
  };
  StructType *AutomatonTy = StructTy("tesla_automaton", AutomFields, M);
  PointerType *AutomatonPtrTy = PointerType::getUnqual(AutomatonTy);

  Constant *Debugging, *Printf;
  if (SuppressDebugPrintf)
    Debugging = Printf = NULL;

  else {
    // int32_t tesla_debugging(const char*)
    Debugging = M.getOrInsertFunction("tesla_debugging",
        FunctionType::get(Int32Ty, CharPtrTy));

    // int32_t printf(const char*, ...)
    Printf = M.getOrInsertFunction("printf",
        FunctionType::get(Int32Ty, CharPtrTy));
  }

  return new InstrContext(M, Ctx, VoidTy, CharTy, CharPtrTy, CharPtrPtrTy,
                          Int32Ty, IntPtrTy, AutomatonTy, AutomatonPtrTy,
                          KeyTy, KeyPtrTy,
                          TransitionTy, TransPtrTy, TransitionSetTy,
                          Debugging, Printf, SuppressDebugPrintf);
}

InstrContext::InstrContext(Module& M, LLVMContext& Ctx, Type* VoidTy,
                           IntegerType* CharTy, PointerType* CharPtrTy,
                           PointerType* CharPtrPtrTy,
                           IntegerType* Int32Ty, IntegerType* IntPtrTy,
                           StructType* AutomatonTy, PointerType* AutomatonPtrTy,
                           StructType* KeyTy, PointerType* KeyPtrTy,
                           StructType* TransitionTy, PointerType* TransPtrTy,
                           StructType* TransitionSetTy,
                           Constant* Debugging, Constant* Printf,
                           bool SuppressDebugPrintf)
  : M(M), Ctx(Ctx),
    VoidTy(VoidTy),
    CharTy(CharTy), CharPtrTy(CharPtrTy), CharPtrPtrTy(CharPtrPtrTy),
    Int32Ty(Int32Ty), IntPtrTy(IntPtrTy),
    AutomatonTy(AutomatonTy), AutomatonPtrTy(AutomatonPtrTy),
    KeyTy(KeyTy), KeyPtrTy(KeyPtrTy),
    TransitionTy(TransitionTy), TransPtrTy(TransPtrTy),
    TransitionSetTy(TransitionSetTy),
    SuppressDebugPrintf(SuppressDebugPrintf),
    Debugging(Debugging), Printf(Printf)
{
}


TranslationFn* InstrContext::CreateInstrFn(const FunctionEvent& Ev,
                                           Function *Target) {

  string TargetName;

  switch (Ev.kind()) {
  case FunctionEvent::CCall:
    TargetName = Target->getName();
    break;

  case FunctionEvent::ObjCInstanceMessage:
  case FunctionEvent::ObjCClassMessage:
  case FunctionEvent::ObjCSuperMessage:
    //
    // TODO: translate Objective-C support to this new API
    //
    // name: ".objc_" + Selector
    //        + ((Context == FunctionEvent::Caller) ? "_caller" : "_callee")
    //
    assert(false && "implement Objective-C");
  }

  FunctionType *T = Target->getFunctionType();
  vector<Type*> InstrParamTypes(T->param_begin(), T->param_end());

  //
  // If instrumenting return from a non-void function, we need to pass the
  // return value to the instrumentation as a parameter.
  //
  // Otherwise, the instrumentation function will have exactly the same
  // signature as the instrumented function.
  //
  if (Ev.direction() == FunctionEvent::Exit) {
    Type *RetTy = T->getReturnType();

    if (not RetTy->isVoidTy())
      InstrParamTypes.push_back(RetTy);
  }

  //
  // TODO: tack on Objective-C receiver to the end of the arguments
  //
  //InstrParamTypes.push_back(ObjCReceiver);


  T = FunctionType::get(VoidTy, InstrParamTypes, Target->isVarArg());
  return CreateInstrFn(TargetName, T, Ev.direction(), Ev.context());
}


TranslationFn* InstrContext::CreateInstrFn(StringRef TargetName,
                                           FunctionType *InstrType,
                                           FunctionEvent::Direction Dir,
                                           FunctionEvent::CallContext Context)
{
  return TranslationFn::Create(*this, TargetName, InstrType, Dir, Context);
}


Constant* InstrContext::TeslaContext(AutomatonDescription::Context C) {
  static Constant *Global = ConstantInt::get(Int32Ty, TESLA_CONTEXT_GLOBAL);
  static Constant *PerThread = ConstantInt::get(Int32Ty, TESLA_CONTEXT_THREAD);

  switch (C) {
  case AutomatonDescription::Global: return Global;
  case AutomatonDescription::ThreadLocal: return PerThread;
  }
}


Constant* InstrContext::ExternalDescription(const Automaton& A) {
  GlobalVariable *Existing = M.getGlobalVariable(A.Name());
  if (Existing)
    return Existing;

  return new GlobalVariable(M, AutomatonTy, true, GlobalValue::ExternalLinkage,
                            NULL, A.Name());
}


Constant* InstrContext::UpdateStateFn() {
  return M.getOrInsertFunction(
      "tesla_update_state",
      VoidTy,           // return type
      Int32Ty,          // context (global vs per-thread)
      AutomatonPtrTy,   // automaton description
      Int32Ty,          // symbol/event ID
      KeyPtrTy,         // pattern
      NULL
  );
}
