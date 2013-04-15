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
#include "Instrumentation.h"
#include "Manifest.h"
#include "Names.h"
#include "State.h"
#include "Transition.h"

#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/InstIterator.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

using std::string;
using std::vector;

namespace tesla {

// ==== CalleeInstrumenter implementation ======================================
char TeslaCalleeInstrumenter::ID = 0;

TeslaCalleeInstrumenter::~TeslaCalleeInstrumenter() {
  google::protobuf::ShutdownProtobufLibrary();
}

bool TeslaCalleeInstrumenter::runOnModule(Module &M) {
  OwningPtr<Manifest> Manifest(Manifest::load(llvm::errs()));
  if (!Manifest) return false;

  bool ModifiedIR = false;

  for (auto i : Manifest->RootAutomata()) {
    auto& A = *Manifest->FindAutomaton(i->identifier());
    for (auto EquivClass : A) {
      assert(!EquivClass.empty());

      auto *Head = dyn_cast<FnTransition>(*EquivClass.begin());
      if (!Head)
        continue;

      auto& FnEvent = Head->FnEvent();
      if (FnEvent.context() != FunctionEvent::Callee)
        continue;

      Function *Target = M.getFunction(FnEvent.function().name());

      // Only handle functions that are defined in this module.
      if (!Target || Target->empty())
        continue;

      auto *FnInstr = GetOrCreateInstr(M, Target, FnEvent.direction());

      vector<struct tesla_transition> Transitions;
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


CalleeInstr* TeslaCalleeInstrumenter::GetOrCreateInstr(
    Module& M, Function *F, FunctionEvent::Direction Dir) {

  assert(F != NULL);
  StringRef Name = F->getName();

  auto& Map = (Dir == FunctionEvent::Entry) ? Entry : Exit;
  CalleeInstr *Instr = Map[Name];
  if (!Instr)
    Instr = Map[Name] = CalleeInstr::Build(M, F, Dir);

  return Instr;
}



// ==== CalleeInstr implementation ===========================================
CalleeInstr* CalleeInstr::Build(Module& M, Function *Target,
                                FunctionEvent::Direction Dir) {

  // Find (or create) the instrumentation function.
  // Note: it doesn't yet contain the code to translate events and
  //       dispatch them to tesla_update_state().
  Function *InstrFn = FunctionInstrumentation(M, *Target, Dir,
                                              FunctionEvent::Callee);

  // Record the arguments passed to the instrumented function.
  //
  // LLVM's SSA magic will keep these around for us until we need them, even if
  // C code overwrites its parameters.
  ArgVector Args;
  for (auto &Arg : Target->getArgumentList())
    Args.push_back(&Arg);

  // Instrument either the entry or return points of the target function.
  switch (Dir) {
  case FunctionEvent::Entry: {
    // Instrumenting function entry is easy: just add a new call to
    // instrumentation at the beginning of the function's entry block.
    BasicBlock& Entry = Target->getEntryBlock();
    CallInst::Create(InstrFn, Args)->insertBefore(Entry.getFirstNonPHI());
    break;
  }

  case FunctionEvent::Exit: {
    SmallPtrSet<ReturnInst*, 16> Returns;
    for (auto i = inst_begin(Target), End = inst_end(Target); i != End; i++)
      if (auto *Return = dyn_cast<ReturnInst>(&*i))
        Returns.insert(Return);

    for (ReturnInst *Return : Returns) {
      ArgVector InstrArgs(Args);

      if (Dir == FunctionEvent::Exit && !Target->getReturnType()->isVoidTy())
        InstrArgs.push_back(Return->getReturnValue());

      CallInst::Create(InstrFn, InstrArgs)->insertBefore(Return);
    }
    break;
  }
  }

  return new CalleeInstr(M, Target, InstrFn, Dir);
}


CalleeInstr::CalleeInstr(Module& M, Function *Target, Function *InstrFn,
                             FunctionEvent::Direction Dir)
  : FnInstrumentation(M, Target, InstrFn, Dir)
{
  assert(TargetFn != NULL);
  assert(InstrFn != NULL);

  // Record the arguments passed to the instrumented function.
  //
  // LLVM's SSA magic will keep these around for us until we need them, even if
  // C code overwrites its parameters.
  for (auto &Arg : Target->getArgumentList())
    Args.push_back(&Arg);
}

} /* namespace tesla */

