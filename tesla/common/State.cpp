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

State* State::CreateStartState(StateVector& States, unsigned int RefSize) {
  State *New = new State(States.size(), true);
  States.push_back(New);

  OwningArrayPtr<const Argument*> NullStore(new const Argument*[RefSize]);
  bzero(NullStore.get(), RefSize * sizeof(NullStore[0]));
  New->UpdateReferences(ReferenceVector(NullStore.get(), RefSize));

  return New;
}

State::~State() {
  for (Transition *T : Transitions) delete T;
}

void State::AddTransition(OwningPtr<Transition>& T)
{
  Transitions.push_back(T.take());
}

void State::UpdateReferences(ReferenceVector NewRefs)
{
  assert(!VariableReferences || (Refs.size() == NewRefs.size()));
  const size_t Len = NewRefs.size();

  if (!VariableReferences) {
    // If we don't have any bound variables, just copy NewRefs.
    VariableReferences.reset(new const Argument*[Len]);
    memcpy(VariableReferences.get(), NewRefs.data(), Len * sizeof(Refs[0]));

    Refs = MutableReferenceVector(VariableReferences.get(), Len);
    return;
  }

  // We already have some notion of variable references; update with
  // the new information.
  if (Refs.size() < Len) {
    OwningArrayPtr<const Argument*> NewCopy(new const Argument*[Len]);
    memcpy(NewCopy.get(), VariableReferences.get(),
           Refs.size() * sizeof(Refs[0]));

    VariableReferences.swap(NewCopy);
    Refs = MutableReferenceVector(VariableReferences.get(), Len);
  }

  for (auto *Arg : NewRefs) {
    assert(Arg != NULL);
    assert(Arg->type() == Argument::Variable);
    assert(((size_t) Arg->index()) <= Len);
    Refs[Arg->index()] = Arg;
  }

  for (size_t i = 0; i < NewRefs.size(); i++) {
    assert(Refs[i] != NULL);

    const Argument **Space = VariableReferences.get() + i;
    const Argument *Old = *Space;
    const Argument *New = NewRefs[i];

    // Sanity check: we shouldn't be losing information.
    if ((Old->type() != Argument::Any) && (New->type() == Argument::Any))
      report_fatal_error(
        "replacing concrete Argument '" + ShortName(New) + " with ANY");
  }
}

uint32_t State::Mask() const {
  uint32_t Mask = 0;
  ReferenceVector Refs = References();

  for (size_t i = 0; i < Refs.size(); i++) {
    if (Refs[i] && Refs[i]->type() == Argument::Variable)
      Mask |= (1 << i);
  }


  return Mask;
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
  std::stringstream InstanceName;

  for (auto i = Refs.begin(); i != Refs.end(); ) {
    InstanceName << DotName(*i);

    if (++i != Refs.end())
      InstanceName << ",";
  }

  return (
    Twine(ID())
    + " [ label = \""
    + "state " + Twine(ID())
    + "\\n("
    + InstanceName.str()
    + ")\""
    + (IsAcceptingState() ? ", shape = doublecircle" : "")
    + " ];"
  ).str();
}

} // namespace tesla

