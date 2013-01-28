/*! @file Automaton.h  Contains the declaration of @ref Automaton. */
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

//#include "tesla.pb.h"

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/OwningPtr.h"
#include "llvm/ADT/StringRef.h"

#include <vector>

namespace llvm {
  class raw_ostream;
}

namespace tesla {

class Assertion;
class BooleanExpr;
class Event;
class Expression;
class Sequence;
class State;
class Transition;

typedef llvm::SmallVector<State*,10> StateVector;
typedef llvm::SmallVector<State*,1> SmallStateVec;

typedef llvm::SmallVector<Transition*,10> TransitionVector;


/**
 * A DFA description of a TESLA assertion.
 *
 * An @ref Automaton owns its consituent @ref State objects; @ref Transition
 * ownership rests with the @ref State objects.
 */
class Automaton {
public:
  static Automaton* Parse(Assertion*, unsigned int id);

  size_t StateCount() const { return States.size(); }
  size_t TransitionCount() const { return Transitions.size(); }

  std::string String();
  std::string Dot();

private:
  /**
   * Parse an @ref Expression that follows from an initial state.
   *
   * @param[out]  States   All created states are registered here.
   *                       Memory ownership is returned to the caller.
   * @param[out]  Trans    All created transitions are registered here.
   *                       Memory ownership of out-transitions rests with the
   *                       originating @ref State.
   *
   * @returns  A vector of final states.
   */
  static SmallStateVec Parse(const Expression&, State& InitialState,
                             StateVector& States, TransitionVector& Trans);

  static SmallStateVec Parse(const BooleanExpr&, State& InitialState,
                             StateVector&, TransitionVector&);

  static SmallStateVec Parse(const Sequence&, State& InitialState,
                             StateVector&, TransitionVector&);

  Automaton(size_t id, llvm::ArrayRef<State*>, llvm::ArrayRef<Transition*>);

  size_t id;
  StateVector States;
  TransitionVector Transitions;
};


/// A state in a TESLA DFA.
class State {
public:
  static State* Create(StateVector&);
  static State* CreateStartState(StateVector&);

  ~State();

  void AddTransition(llvm::OwningPtr<Transition>&);

  size_t ID() const { return id; }
  bool IsStartState() const { return start; }
  bool IsAcceptingState() const { return (Transitions.size() == 0); }

  std::string String() const;
  std::string Dot() const;

private:
  State(size_t id, bool start = false);

  const size_t id;
  const bool start;

  llvm::SmallVector<Transition*, 1> Transitions;
};


/// A transition from one TESLA state to another.
class Transition {
public:
  static void CreateInit(State& From, const State& To,
                         TransitionVector& Transitions);

  static Transition* Parse(const Event&, const State& From);

  /**
   * Parse an @ref Expression that transitions away from an existing @ref State.
   *
   * This method may descend recursively to parse e.g. ([ foo, bar ] || baz).
   *
   * @returns   the final state(s) of the expression
   */
  static Transition* Parse(const Expression& Expr, State& From,
                           StateVector& States, TransitionVector& Transitions,
                           size_t& CurrentStateID);

  static Transition* Parse(const BooleanExpr&, State& From, StateVector& States,
                           TransitionVector& Transitions, size_t& id);

  static Transition* Parse(const Sequence&, State& From, StateVector& States,
                           TransitionVector& Transitions, size_t& id);

  State* SetDestination(State *S) { To = S; return S; }

  const State& Source() const { return *From; }
  const State& Destination() const { return *To; }

  std::string ShortLabel() const;
  std::string String() const;
  std::string Dot() const;

private:
  Transition(const Event& E, const State& From);
  Transition(const State& From, const State& To);

  const bool Init;     //!< this is an initialization transition; Ev == NULL
  const Event* Ev;
  const State* From;
  const State* To;
};


}


