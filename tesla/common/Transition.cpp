/*! @file Transition.cpp  Definition of @ref tesla::Transition, subclasses. */
/*
 * Copyright (c) 2013 Jonathan Anderson
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

#include "Debug.h"
#include "Protocol.h"
#include "State.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <llvm/ADT/Twine.h>
#include <llvm/Support/raw_ostream.h>

#include <sstream>

using namespace llvm;
using std::string;

namespace tesla {


void Transition::Create(State& From, State& To, TransitionVector& Transitions,
                        bool Init, bool Cleanup) {
  OwningPtr<Transition> T(new NullTransition(From, To, Init, Cleanup));
  Register(T, From, To, Transitions);
}

void Transition::Create(State& From, State& To, const AssertionSite& A,
                        const AutomatonDescription& Automaton,
                        TransitionVector& Transitions,
                        bool Init, bool Cleanup) {

  ReferenceVector Refs(Automaton.argument().data(), Automaton.argument_size());

  OwningPtr<Transition> T(
    new AssertTransition(From, To, A, Refs, Init, Cleanup));
  Register(T, From, To, Transitions);
}

void Transition::Create(State& From, State& To, const FunctionEvent& Ev,
                        TransitionVector& Transitions, bool Init, bool Cleanup,
                        bool OutOfScope) {

  OwningPtr<Transition> T(
    new FnTransition(From, To, Ev, Init, Cleanup, OutOfScope));

  Register(T, From, To, Transitions);
}

void Transition::Create(State& From, State& To, const FieldAssignment& A,
                        TransitionVector& Transitions, bool Init, bool Cleanup,
                        bool OutOfScope) {

  OwningPtr<Transition> T(
    new FieldAssignTransition(From, To, A, Init, Cleanup, OutOfScope));

  Register(T, From, To, Transitions);
}

void Transition::CreateSubAutomaton(State& From, State& To,
                                    const Identifier& ID,
                                    TransitionVector& Transitions) {

  OwningPtr<Transition> T(new SubAutomatonTransition(From, To, ID));
  Register(T, From, To, Transitions);
}

void Transition::Copy(State &From, State& To, const Transition* Other,
                      TransitionVector& Transitions, bool OutOfScope) {

  OwningPtr<Transition> New;
  bool Init = Other->RequiresInit();
  bool Cleanup = Other->RequiresCleanup();

  OutOfScope |= Other->OutOfScope;
  assert(!Init || !OutOfScope);

  switch (Other->getKind()) {
  case Null:
    assert(!OutOfScope);
    return;

  case AssertSite: {
    assert(!OutOfScope);
    auto O = cast<AssertTransition>(Other);
    New.reset(new AssertTransition(From, To, O->A, O->Refs, Init, Cleanup));
    break;
  }

  case Fn:
    New.reset(new FnTransition(From, To, cast<FnTransition>(Other)->Ev,
                               Init, Cleanup, OutOfScope));
    break;

  case FieldAssign:
    New.reset(new FieldAssignTransition(
                  From, To, cast<FieldAssignTransition>(Other)->Assign,
                  Init, Cleanup, OutOfScope));
    break;

  case SubAutomaton:
    assert(!OutOfScope);
    New.reset(new SubAutomatonTransition(From, To,
                  cast<SubAutomatonTransition>(Other)->ID));
    break;
  }

  assert(New);
  Register(New, From, To, Transitions);
}

void Transition::Register(OwningPtr<Transition>& T, State& From, State& To,
                          TransitionVector& Transitions) {

  Transitions.push_back(T.get());
  debugs("tesla.automata.transitions") << "registered " << T->String() << "\n";

  // We should never try to update the start state's references.
  assert(To.ID() != 0);

  // Update the state we're pointing to with the references it should
  // know about thus far in the execution of the automaton.
  To.UpdateReferences(*T.get());
  From.AddTransition(T);
}

void Transition::GroupClasses(const TransitionVector& Ungrouped,
                              TransitionSets& EquivalenceClasses) {

  auto& Out = debugs("tesla.automata.transitions.equivalence");
  Out << "grouping transitions:\n";

  for (auto *T : Ungrouped) {
    Out << "  " << T->String() << "\n";

    bool FoundEquivalent = false;
    for (auto& Set : EquivalenceClasses) {
      auto *Head = *Set.begin();
      if (T->EquivalentTo(*Head)) {
        assert(Head->EquivalentTo(*T));
        FoundEquivalent = true;
        Set.insert(T);
        break;
      }
    }

    if (!FoundEquivalent) {
      TEquivalenceClass New;
      New.insert(T);
      EquivalenceClasses.push_back(New);
    }
  }

  Out << "equivalence classes:\n";
  for (auto& EquivClass : EquivalenceClasses) {
    bool Head = true;
    for (const Transition *T : EquivClass) {
      Out << (Head ? "  " : "   == ") << T->String() << "\n";
      Head = false;
    }
  }
}


void Transition::ReferencesThusFar(OwningArrayPtr<const Argument*>& Args,
                                   ReferenceVector& Ref) const {

  // Put this transition's *variable* references in var-index order.
  SmallVector<const Argument*, 4> MyRefs;
  for (auto Arg : this->Arguments()) {
    if (!Arg)
      continue;

    int Index = ArgIndex(*Arg);
    if (Index < 0)
      continue;

    if (MyRefs.size() <= Index)
      MyRefs.resize(Index + 1);

    MyRefs[Index] = Arg;
  }
  if (const FnTransition *FT = dyn_cast<FnTransition>(this))
    if (FT->FnEvent().has_receiver()) {
      const Argument &Receiver = FT->FnEvent().receiver();
      int Index = ArgIndex(Receiver);
      if (Index >= 0) {
        if (MyRefs.size() <= Index)
          MyRefs.resize(Index + 1);

        MyRefs[Index] = &Receiver;
      }
    }

  auto& FromRefs = From.References();
  const size_t Size = FromRefs.size();

  auto Arguments = new const Argument*[Size];
  for (size_t i = 0; i < Size; i++) {
    if ((MyRefs.size() > i) && MyRefs[i])
      Arguments[i] = MyRefs[i];

    else if ((FromRefs.size() > i) && FromRefs[i])
      Arguments[i] = FromRefs[i];

    else
      Arguments[i] = NULL;
  }

  Args.reset(Arguments);
  Ref = ReferenceVector(Arguments, Size);
}


SmallVector<const Argument*,4> Transition::NewArguments() const {
  auto OldArgs(From.References());
  auto TransArgs(Arguments());

  SmallVector<const Argument*,4> NewArgs(TransArgs.size());
  for (size_t i = 0; i < NewArgs.size(); i++)
    if ((OldArgs.size() <= i) || (OldArgs[i] == NULL))
      NewArgs[i] = TransArgs[i];

  return NewArgs;
}


int Transition::NewArgMask() const {
  auto NewArgs(NewArguments());
  int Mask = 0;

  for (int i = 0; i < NewArgs.size(); i++) {
    if (NewArgs[i] == NULL)
      continue;

    int Index = ArgIndex(*NewArgs[i]);
    if (Index < 0)
      continue;

    Mask += (1 << Index);
  }

  return Mask;
}


string Transition::String() const {
  string NewArgs;
  for (auto A : NewArguments())
    NewArgs += " " + ShortName(A);

  string Special =
    string(RequiresInit() ? "<<init>>" : "")
    + (RequiresCleanup() ? "<<cleanup>>" : "")
    ;

  return (Twine()
    + "--("
    + ShortLabel()
    + (NewArgs.empty() ? "" : ":" + NewArgs)
    + (Special.empty() ? "" : " " + Special)
    + ")-->("
    + Twine(To.ID())
    + ")"
  ).str();
}


raw_ostream& operator << (raw_ostream& Out, const TEquivalenceClass& TEq) {
  auto *Head = *TEq.begin();

  Out << Head->ShortLabel();
  Out << " : [";

  for (auto *T : TEq) {
    auto& Source = T->Source();
    auto& Dest = T->Destination();

    // llvm::raw_ostream doesn't support control tokens like std::hex.
    Out
      << " ("
      << Source.ID() << ":0x"
      ;
    Out.write_hex(Source.Mask());
    Out
      << " -> "
      << Dest.ID() << ":0x"
      ;
    Out.write_hex(Dest.Mask());
    Out << ")";
  }

  Out << " ]";

  return Out;
}


const ReferenceVector FnTransition::Arguments() const {
  const Argument* const *Args = Ev.argument().data();
  size_t Len = Ev.argument_size();

  return ReferenceVector(Args, Len);
}

string FnTransition::ShortLabel() const {
  std::stringstream ss;
  ss << Ev.function().name() << "(";

  for (int i = 0; i < Ev.argument_size(); i++)
    ss
      << ShortName(&Ev.argument(i))
      << ((i < Ev.argument_size() - 1) ? "," : "");

  ss << ")";

  if (Ev.has_expectedreturnvalue()) {
    assert(Ev.direction() == FunctionEvent::Exit);
    ss << " == " << ShortName(&Ev.expectedreturnvalue());
  } else
    ss << ": " << FunctionEvent::Direction_Name(Ev.direction());

  return ss.str();
}

string FnTransition::DotLabel() const {
  std::stringstream ss;
  ss << Ev.function().name() << "(";

  for (int i = 0; i < Ev.argument_size(); i++)
    ss
      << DotName(&Ev.argument(i))
      << ((i < Ev.argument_size() - 1) ? "," : "");

  ss << ")";

  if (Ev.has_expectedreturnvalue()) {
    assert(Ev.direction() == FunctionEvent::Exit);
    ss << " == " << DotName(&Ev.expectedreturnvalue());
  } else
    ss << "\\n("
      << FunctionEvent::Direction_Name(Ev.direction())
      << ")"
      ;

  return ss.str();
}


FieldAssignTransition::FieldAssignTransition(const State& From, const State& To,
                                             const FieldAssignment& A,
                                             bool Init, bool Cleanup,
                                             bool OutOfScope)
  : Transition(From, To, Init, Cleanup, OutOfScope), Assign(A),
    ReferencedVariables(new const Argument*[2]),
    Refs(ReferencedVariables.get(), 2)
{
  ReferencedVariables[0] = &Assign.field().base();
  ReferencedVariables[1] = &Assign.value();
}

string FieldAssignTransition::ShortLabel() const {
  return (Twine()
    + ShortName(&Assign.field().base())
    + "."
    + Assign.field().name()
    + " "
    + OpString(Assign.operation())
    + " "
    + ShortName(&Assign.value())
  ).str();
}

string FieldAssignTransition::DotLabel() const {
  return (Twine()
    + "struct " + Assign.field().type() + ":\\l"
    + ShortName(&Assign.field().base())
    + "."
    + Assign.field().name()
    + " "
    + OpString(Assign.operation())
    + " "
    + ShortName(&Assign.value())
  ).str();
}

const char* FieldAssignTransition::OpString(FieldAssignment::AssignType T) {
  switch (T) {
  case FieldAssignment::SimpleAssign:  return "=";
  case FieldAssignment::PlusEqual:     return "+=";
  case FieldAssignment::MinusEqual:    return "-=";
  }
}


const ReferenceVector SubAutomatonTransition::Arguments() const {
  // TODO: actually find sub-automaton!
  return ReferenceVector();
}

} // namespace tesla
