/*! @file Transition.cpp  Definition of @ref Transition and subclasses. */
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

#include "State.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <llvm/ADT/Twine.h>

#include <sstream>

using namespace llvm;
using std::string;

namespace tesla {


void Transition::Create(State& From, State& To, TransitionSets& Transitions,
                        bool Init, bool Cleanup) {
  OwningPtr<Transition> T(new NullTransition(From, To, Init, Cleanup));
  Register(T, From, To, Transitions);
}

void Transition::Create(State& From, State& To, const NowEvent& Ev,
                        const AutomatonDescription& Automaton,
                        TransitionSets& Transitions, bool Init, bool Cleanup) {

  ReferenceVector Refs(Automaton.argument().data(),
                                 Automaton.argument_size());

  OwningPtr<Transition> T(new NowTransition(From, To, Ev, Refs, Init, Cleanup));
  Register(T, From, To, Transitions);
}

void Transition::Create(State& From, State& To, const FunctionEvent& Ev,
                        TransitionSets& Transitions, bool Init, bool Cleanup) {

  OwningPtr<Transition> T(new FnTransition(From, To, Ev, Init, Cleanup));
  Register(T, From, To, Transitions);
}

void Transition::Create(State& From, State& To, const FieldAssignment& A,
                        TransitionSets& Transitions, bool Init, bool Cleanup) {

  OwningPtr<Transition> T(new FieldAssignTransition(From, To, A,
                                                    Init, Cleanup));
  Register(T, From, To, Transitions);
}

void Transition::CreateSubAutomaton(State& From, State& To,
                                    const Identifier& ID,
                                    TransitionSets& Transitions,
                                    bool Init, bool Cleanup) {

  OwningPtr<Transition> T(new SubAutomatonTransition(From, To, ID,
                                                     Init, Cleanup));
  Register(T, From, To, Transitions);
}

void Transition::Copy(State &From, State& To, const Transition* Other,
                   TransitionSets& Transitions) {

  OwningPtr<Transition> New;
  bool Init = Other->RequiresInit();
  bool Cleanup = Other->RequiresCleanup();

  switch (Other->getKind()) {
  case Null:
    return;

  case Now: {
    auto O = cast<NowTransition>(Other);
    New.reset(new NowTransition(From, To, O->Ev, O->Refs, Init, Cleanup));
    break;
  }

  case Fn:
    New.reset(new FnTransition(From, To, cast<FnTransition>(Other)->Ev,
                               Init, Cleanup));
    break;

  case FieldAssign:
    New.reset(new FieldAssignTransition(From, To,
                  cast<FieldAssignTransition>(Other)->Assign, Init, Cleanup));
    break;

  case SubAutomaton:
    New.reset(new SubAutomatonTransition(From, To,
                  cast<SubAutomatonTransition>(Other)->ID, Init, Cleanup));
    break;
  }

  assert(New);
  Register(New, From, To, Transitions);
}

void Transition::Register(OwningPtr<Transition>& T, State& From, State& To,
                          TransitionSets& Transitions) {

  Append(T, Transitions);

  // Update the state we're pointing to with the references it should
  // know about thus far in the execution of the automaton.
  OwningArrayPtr<const Argument*> Args;
  ReferenceVector Ref;
  T->ReferencesThusFar(Args, Ref);
  To.UpdateReferences(Ref);

  From.AddTransition(T);
}

void Transition::Append(const OwningPtr<Transition>& Tr,
                        TransitionSets& Transitions) {

  const Transition *T = Tr.get();

  for (auto Set : Transitions)
    if ((*Set.begin())->EquivalentExpression(T)) {
      Set.insert(T);
      return;
    }

  SmallPtrSet<const Transition*, 4> New;
  New.insert(T);
  Transitions.push_back(New);
}


void Transition::ReferencesThusFar(OwningArrayPtr<const Argument*>& Args,
                                   ReferenceVector& Ref) const {

#ifndef NDEBUG
  // Automata instances are named by a tuple of variables they refererence.
  // In early states, these references may be unbound (or NULL), but all states
  // should have the same number of variables.
  {
    size_t MyArguments = 0;
    for (auto Arg : this->Arguments())
      if (Arg->type() == Argument::Variable)
        MyArguments++;

    assert(!From.References().empty() || (MyArguments == 0));
  }
#endif

  // Put this transition's *variable* references in var-index order.
  SmallVector<const Argument*, 4> MyRefs;
  for (auto Arg : this->Arguments())
    if (Arg && Arg->type() == Argument::Variable) {
      size_t i = Arg->index();

      if (MyRefs.size() <= i)
        MyRefs.resize(i + 1);

      MyRefs[i] = Arg;
    }

  auto& FromRefs = From.References();
  const size_t Size = FromRefs.size();
  assert(MyRefs.size() <= Size);

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


string Transition::String() const {
  string Special =
    string(RequiresInit() ? "<<init>>" : "")
    + (RequiresCleanup() ? "<<cleanup>>" : "")
    ;

  return (Twine()
    + "--"
    + ShortLabel()
    + "-->("
    + Twine(To.ID())
    + (Special.empty() ? "" : " " + Special)
    + ")"
  ).str();
}

string Transition::Dot() const {
  string Special =
    string(RequiresInit() ? "&laquo;init&raquo;" : "")
    + (RequiresCleanup() ? "&laquo;cleanup&raquo;" : "")
    ;

  return (Twine()
    + "\t"
    + Twine(Source().ID())
    + " -> "
    + Twine(Destination().ID())
    + " [ label = \""
    + DotLabel()
    + (Special.empty() ? "" : "\\n" + Special)
    + "\" ];\n"
  ).str();
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

  ss
    << "):"
    << FunctionEvent::Direction_Name(Ev.direction())
    << ""
    ;

  return ss.str();
}

string FnTransition::DotLabel() const {
  std::stringstream ss;
  ss << Ev.function().name() << "(";

  for (int i = 0; i < Ev.argument_size(); i++)
    ss
      << DotName(&Ev.argument(i))
      << ((i < Ev.argument_size() - 1) ? "," : "");

  ss
    << ")\\n("
    << FunctionEvent::Direction_Name(Ev.direction())
    << ")"
    ;

  return ss.str();
}


FieldAssignTransition::FieldAssignTransition(const State& From, const State& To,
                                             const FieldAssignment& A,
                                             bool Init, bool Cleanup)
  : Transition(From, To, Init, Cleanup), Assign(A),
    ReferencedVariables(new const Argument*[2]),
    Refs(ReferencedVariables.get(), 2)
{
  ReferencedVariables[0] = &Assign.base();
  ReferencedVariables[1] = &Assign.value();
}

string FieldAssignTransition::ShortLabel() const {
  return (Twine()
    + ShortName(&Assign.base())
    + "."
    + Assign.fieldname()
    + " "
    + OpString(Assign.operation())
    + " "
    + ShortName(&Assign.value())
  ).str();
}

string FieldAssignTransition::DotLabel() const {
  return (Twine()
    + "struct " + Assign.type() + ":\\l"
    + ShortName(&Assign.base())
    + "."
    + Assign.fieldname()
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

