//! @file InstrContext.cpp  Definition of @ref tesla::InstrContext.
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
#include "State.h"
#include "SuperFastHash.h"
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

  // A lifetime event contains an opaque representation, a length and a hash.
  Type* LifeEvFields[] = { CharPtrTy, Int32Ty, Int32Ty };
  StructType *LifeEventTy = StructTy("tesla_lifetime_event", LifeEvFields, M);

  // A lifetime contains two events (entry and exit) and a description (char*).
  Type* LifeFields[] = { LifeEventTy, LifeEventTy, CharPtrTy };
  StructType *LifetimeTy = StructTy("tesla_lifetime", LifeFields, M);
  PointerType *LifetimePtrTy = PointerType::getUnqual(LifetimeTy);

  // "from" state and mask, "to" state and mask, flags
  Type *TransFields[] = { Int32Ty, Int32Ty, Int32Ty, Int32Ty, Int32Ty };
  StructType *TransitionTy = StructTy("tesla_transition", TransFields, M);
  PointerType *TransPtrTy = PointerType::getUnqual(TransitionTy);

  // length, array of transitions
  Type *TransSetF[] = { Int32Ty, TransPtrTy };
  StructType *TransitionSetTy = StructTy("tesla_transitions", TransSetF, M);
  PointerType *TransitionSetPtrTy = PointerType::getUnqual(TransitionSetTy);

  // name, alphabet size, cleanup symbol, transitions, description, symbol names
  Type *AutomFields[] = {
    CharPtrTy, Int32Ty, Int32Ty, TransitionSetPtrTy, CharPtrTy, CharPtrPtrTy,
    LifetimePtrTy,
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
                          LifetimeTy, LifetimePtrTy, LifeEventTy,
                          TransitionTy, TransPtrTy,
                          TransitionSetTy, TransitionSetPtrTy,
                          Debugging, Printf, SuppressDebugPrintf);
}

InstrContext::InstrContext(Module& M, LLVMContext& Ctx, Type* VoidTy,
                           IntegerType* CharTy, PointerType* CharPtrTy,
                           PointerType* CharPtrPtrTy,
                           IntegerType* Int32Ty, IntegerType* IntPtrTy,
                           StructType* AutomatonTy, PointerType* AutomatonPtrTy,
                           StructType* KeyTy, PointerType* KeyPtrTy,
                           StructType* LifetimeTy, PointerType* LifetimePtrTy,
                           StructType* LifetimeEventTy,
                           StructType* TransitionTy, PointerType* TransPtrTy,
                           StructType* TransitionSetTy,
                           PointerType* TransitionSetPtrTy,
                           Constant* Debugging, Constant* Printf,
                           bool SuppressDebugPrintf)
  : M(M), Ctx(Ctx),
    VoidTy(VoidTy),
    CharTy(CharTy), CharPtrTy(CharPtrTy), CharPtrPtrTy(CharPtrPtrTy),
    Int32Ty(Int32Ty), IntPtrTy(IntPtrTy),
    AutomatonTy(AutomatonTy), AutomatonPtrTy(AutomatonPtrTy),
    KeyTy(KeyTy), KeyPtrTy(KeyPtrTy),
    LifetimeTy(LifetimeTy), LifetimePtrTy(LifetimePtrTy),
    LifetimeEventTy(LifetimeEventTy),
    TransitionTy(TransitionTy), TransPtrTy(TransPtrTy),
    TransitionSetTy(TransitionSetTy), TransitionSetPtrTy(TransitionSetPtrTy),
    SuppressDebugPrintf(SuppressDebugPrintf),
    Debugging(Debugging), Printf(Printf)
{
  assert((Debugging != NULL and Printf != NULL)
         or SuppressDebugPrintf);
}


