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
#include "State.h"
#include "Transition.h"

#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"

#include "llvm/Support/raw_ostream.h"

using namespace llvm;

using std::string;

namespace tesla {

// ==== TeslaCallerInstrumenter implementation =================================
char TeslaCallerInstrumenter::ID = 0;

TeslaCallerInstrumenter::~TeslaCallerInstrumenter() {
  ::google::protobuf::ShutdownProtobufLibrary();
}

bool TeslaCallerInstrumenter::doInitialization(Module &M) {
  OwningPtr<Manifest> Manifest(Manifest::load(llvm::errs()));
  assert(Manifest);

  bool ModifiedIR = true;

  for (auto i : Manifest->RootAutomata()) {
    auto& A = *Manifest->FindAutomaton(*i);
    for (auto EquivClass : A) {
      assert(!EquivClass.empty());

      auto *Head = dyn_cast<FnTransition>(*EquivClass.begin());
      if (!Head)
        continue;

      auto& FnEvent = Head->FnEvent();
      if (FnEvent.context() != FunctionEvent::Caller)
        continue;

      Function *Target = M.getFunction(FnEvent.function().name());
      if (!Target)
        continue;

      auto *FnInstr = GetOrCreateInstr(M, Target, FnEvent.direction());

      std::vector<struct tesla_transition> Transitions;
      for (auto *T : EquivClass) {
        assert(Head->EquivalentExpression(T) && "not an equivalence class!");

        bool Fork = T->Source().RequiresFork();
        bool Init = T->RequiresInit();
        bool Clean = T->RequiresCleanup();

        int Flags =
          (Fork ? TESLA_TRANS_FORK : 0)
          | (Init ? TESLA_TRANS_INIT : 0)
          | (Clean ? TESLA_TRANS_CLEANUP : 0)
          ;

        struct tesla_transition Trans = {
          .flags  = Flags,
          .mask   = T->Source().Mask(),
          .from   = (uint32_t)T->Source().ID(),
          .to     = (uint32_t)T->Destination().ID()
        };

        Transitions.push_back(Trans);
      }

      FnInstr->AppendInstrumentation(A, FnEvent, Transitions);
      ModifiedIR = true;
    }
  }

  return ModifiedIR;
}


CallerInstrumentation* TeslaCallerInstrumenter::GetOrCreateInstr(
    Module& M, Function *F, FunctionEvent::Direction Dir) {

  assert(F != NULL);
  StringRef Name = F->getName();

  auto& Map = (Dir == FunctionEvent::Entry) ? Calls : Returns;
  CallerInstrumentation *Instr = Map[Name];
  if (!Instr)
    Instr = Map[Name] = CallerInstrumentation::Build(M, F, Dir);

  return Instr;
}


bool TeslaCallerInstrumenter::runOnFunction(Function &Fn) {
  bool modifiedIR = false;

  for (auto &Block : Fn) {
    modifiedIR |= runOnBasicBlock(Block);
  }

  return modifiedIR;
}

bool TeslaCallerInstrumenter::runOnBasicBlock(BasicBlock &Block) {
  bool ModifiedIR = false;

  for (auto &Inst : Block) {
    if (!isa<CallInst>(Inst)) continue;
    CallInst &Call = cast<CallInst>(Inst);
    Function *Callee = Call.getCalledFunction();

    // TODO: handle indirection (e.g. function pointers)?
    if (!Callee)
      continue;

    StringRef Name = Callee->getName();
    if (auto Instr = Calls.lookup(Name))
      ModifiedIR |= Instr->Instrument(Call);

    if (auto Instr = Returns.lookup(Name))
      ModifiedIR |= Instr->Instrument(Call);
  }

  return ModifiedIR;
}


// ==== CallerInstrumentation implementation ===================================
CallerInstrumentation*
    CallerInstrumentation::Build(Module& M, Function *Target,
                                 FunctionEvent::Direction Dir) {

  assert(Target != NULL);

  Function *InstrFn = FunctionInstrumentation(M, *Target, Dir,
                                              FunctionEvent::Caller);

  return new CallerInstrumentation(M, Target, InstrFn, Dir);
}


bool CallerInstrumentation::Instrument(Instruction &Inst) {
  assert(isa<CallInst>(Inst));
  CallInst &Call = cast<CallInst>(Inst);

  ArgVector Args;
  for (size_t i = 0; i < Call.getNumArgOperands(); i++)
    Args.push_back(Call.getArgOperand(i));

  switch (Dir) {
  case FunctionEvent::Entry:
     CallInst::Create(InstrFn, Args)->insertBefore(&Inst);
     break;

  case FunctionEvent::Exit:
    if (!Call.getType()->isVoidTy())
      Args.push_back(&Call);

    CallInst::Create(InstrFn, Args)->insertAfter(&Inst);
    break;
  }

  return true;
}


}

