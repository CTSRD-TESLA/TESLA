/*! @file State.cpp  Definition of @ref State. */
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

State* State::Create(StateVector& States) {
  State *New = new State(States.size());
  States.push_back(New);
  return New;
}

State* State::CreateStartState(StateVector& States) {
  State *New = new State(States.size(), true);
  States.push_back(New);
  return New;
}

State::State(size_t id, bool start) : id(id), start(start) {}
State::~State() {
  for (Transition *T : Transitions) delete T;
}

void State::AddTransition(OwningPtr<Transition>& T)
{
  Transitions.push_back(T.take());
}

string State::String() const {
  std::stringstream ss;
  ss << "state " << id << ":";

  for (const auto& I : Transitions) {
    const Transition& T = *I;
    ss << " " << T.String();
  }

  return ss.str();
}

string State::Dot() const {
  return (
    Twine(ID())
    + (IsAcceptingState() ? " [ shape = doublecircle ]" : "")
    + ";"
  ).str();
}

} // namespace tesla

