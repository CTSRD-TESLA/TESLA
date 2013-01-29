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

void Transition::Register(OwningPtr<Transition>& T, State& From,
                          TransitionVector& Transitions) {

  Transitions.push_back(T.get());
  From.AddTransition(T);
}


Transition::Transition(const TransitionKind Kind,
                       const State& From, const State& To)
  : Kind(Kind), From(From), To(To) {}


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
  : Transition(Now, From, To), Loc(Ev.location()) {}


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

} // namespace tesla

