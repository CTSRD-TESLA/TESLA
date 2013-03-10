/*! @file Callee.cpp  Code for instrumenting function calls (callee context). */
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
#include "Callee.h"
#include "Manifest.h"
#include "Names.h"
#include "Transition.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

using std::string;
using std::vector;

namespace tesla {

// ==== CalleeInstrumentation implementation ===================================
void CalleeInstrumentation::AddDirection(FunctionEvent::Direction Dir) {
  switch (Dir) {
  case FunctionEvent::Entry:   In = true;    break;
  case FunctionEvent::Exit:    Out = true;   break;
  }
}

bool CalleeInstrumentation::InstrumentEntry(Function &Fn) {
  if (&Fn != this->Fn) return false;
  if (!In) return false;
  assert(EntryEvent != NULL);

  // Instrumenting function entry is easy: just add a new call to
  // instrumentation at the beginning of the function's entry block.
  BasicBlock& Entry = Fn.getEntryBlock();
  CallInst::Create(EntryEvent, Args)->insertBefore(Entry.getFirstNonPHI());

  return true;
}

bool CalleeInstrumentation::InstrumentReturn(Function &Fn) {
  if (&Fn != this->Fn) return false;
  if (!Out) return false;
  assert(ReturnEvent != NULL);

  bool ModifiedIR = false;

  // First, build up the set of blocks that return from the function.
  vector<BasicBlock*> ReturnBlocks;

  // We explicitly iterate over BasicBlocks (rather than using an InstIterator)
  // because we need the blocks themselves (later, we'll split them).
  for (auto &Block : Fn) {
    auto *Return = dyn_cast<ReturnInst>(Block.getTerminator());
    if (Return) ReturnBlocks.push_back(&Block);
  }

  // Finally, instrument the returns.
  for (auto *Block : ReturnBlocks) {
    auto *Return = cast<ReturnInst>(Block->getTerminator());
    Value *RetVal = Return->getReturnValue();

    ArgVector InstrumentationArgs(Args);
    if (RetVal) InstrumentationArgs.push_back(RetVal);

    CallInst::Create(ReturnEvent, InstrumentationArgs)->insertBefore(Return);
    ModifiedIR = true;
  }

  return ModifiedIR;
}

CalleeInstrumentation*
    CalleeInstrumentation::Build(Module& M, const FnTransition& FnTrans) {

  auto FnEvent = FnTrans.FnEvent();
  auto FnRef = FnEvent.function();
  StringRef Name = FnRef.name();
  Function *Fn = M.getFunction(Name);

  Function *Entry = NULL;
  Function *Return = NULL;

  if (Fn) {
    auto Context = FunctionEvent::Callee;

    Entry = FunctionInstrumentation(M, *Fn, FunctionEvent::Entry, Context);
    Return = FunctionInstrumentation(M, *Fn, FunctionEvent::Exit, Context);
  }

  return new CalleeInstrumentation(Fn, Entry, Return, FnEvent.direction());
}

CalleeInstrumentation::CalleeInstrumentation(
  Function *Fn, Function *Entry, Function *Return, FunctionEvent::Direction Dir)
  : Fn(Fn), In(false), Out(false), EntryEvent(Entry), ReturnEvent(Return) {

  // Record the arguments passed to the instrumented function.
  //
  // LLVM's SSA magic will keep these around for us until we need them, even if
  // C code overwrites its parameters.
  for (auto &Arg : Fn->getArgumentList()) Args.push_back(&Arg);

  AddDirection(Dir);
}


// ==== CalleeInstrumenter implementation ======================================
char TeslaCalleeInstrumenter::ID = 0;

TeslaCalleeInstrumenter::~TeslaCalleeInstrumenter() {
  google::protobuf::ShutdownProtobufLibrary();
}

bool TeslaCalleeInstrumenter::doInitialization(Module &M) {
  OwningPtr<Manifest> Manifest(Manifest::load(llvm::errs()));
  if (!Manifest) return false;

  bool ModifiedIR = false;

  for (auto i : Manifest->AllAutomata()) {
    auto A = *Manifest->FindAutomaton(i.first);
    for (auto T : A) {
      auto FnTrans = dyn_cast<FnTransition>(T);
      if (!FnTrans)
        continue;

      auto FnEvent = FnTrans->FnEvent();
      StringRef Name = FnEvent.function().name();

      // Only build instrumentation for this module's functions.
      Function *Target = M.getFunction(Name);
      if (!Target || Target->empty())
        continue;

      // If instrumentation is already defined, just record the direction.
      auto *Existing = FunctionsToInstrument[Name];
      if (Existing) {
        Existing->AddDirection(FnEvent.direction());
        continue;
      }

      FunctionsToInstrument[Name] = CalleeInstrumentation::Build(M, *FnTrans);

      ModifiedIR = true;
    }
  }

  return ModifiedIR;
}

bool TeslaCalleeInstrumenter::runOnFunction(Function &F) {
  auto I = FunctionsToInstrument.find(F.getName());
  if (I == FunctionsToInstrument.end()) return false;

  auto *FnInstrumenter = I->second;
  assert(FnInstrumenter != NULL);

  bool modifiedIR = false;
  modifiedIR |= FnInstrumenter->InstrumentEntry(F);
  modifiedIR |= FnInstrumenter->InstrumentReturn(F);

  return modifiedIR;
}

} /* namespace tesla */

