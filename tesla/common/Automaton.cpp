/*! @file Automaton.cpp  Contains the definition of @ref Automaton. */
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

#include "Automaton.h"
#include "State.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <llvm/ADT/SmallPtrSet.h>
#include <llvm/ADT/Twine.h>

#include <sstream>

using namespace llvm;

using std::string;
using std::stringstream;
using std::vector;

namespace tesla {


// ---- Automaton implementation ----------------------------------------------
Automaton* Automaton::Create(Assertion *A, unsigned int id, Type Type) {
  switch (Type) {
  default:
    assert(false && "Unhandled Automaton::Type");

  case NON_DETERMINISTIC:
    return NFA::Parse(A, id);
  }

  llvm_unreachable("fell through Automaton::Type switch");
}


Automaton::Automaton(size_t id, ArrayRef<State*> S, ArrayRef<Transition*> T)
  : id(id)
{
  States.insert(States.begin(), S.begin(), S.end());
  Transitions.insert(Transitions.begin(), T.begin(), T.end());
}

bool Automaton::IsRealisable() const {
  for (const Transition* T : Transitions)
    if (!T->IsRealisable())
      return false;

  return true;
}

string Automaton::String() {
  stringstream ss;
  ss << "automaton " << id << " {\n";

  for (State *S : States) {
    assert(S != NULL);
    ss << "\t" << S->String() << "\n";
  }

  ss << "}";

  return ss.str();
}

string Automaton::Dot() {
  stringstream ss;
  ss << "digraph automaton_" << id << " {\n";

  ss << "\tnode [ shape = circle ];\n";

  for (State *S : States)
    ss << "\t" << S->Dot() << "\n";

  for (Transition *T : Transitions)
    ss
      << "\t"
      << T->Source().ID()
      << " -> "
      << T->Destination().ID()
      << " [ label = \""
      << T->ShortLabel()
      << "\" ];\n"
      ;

  ss << "}";

  return ss.str();
}



// ---- NFA implementation ----------------------------------------------------
NFA* NFA::Parse(Assertion *A, unsigned int id) {
  StateVector States;
  TransitionVector Transitions;

  State *Start = State::Create(States);

  if (Parse(A->expression(), *Start, States, Transitions) == NULL) {
    for (State *S : States)
      delete S;

    return NULL;
  }

  return new NFA(id, States, Transitions);
}

State* NFA::Parse(const Expression& Expr, State& Start,
                  StateVector& States, TransitionVector& Transitions) {

  switch (Expr.type()) {
  default:
    assert(false && "unhandled Expression::Type");

  case Expression::BOOLEAN_EXPR:
    return Parse(Expr.booleanexpr(), Start, States, Transitions);

  case Expression::SEQUENCE:
    return Parse(Expr.sequence(), Start, States, Transitions);
  }

  llvm_unreachable("fell through Expression::Type switch");
}

State* NFA::Parse(const BooleanExpr& Expr, State& Branch,
                  StateVector& States, TransitionVector& Transitions) {

  assert(Expr.expression_size() == 2);
  const Expression& LHS = Expr.expression(0);
  const Expression& RHS = Expr.expression(1);

  State *LHSFinal = Parse(LHS, Branch, States, Transitions);
  State *RHSFinal = Parse(RHS, Branch, States, Transitions);

  if (!LHSFinal || !RHSFinal)
    return NULL;

  State *Join = State::Create(States);

  switch (Expr.operation()) {
  default:
    assert(false && "unhandled BooleanExpr::Operation");

  case BooleanExpr::BE_Or:
    Transition::Create(*LHSFinal, *Join, Transitions);
    Transition::Create(*RHSFinal, *Join, Transitions);
    return Join;

  case BooleanExpr::BE_And:
    // TODO: join two (sets of) final states together
    Transition::Create(*LHSFinal, *Join, Transitions);
    Transition::Create(*RHSFinal, *Join, Transitions);
    return Join;

#if 0
  case BooleanExpr::BE_XOr:
    // TODO: ???
#endif
  }

  llvm_unreachable("fell through BooleanExpr::Operation switch");
}

State* NFA::Parse(const Sequence& Seq, State& Start,
                  StateVector& States, TransitionVector& Transitions) {

  State *Current = &Start;
  for (const Event& Ev : Seq.event())
    Current = Parse(Ev, *Current, States, Transitions);

  return Current;
}

State* NFA::Parse(const Event& Ev, State& Start,
                  StateVector& States, TransitionVector& Transitions) {

  switch (Ev.type()) {
  default:
    assert(false && "unhandled Event::Type");

  case Event::REPETITION:
    return Parse(Ev.repetition(), Start, States, Transitions);

  case Event::NOW:
    return Parse(Ev.now(), Start, States, Transitions);

  case Event::FUNCTION: {
    return Parse(Ev.function(), Start, States, Transitions);
  }
  }

  llvm_unreachable("fell through Event::Type switch");
}

State* NFA::Parse(const Repetition& Rep, State& Start,
                  StateVector& States, TransitionVector& Transitions) {

  State *Current = &Start;
  for (const Event& Ev : Rep.event()) {
    Current = Parse(Ev, *Current, States, Transitions);
  }

  // TODO: handle min, max values!
  Transition::Create(*Current, Start, Transitions);

  return Current;
}

State* NFA::Parse(const Now& now, State& InitialState,
                  StateVector& States, TransitionVector& Trans) {

  State *Final = State::Create(States);
  Transition::Create(InitialState, *Final, now, Trans);
  return Final;
}

State* NFA::Parse(const FunctionEvent& Ev, State& InitialState,
                  StateVector& States, TransitionVector& Trans) {

  State *Final = State::Create(States);
  Transition::Create(InitialState, *Final, Ev, Trans);
  return Final;
}


NFA::NFA(size_t id, ArrayRef<State*> S, ArrayRef<Transition*> T)
  : Automaton(id, S, T)
{
}



// ---- DFA implementation ----------------------------------------------------
DFA* DFA::Convert(const NFA& N) {
  assert(false && "NFA->DFA conversion not implemented yet");
}

DFA::DFA(size_t id, ArrayRef<State*> S, ArrayRef<Transition*> T)
  : Automaton(id, S, T)
{
  for (const Transition* T: T) {
    assert(T->IsRealisable());
  }
}

} // namespace tesla

