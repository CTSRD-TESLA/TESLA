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
  switch (Other->getKind()) {
    case Null:
      return;
    case Now: {
      OwningPtr<Transition> T(new NowTransition(From, To,
            cast<NowTransition>(Other)->Loc));
      Register(T, From, Transitions);
      return;
    }
    case Fn: {
      OwningPtr<Transition> T(new FnTransition(From, To,
            cast<FnTransition>(Other)->Ev));
      Register(T, From, Transitions);
      return;
    }
    case FieldAssign: {
      OwningPtr<Transition> T(new FieldAssignTransition(From, To,
            cast<FieldAssignTransition>(Other)->Assign));
      Register(T, From, Transitions);
      return;
    }
    case SubAutomaton: {
      OwningPtr<Transition> T(new SubAutomatonTransition(From, To,
            cast<SubAutomatonTransition>(Other)->ID));
      Register(T, From, Transitions);
      return;
    }
  }
  llvm_unreachable("Bad transition type");
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


string FieldAssignTransition::ShortLabel() const {
  return (Twine()
    + Assign.type()
    + "."
    + Assign.name()
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

} // namespace tesla

