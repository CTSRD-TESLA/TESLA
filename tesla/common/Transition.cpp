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

using namespace llvm;

using std::string;

namespace tesla {


void Transition::Create(State& From, const State& To,
                        TransitionVector& Transitions) {

  OwningPtr<Transition> T(new NullTransition(From, To));
  Register(T, From, Transitions);
}

void Transition::Create(State& From, const State& To, const NowEvent& Ev,
                        TransitionVector& Transitions) {

  OwningPtr<Transition> T(new NowTransition(From, To, Ev));
  Register(T, From, Transitions);
}

void Transition::Create(State& From, const State& To, const FunctionEvent& Ev,
                        TransitionVector& Transitions) {

  OwningPtr<Transition> T(new FnTransition(From, To, Ev));
  Register(T, From, Transitions);
}

void Transition::Create(State& From, const State& To, const FieldAssignment& A,
                        TransitionVector& Transitions) {
  OwningPtr<Transition> T(new FieldAssignTransition(From, To, A));
  Register(T, From, Transitions);
}

void Transition::CreateSubAutomaton(State& From, const State& To,
                                    const Identifier& ID,
                                    TransitionVector& Transitions) {
  OwningPtr<Transition> T(new SubAutomatonTransition(From, To, ID));
  Register(T, From, Transitions);
}

void Transition::Copy(State &From, const State& To, const Transition* Other,
                   TransitionVector& Transitions) {

  OwningPtr<Transition> New;

  switch (Other->getKind()) {
  case Null:
    return;

  case Now:
    New.reset(new NowTransition(From, To, cast<NowTransition>(Other)->Loc));
    break;

  case Fn:
    New.reset(new FnTransition(From, To, cast<FnTransition>(Other)->Ev));
    break;

  case FieldAssign:
    New.reset(new FieldAssignTransition(From, To,
                  cast<FieldAssignTransition>(Other)->Assign));
    break;

  case SubAutomaton:
    New.reset(new SubAutomatonTransition(From, To,
                  cast<SubAutomatonTransition>(Other)->ID));
    break;
  }

  assert(New);
  Register(New, From, Transitions);
}

void Transition::Register(OwningPtr<Transition>& T, State& From,
                          TransitionVector& Transitions) {

  Transitions.push_back(T.get());
  From.AddTransition(T);
}


Transition::Transition(const State& From, const State& To)
  : From(From), To(To) {}


string Transition::String() const {
  return (Twine()
    + "--"
    + ShortLabel()
    + "-->("
    + Twine(To.ID())
    + ")"
  ).str();
}

string Transition::Dot() const {
  return (Twine()
    + "\t"
    + Twine(Source().ID())
    + " -> "
    + Twine(Destination().ID())
    + " [ label = \""
    + ShortLabel()
    + "\" ];\n"
  ).str();
}


NowTransition::NowTransition(const State& From, const State& To,
                             const NowEvent& Ev)
  : Transition(From, To), Loc(Ev.location()) {}

NowTransition::NowTransition(const State& From, const State& To,
                             const Location& L)
  : Transition(From, To), Loc(L) {}

const ArrayRef<const Argument*> NowTransition::Arguments() const {
  return llvm::ArrayRef<const Argument*>();//From.References();
}


const ReferenceVector FnTransition::Arguments() const {
  const Argument* const *Args = Ev.argument().data();
  size_t Len = Ev.argument_size();

  return ReferenceVector(Args, Len);
}

string FnTransition::ShortLabel() const {
  return Ev.function().name();
}

string FnTransition::DotLabel() const {
  return (Twine()
    + Ev.function().name()
    + "\\n("
    + FunctionEvent::Direction_Name(Ev.direction())
    + ")"
  ).str();
}


FieldAssignTransition::FieldAssignTransition(const State& From, const State& To,
                                             const FieldAssignment& A)
  : Transition(From, To), Assign(A),
    ReferencedVariables(new const Argument*[2]),
    Refs(ReferencedVariables.get(), 2)
{
  ReferencedVariables[0] = &Assign.base();
  ReferencedVariables[1] = &Assign.value();
}

string FieldAssignTransition::ShortLabel() const {
  return (Twine()
    + Assign.type()
    + "."
    + ShortName(Assign.base())
    + " "
    + OpString(Assign.operation())
    + " "
    + Assign.value().value()
  ).str();
}

string FieldAssignTransition::DotLabel() const {
  return ShortLabel();
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

