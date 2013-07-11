/*! @file State.cpp  Definition of @ref tesla::State. */
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

State* State::Builder::Build() {
  llvm::OwningPtr<State> New(new State(States.size(), Start, Accept, Name));
  States.push_back(New.get());

  if (RefCount >= 0) {
    auto& Refs = New->VariableReferences;
    Refs.reset(new const Argument*[RefCount]);
    bzero(Refs.get(), RefCount * sizeof(Refs[0]));

    New->Refs = MutableReferenceVector(Refs.get(), RefCount);
  }

  return New.take();
}

State::~State() {
  for (Transition *T : Transitions) delete T;
}

void State::AddTransition(OwningPtr<Transition>& T)
{
  Transitions.push_back(T.take());
}

void State::UpdateReferences(const Transition& T)
{
  if (VariableReferences && !T.InScope())
    return;

  OwningArrayPtr<const Argument*> Args;
  ReferenceVector NewRefs;
  T.ReferencesThusFar(Args, NewRefs);

  assert(!VariableReferences
         || (NewRefs.size() == 0)
         || (Refs.size() == NewRefs.size()));
  const size_t Len = NewRefs.size();
  assert(Len < 8 * sizeof(Mask()));

  if (!VariableReferences) {
    // If we don't have any bound variables, just copy NewRefs.
    VariableReferences.reset(new const Argument*[Len]);
    memcpy(VariableReferences.get(), NewRefs.data(), Len * sizeof(Refs[0]));

    Refs = MutableReferenceVector(VariableReferences.get(), Len);
    return;
  }

#ifndef NDEBUG
  if (T.InScope()) {
    for (auto *Arg : NewRefs) {
      if (Arg == NULL)
        continue;

      int Index = ArgIndex(*Arg);
      if (Index < 0)
        continue;

      assert(Index <= Len);
      const Argument *Existing = Refs[Index];

      // New variable references should be a subset of existing ones.
      if (Existing)
        assert(*Arg == *Existing);
    }

    uint32_t NewMask = 0;
    for (size_t i = 0; i < Len; i++) {
      if ((NewRefs[i] != NULL) && (NewRefs[i]->type() == Argument::Constant))
        NewMask |= (1 << i);
    }

    assert((Mask() & NewMask) == NewMask);
  }
#endif
}

uint32_t State::Mask() const {
  uint32_t Mask = 0;
  ReferenceVector Refs = References();

  for (size_t i = 0; i < Refs.size(); i++) {
    if (!Refs[i])
      continue;

    int Index = ArgIndex(*Refs[i]);
    if (Index < 0)
      continue;

    Mask |= (1 << Index);
  }


  return Mask;
}

string State::Name(bool QuoteNonNumeric) const {
  std::stringstream ss;
  if (name.empty()) {
    ss << ID();
  } else {
    auto Quote = (QuoteNonNumeric ? "'" : "");
    ss << Quote << name << Quote;
  }

  return ss.str();
}


string State::String() const {
  assert(VariableReferences);

  std::stringstream ss;
  ss << "state " << Name(true) << " " << InstanceName(Refs, true, false) << ":";

  for (const auto& I : Transitions) {
    const Transition& T = *I;
    ss << " " << T.String();
  }

  return ss.str();
}

string State::Dot() const {
  assert(VariableReferences);
  string NameExtra = name.empty() ? "" : ("\\n\\\"" + name + "\\\"");

  return (
    Twine(ID())
    + " [ label = \""
    + "state " + Twine(ID())
    + NameExtra
    + "\\n" + InstanceName(Refs, false, false) + "\""
    + (IsAcceptingState() ? ", shape = doublecircle" : "")
    + " ];"
  ).str();
}

} // namespace tesla
