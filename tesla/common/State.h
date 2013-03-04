/*! @file State.h  Declaration of @ref State. */
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

#ifndef STATE_H
#define STATE_H

#include "Transition.h"
#include "Types.h"

#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/OwningPtr.h>

namespace tesla {

class Argument;

namespace internal {
  class DFABuilder;
}

/// A state in a TESLA DFA.
class State {
  friend class internal::DFABuilder;
public:
  /**
   * Create an initial @ref State for an @ref Automaton.
   *
   * @param[out]  States    where to put the resulting State
   * @param[in]   RefSize   the number of variables this automaton references
   */
  static State* CreateStartState(StateVector& States, unsigned int RefSize);

  //! Create a non-initial @ref State.
  static State* Create(StateVector&);

  ~State();

  void AddTransition(llvm::OwningPtr<Transition>&);

  size_t ID() const { return id; }
  bool IsStartState() const { return start; }
  bool IsAcceptingState() const { return (Transitions.size() == 0); }

  void UpdateReferences(llvm::ArrayRef<const Argument*>);
  const ReferenceVector References() const { return Refs; }

  std::string String() const;
  std::string Dot() const;
  Transition *const*begin() const { return Transitions.begin(); }
  Transition *const*end() const { return Transitions.end(); }

private:
  State(size_t id, bool start = false) : id(id), start(start) {}

  const size_t id;
  const bool start;

  //! What variables this state references (how an instance is named).
  llvm::OwningArrayPtr<const Argument*> VariableReferences;
  MutableReferenceVector Refs;

  llvm::SmallVector<Transition*, 1> Transitions;
};

} // namespace tesla

#endif  // STATE_H