Constant* InstrContext::BuildAutomatonDescription(const Automaton *A) {
  const string Name(A->Name());

  //
  // If there is already a global variable with this automaton's name, it
  // had better be an extern reference: only the assertion instrumenter
  // should call this method and it should only do so once per automaton.
  //
  auto *Existing = M.getGlobalVariable(Name);
  if (Existing)
    assert(!Existing->hasInitializer());

  vector<Constant*> Transitions;
  vector<Constant*> EventDescriptions;

  for (const TEquivalenceClass& Tr : *A) {
    string Descrip((*Tr.begin())->String());

    Transitions.push_back(BuildTransitions(Tr));
    EventDescriptions.push_back(ConstStr(Descrip));
  }

  //
  // The members of a struct tesla_automaton are:
  //
  // name: char*
  // alphabet size: int32_t
  // transitions: struct tesla_transitions*
  // description: char*
  // symbol names: char**
  //
  Constant *AlphabetSize = ConstantInt::get(Int32Ty, Transitions.size());
  Constant *Description = ConstStr(A->SourceCode(), Name + "_description");

  ArrayType *SymbolArrayT = ArrayType::get(CharPtrTy, EventDescriptions.size());
  Constant *SymbolNames =
    ConstPointer(ConstantArray::get(SymbolArrayT, EventDescriptions),
                 CharPtrPtrTy, Name + "_symbol_names");

  Constant *CleanupSymbol = ConstantInt::get(Int32Ty, A->Cleanup().Symbol);

  ArrayType *TransArrayT = ArrayType::get(TransitionSetTy, Transitions.size());
  Constant *TransArray = ConstantArray::get(TransArrayT, Transitions);
  Constant *TransArrayPtr = ConstPointer(TransArray,
                                         PointerType::getUnqual(TransArrayT),
                                         Name + "_transitions");

  Constant *TransitionsArray = ConstArrayPointer(TransArrayPtr);

  Constant *Lifetime = BuildLifetime(A->getLifetime());

  //
  // Create the global variable and its (constant) initialiser.
  //
  Constant *Init = ConstantStruct::get(AutomatonTy,
                                       ConstStr(Name, Name + "_name"),
                                       AlphabetSize,
                                       CleanupSymbol,
                                       TransitionsArray,
                                       Description,
                                       SymbolNames,
                                       Lifetime,
                                       NULL);

  GlobalVariable *Automaton
    = new GlobalVariable(M, AutomatonTy, true,
                         GlobalValue::ExternalLinkage,
                         Init, Name);


  //
  // If there is already a variable with the same name, it is an extern
  // declaration; replace it with this definition.
  //
  if (Existing) {
    Existing->replaceAllUsesWith(Automaton);
    Existing->removeFromParent();
    delete Existing;

    Automaton->setName(A->Name());
  }

  return Automaton;
}


Constant* InstrContext::BuildLifetimeEvent(const Transition& T) {
  string Protobuf;

  __debugonly bool Success = T.Protobuf()->SerializeToString(&Protobuf);
  assert(Success);

  int32_t HashValue = SuperFastHash(Protobuf.c_str(), Protobuf.length());

  Constant *Repr = ConstStr(Protobuf, T.ShortLabel() + ":protobuf");
  Constant *Length = ConstantInt::get(Int32Ty, Protobuf.length());
  Constant *Hash = ConstantInt::get(Int32Ty, HashValue);

  StructType *Ty = LifetimeEventTy;

  return ConstantStruct::get(Ty, Repr, Length, Hash, NULL);
}


Constant* InstrContext::BuildTransition(const Transition& T) {
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

  vector<Constant*> Elements;
  for (auto Val : Values)
    Elements.push_back(ConstantInt::get(Int32Ty, Val));

  return ConstantStruct::get(TransitionTy, Elements);
}


Constant* InstrContext::BuildLifetime(const Automaton::Lifetime& Lifetime) {
  assert(Lifetime.Init != NULL and Lifetime.Cleanup != NULL);

  const Transition& Sunrise = *Lifetime.Init;
  const Transition& Sunset = *Lifetime.Cleanup;

  string Name =
    "("
    + Sunrise.ShortLabel()
    + " -> "
    + Sunset.ShortLabel()
    + ")";

  auto *Existing = M.getGlobalVariable(Name);
  if (Existing)
    return Existing;

  Constant *Initialiser = ConstantStruct::get(LifetimeTy,
                                              BuildLifetimeEvent(Sunrise),
                                              BuildLifetimeEvent(Sunset),
                                              ConstStr(Name),
                                              NULL);

  return new GlobalVariable(M, LifetimeTy, true,
                            GlobalVariable::InternalLinkage,
                            Initialiser, Name);
}


