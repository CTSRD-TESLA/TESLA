/*! @file caller.cpp  Code for instrumenting function calls (caller context). */
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

#include "Caller.h"
#include "Manifest.h"
#include "Names.h"
#include "Transition.h"

#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"

#include "llvm/Support/raw_ostream.h"

using namespace llvm;

using std::string;

namespace tesla {

// ==== CallerInstrumentation implementation ===================================
void CallerInstrumentation::AddDirection(FunctionEvent::Direction Dir) {
  switch (Dir) {
  case FunctionEvent::Entry:   In = true;    break;
  case FunctionEvent::Exit:    Out = true;   break;
  }
}

CallerInstrumentation*
    CallerInstrumentation::Build(Module& M, const FunctionEvent& Ev) {

  StringRef FnName = Ev.function().name();

  Function *Fn = M.getFunction(FnName);
  if (Fn == NULL) return NULL;

  auto C = FunctionEvent::Caller;
  Function *Call = FunctionInstrumentation(M, *Fn, FunctionEvent::Entry, C);
  Function *Return = FunctionInstrumentation(M, *Fn, FunctionEvent::Exit, C);

  return new CallerInstrumentation(Call, Return, Ev.direction());
}

CallerInstrumentation::CallerInstrumentation(
  Function *Entry, Function *Return, FunctionEvent::Direction Dir)
  : In(false), Out(false), CallEvent(Entry), ReturnEvent(Return)
{
  assert(CallEvent != NULL);
  assert(ReturnEvent != NULL);

  AddDirection(Dir);
}

bool CallerInstrumentation::Instrument(Instruction &Inst) {
  assert(isa<CallInst>(Inst));
  CallInst &Call = cast<CallInst>(Inst);

  bool modifiedIR = false;

  ArgVector Args;
  for (size_t i = 0; i < Call.getNumArgOperands(); i++)
    Args.push_back(Call.getArgOperand(i));

  if (In) {
     CallInst::Create(CallEvent, Args)->insertBefore(&Inst);
     modifiedIR = true;
  }

  if (Out) {
    ArgVector RetArgs(Args);
    if (!Call.getType()->isVoidTy()) RetArgs.push_back(&Call);

    CallInst::Create(ReturnEvent, RetArgs)->insertAfter(&Inst);
    modifiedIR = true;
  }

   return modifiedIR;
}


// ==== TeslaCallerInstrumenter implementation =================================
char TeslaCallerInstrumenter::ID = 0;

TeslaCallerInstrumenter::~TeslaCallerInstrumenter() {
  ::google::protobuf::ShutdownProtobufLibrary();
}

bool TeslaCallerInstrumenter::doInitialization(Module &M) {
  OwningPtr<Manifest> Manifest(Manifest::load(llvm::errs()));
  assert(Manifest);

  for (auto i : Manifest->AllAutomata()) {
    auto A = Manifest->FindAutomaton(i.second->identifier(), Automaton::Deterministic);

    for (auto T : *A) {
      if (auto *FnTrans = dyn_cast<FnTransition>(T)) {
        auto Ev = FnTrans->FnEvent();

        if (Ev.context() == FunctionEvent::Callee)
          continue;

        auto Name = Ev.function().name();
        auto *Existing = FunctionsToInstrument[Name];

        if (Existing) Existing->AddDirection(Ev.direction());
        else
          FunctionsToInstrument[Name] = CallerInstrumentation::Build(M, Ev);
      }
    }
  }

  return false;
}

bool TeslaCallerInstrumenter::runOnFunction(Function &Fn) {
  bool modifiedIR = false;

  for (auto &Block : Fn) {
    modifiedIR |= runOnBasicBlock(Block);
  }

  return modifiedIR;
}

bool TeslaCallerInstrumenter::runOnBasicBlock(BasicBlock &Block) {
  bool modifiedIR = false;

  for (auto &Inst : Block) {
    if (!isa<CallInst>(Inst)) continue;
    CallInst &Call = cast<CallInst>(Inst);
    Function *Callee = Call.getCalledFunction();

    // TODO: handle indirection (e.g. function pointers)?
    if (!Callee)
      continue;

    auto I = FunctionsToInstrument.find(Callee->getName());
    if (I == FunctionsToInstrument.end()) continue;

    auto *Instrumenter = I->second;
    assert(Instrumenter != NULL);

    modifiedIR |= Instrumenter->Instrument(Inst);
  }

  return modifiedIR;
}


}

