/*! @file Assertion.cpp  Code for instrumenting TESLA assertion sites. */
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

#include "Assertion.h"
#include "Automaton.h"
#include "Debug.h"
#include "EventTranslator.h"
#include "InstrContext.h"
#include "Instrumentation.h"
#include "Manifest.h"
#include "Names.h"
#include "State.h"
#include "Transition.h"
#include "TranslationFn.h"

#include "tesla.pb.h"

#include <libtesla.h>

#include <llvm/IR/Function.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/raw_ostream.h>

#include <set>

using namespace llvm;

using std::set;
using std::string;
using std::vector;


namespace tesla {

char AssertionSiteInstrumenter::ID = 0;

AssertionSiteInstrumenter::~AssertionSiteInstrumenter() {
  ::google::protobuf::ShutdownProtobufLibrary();
}

bool AssertionSiteInstrumenter::runOnModule(Module &M) {
  InstrCtx.reset(InstrContext::Create(M, SuppressDebugInstr));

  // If this module doesn't declare any assertions, just carry on.
  AssertFn = M.getFunction(INLINE_ASSERTION);
  if (!AssertFn)
    return false;

  // Find all calls to TESLA assertion pseudo-function (before we modify IR).
  set<CallInst*> AssertCalls;
  for (auto I = AssertFn->use_begin(); I != AssertFn->use_end(); ++I)
    AssertCalls.insert(cast<CallInst>(*I));

  return ConvertAssertions(AssertCalls, M);
}


bool AssertionSiteInstrumenter::ConvertAssertions(
    set<CallInst*>& AssertCalls, Module& Mod) {

  for (auto *AssertCall : AssertCalls) {
    auto *Automaton(FindAutomaton(AssertCall));
    auto AssertTransitions(this->AssertTrans(Automaton));

    // Generate the static automaton description.
    InstrCtx->BuildAutomatonDescription(Automaton);

    // Convert the assertion into appropriate instrumentation.
    IRBuilder<> Builder(AssertCall);
    vector<Value*> Args(CollectArgs(AssertCall, *Automaton, Mod, Builder));

    TranslationFn *TransFn = InstrCtx->CreateInstrFn(*Automaton, Args);
    TransFn->InsertCallBefore(AssertCall, Args);

    EventTranslator E = TransFn->AddInstrumentation(*Automaton);
    E.CallUpdateState(*Automaton, AssertTransitions.Symbol);

    // Delete the call to the assertion pseudo-function.
    AssertCall->removeFromParent();
    delete AssertCall;
  }

  AssertFn->removeFromParent();
  delete AssertFn;

  return true;
}


const Automaton* AssertionSiteInstrumenter::FindAutomaton(CallInst *Call) {
  Location Loc;
  ParseAssertionLocation(&Loc, Call);

  return M.FindAutomaton(Loc);
}


TEquivalenceClass AssertionSiteInstrumenter::AssertTrans(const Automaton *A) {
  for (auto EquivClass : *A)
    if (isa<AssertTransition>(*EquivClass.begin()))
      return EquivClass;

  panic("automaton '" + A->Name() + "' has no assertion site event");
}


vector<Value*> AssertionSiteInstrumenter::CollectArgs(
    Instruction *Before, const Automaton& A,
    Module& Mod, IRBuilder<>& Builder) {

  // Find named values to be passed to instrumentation.
  std::map<string,Value*> ValuesInScope;
  for (auto G = Mod.global_begin(); G != Mod.global_end(); G++)
    ValuesInScope[G->getName()] = G;

  auto *Fn = Before->getParent()->getParent();
  for (auto& Arg : Fn->getArgumentList())
    ValuesInScope[Arg.getName()] = &Arg;

  auto& EntryBlock(*Fn->begin());
  for (auto& I : EntryBlock) {
    auto *Inst = dyn_cast<AllocaInst>(&I);
    if (!Inst)
      break;

    ValuesInScope[Inst->getName()] = Builder.CreateLoad(Inst);
  }

  int ArgSize = 0;
  for (auto& Arg : A.getAssertion().argument())
    if (!Arg.free())
      ArgSize = std::max(ArgSize + 1, Arg.index());

  vector<Value*> Args(ArgSize, NULL);

  for (auto& Arg : A.getAssertion().argument()) {
    if (Arg.free())
      continue;

    string Name(BaseName(Arg));

    if (ValuesInScope.find(Name) == ValuesInScope.end()) {
      string s;
      raw_string_ostream Out(s);

      for (auto v : ValuesInScope) {
        Out << "  \"" << v.first << "\": ";
        v.second->getType()->print(Out);
        Out << "\n";
      }

      panic("assertion references non-existent variable '" + BaseName(Arg)
         + "'; was it defined under '#ifdef TESLA'?\n\n"
           "Variables in scope are:\n" + Out.str());
    }

    Args[Arg.index()] =
      GetArgumentValue(ValuesInScope[Name], Arg, Builder, true);
  }

  return Args;
}


void AssertionSiteInstrumenter::ParseAssertionLocation(
  Location *Loc, CallInst *Call) {

  assert(Call->getCalledFunction()->getName() == INLINE_ASSERTION);

  if (Call->getNumArgOperands() < 4)
    panic("TESLA assertion must have at least 4 arguments");

  // The filename (argument 1) should be a global variable.
  GlobalVariable *NameVar =
    dyn_cast<GlobalVariable>(Call->getOperand(1)->stripPointerCasts());

  ConstantDataArray *A;
  if (!NameVar ||
      !(A = dyn_cast_or_null<ConstantDataArray>(NameVar->getInitializer()))) {
    Call->dump();
    panic("unable to parse filename from TESLA assertion");
  }

  *Loc->mutable_filename() = A->getAsString();


  // The line and counter values should be constant integers.
  ConstantInt *Line = dyn_cast<ConstantInt>(Call->getOperand(2));
  if (!Line) {
    Call->getOperand(2)->dump();
    panic("assertion line must be a constant int");
  }

  Loc->set_line(Line->getLimitedValue(INT_MAX));

  ConstantInt *Count = dyn_cast<ConstantInt>(Call->getOperand(3));
  if (!Count) {
    Call->getOperand(3)->dump();
    panic("assertion count must be a constant int");
  }

  Loc->set_counter(Count->getLimitedValue(INT_MAX));
}

}