Constant* InstrContext::BuildTransitions(const TEquivalenceClass& Tr) {
  assert(!Tr.empty());

  string Name(("sym" + Twine(Tr.Symbol)).str());
  string Description((*Tr.begin())->String());

  // First convert each individual transition into an llvm::Constant*.
  vector<Constant*> Transitions;
  for (auto T : Tr)
    Transitions.push_back(BuildTransition(*T));

  // Put them all into a global struct tesla_transitions.
  Constant *Count = ConstantInt::get(Int32Ty, Transitions.size());

  ArrayType *ArrayT = ArrayType::get(TransitionTy, Transitions.size());
  GlobalVariable *Array =
    new GlobalVariable(M, ArrayT, true, GlobalValue::PrivateLinkage,
                       ConstantArray::get(ArrayT, Transitions),
                       "transition_array_" + Name);

  Constant *ArrayPtr = ConstArrayPointer(Array);

  return ConstantStruct::get(TransitionSetTy, Count, ArrayPtr, NULL);
}


Constant* InstrContext::ConstArrayPointer(Constant *Array) {
  static Constant *Zero = ConstantInt::get(Int32Ty, 0);
  static Constant *Zeroes[] = { Zero, Zero };
  return ConstantExpr::getInBoundsGetElementPtr(Array, Zeroes);
}


Constant* InstrContext::ConstPointer(Constant *C, Type *T, StringRef Name) {
  return ConstantExpr::getPointerCast(
      new GlobalVariable(M, C->getType(), true,
                         GlobalVariable::InternalLinkage, C, Name),
      T
  );
}


Constant* InstrContext::ConstStr(StringRef S, StringRef Name) {
  return ConstPointer(ConstantDataArray::getString(Ctx, S), CharPtrTy, Name);
}


TranslationFn* InstrContext::CreateInstrFn(const Automaton& A,
                                           ArrayRef<Value*> AssertArgs)
{
  const string Name = "assertion_" + A.Name();
  const string PrintfPrefix = ("[ASRT] automaton " + Twine(A.ID())).str();

  vector<Type*> ArgTypes;
  for (auto *Arg : AssertArgs)
    ArgTypes.push_back(Arg->getType());

  FunctionType *InstrType = FunctionType::get(VoidTy, ArgTypes, false);

  return TranslationFn::Create(*this, Name, InstrType, PrintfPrefix,
                               GlobalValue::InternalLinkage);
}


TranslationFn* InstrContext::CreateInstrFn(const FunctionEvent& Ev,
                                           FunctionType *TargetType) {

  string TargetName;

  switch (Ev.kind()) {
  case FunctionEvent::CCall:
    TargetName = Ev.function().name();
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

  const bool IsCalleeContext = (Ev.context() == FunctionEvent::Callee);
  const bool IsEntry = (Ev.direction() == FunctionEvent::Entry);

  const string InstrName = (Twine()
    + (IsCalleeContext ? CALLEE : CALLER)
    + (IsEntry ? ENTER : EXIT)
    + TargetName
  ).str();

  const string PrintfPrefix = (Twine()
    + "["
    + (IsEntry ? "CAL" : "RET")
    + (IsCalleeContext ? "E" : "R")
    + "] "
    + TargetName
  ).str();

  //
  // Caller-context instrumentation may be declared in any translation unit,
  // with different definitions in each. Use private linkage to ensure these
  // definitions do not conflict.
  //
  GlobalValue::LinkageTypes Linkage = IsCalleeContext
                                      ? GlobalValue::ExternalLinkage
                                      : GlobalValue::PrivateLinkage;

  FunctionType *T = TargetType;
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


  T = FunctionType::get(VoidTy, InstrParamTypes, TargetType->isVarArg());
  return TranslationFn::Create(*this, InstrName, T, PrintfPrefix, Linkage);
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


Constant* InstrContext::SunriseFn() {
  return M.getOrInsertFunction(
      "tesla_sunrise",
      VoidTy,           // return type
      Int32Ty,          // context (global vs per-thread)
      LifetimePtrTy,    // static lifetime description
      NULL
  );
}


Constant* InstrContext::SunsetFn() {
  return M.getOrInsertFunction(
      "tesla_sunset",
      VoidTy,           // return type
      Int32Ty,          // context (global vs per-thread)
      LifetimePtrTy,    // static lifetime description
      NULL
  );
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
