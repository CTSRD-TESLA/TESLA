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

#include "InstrContext.h"
#include "TranslationFn.h"

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Module.h>

using namespace llvm;
using namespace tesla;

using std::string;
using std::vector;


InstrContext* InstrContext::Create(Module& M, bool SuppressDebugPrintf)
{
  LLVMContext& Ctx = M.getContext();

  Type *VoidTy = Type::getVoidTy(Ctx);

  IntegerType *CharTy = IntegerType::getInt8Ty(Ctx);
  PointerType *CharPtrTy = PointerType::getUnqual(CharTy);
  PointerType *CharPtrPtrTy = PointerType::getUnqual(CharPtrTy);

  IntegerType *Int32Ty = IntegerType::getInt32Ty(Ctx);
  IntegerType *IntPtrTy = DataLayout(&M).getIntPtrType(Ctx);

  StructType *TransitionTy = StructType::create(
      "tesla_transition",
      Int32Ty, Int32Ty,   // "from" state, mask
      Int32Ty, Int32Ty,   // "to" state, mask
      Int32Ty,            // flags
      NULL);

  PointerType *TransPtrTy = PointerType::getUnqual(TransitionTy);

  StructType *TransitionSetTy = StructType::create(
      "tesla_transitions",
      Int32Ty,         // length
      TransPtrTy,      // transitions array
      NULL);

  StructType *AutomatonTy = StructType::create(
      "tesla_automaton",
      CharPtrTy,           // name
      Int32Ty,             // alphabet size
      TransPtrTy,          // transitions
      CharPtrTy,           // description
      CharPtrPtrTy,        // symbol names
      NULL);

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
                          Int32Ty, IntPtrTy, AutomatonTy,
                          TransitionTy, TransPtrTy, TransitionSetTy,
                          Debugging, Printf, SuppressDebugPrintf);
}

InstrContext::InstrContext(Module& M, LLVMContext& Ctx, Type* VoidTy,
                           IntegerType* CharTy, PointerType* CharPtrTy,
                           PointerType* CharPtrPtrTy,
                           IntegerType* Int32Ty, IntegerType* IntPtrTy,
                           StructType* AutomatonTy,
                           StructType* TransitionTy, PointerType* TransPtrTy,
                           StructType* TransitionSetTy,
                           Constant* Debugging, Constant* Printf,
                           bool SuppressDebugPrintf)
  : M(M), Ctx(Ctx),
    VoidTy(VoidTy),
    CharTy(CharTy), CharPtrTy(CharPtrTy), CharPtrPtrTy(CharPtrPtrTy),
    Int32Ty(Int32Ty), IntPtrTy(IntPtrTy),
    AutomatonTy(AutomatonTy),
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

  default:
    //
    // TODO: translate Objective-C support to this new API
    //
    // name: ".objc_" + Selector
    //        + ((Context == FunctionEvent::Caller) ? "_caller" : "_callee")
    //
    assert(false && "implement Objective-C");
  }

  //
  // If instrumenting return from a non-void function, we need to pass the
  // return value to the instrumentation as a parameter.
  //
  // Otherwise, the instrumentation function will have exactly the same
  // signature as the instrumented function.
  //
  FunctionType *T = Target->getFunctionType();
  Type *RetTy = T->getReturnType();

  if (Ev.direction() == FunctionEvent::Exit and not RetTy->isVoidTy()) {
    vector<Type*> ParamTypes(T->param_begin(), T->param_end());
    ParamTypes.push_back(RetTy);

    T = FunctionType::get(VoidTy, ParamTypes, false);
  }

  return CreateInstrFn(TargetName, T, Ev.direction(), Ev.context());
}


TranslationFn* InstrContext::CreateInstrFn(StringRef TargetName,
                                           FunctionType *InstrType,
                                           FunctionEvent::Direction Dir,
                                           FunctionEvent::CallContext Context)
{
  return TranslationFn::Create(*this, TargetName, InstrType, Dir, Context);
}
