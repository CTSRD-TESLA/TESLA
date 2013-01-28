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
#include "tesla.pb.h"

#include <llvm/ADT/SmallPtrSet.h>
#include <llvm/ADT/Twine.h>

#include <sstream>

using namespace llvm;

using std::string;
using std::stringstream;
using std::vector;

namespace tesla {

//! This would be more at home in llvm::SmallVector itself - upstream?
SmallStateVec operator + (const SmallStateVec& LHS, const SmallStateVec& RHS) {
  SmallStateVec New(LHS);
  New.append(RHS.begin(), RHS.end());

  return New;
}

Automaton* Automaton::Parse(Assertion *A, unsigned int id) {
  StateVector States;
  TransitionVector Transitions;

  State *Start = State::Create(States);

  if (Parse(A->expression(), *Start, States, Transitions).empty()) {
    for (State *S : States)
      delete S;

    return NULL;
  }

  return new Automaton(id, States, Transitions);
}

SmallStateVec Automaton::Parse(const Expression& Expr, State& Start,
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

SmallStateVec Automaton::Parse(const BooleanExpr& Expr, State& Branch,
                               StateVector& States,
                               TransitionVector& Transitions) {

  assert(Expr.expression_size() == 2);
  const Expression& LHS = Expr.expression(0);
  const Expression& RHS = Expr.expression(1);

  SmallStateVec LHSFinal = Parse(LHS, Branch, States, Transitions);
  SmallStateVec RHSFinal = Parse(RHS, Branch, States, Transitions);

  if (LHSFinal.empty() || RHSFinal.empty())
    return SmallStateVec();

  switch (Expr.operation()) {
  default:
    assert(false && "unhandled BooleanExpr::Operation");

  case BooleanExpr::BE_Or:
    return LHSFinal + RHSFinal;

  case BooleanExpr::BE_And:
    // TODO: join two (sets of) final states together
    return SmallStateVec();

#if 0
  case BooleanExpr::BE_XOr:
    // TODO: ???
#endif
  }

  llvm_unreachable("fell through BooleanExpr::Operation switch");
}

SmallStateVec Automaton::Parse(const Sequence& Seq, State& Start,
                               StateVector& States,
                               TransitionVector& Transitions) {

  State *Current = &Start;
  for (const Event& Ev : Seq.event()) {
    // States own their out-transitions; hold, then transfer ownership.
    OwningPtr<Transition> T(Transition::Parse(Ev, *Current));

    State *Next = T->SetDestination(State::Create(States));

    Transitions.push_back(T.get());

    Current->AddTransition(T);
    Current = Next;
  }

  return SmallStateVec(1, Current);
}


Automaton::Automaton(size_t id, ArrayRef<State*> S, ArrayRef<Transition*> T)
  : id(id)
{
  States.insert(States.begin(), S.begin(), S.end());
  Transitions.insert(Transitions.begin(), T.begin(), T.end());
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
    ss
      << "\t" << S->ID()
      << (S->IsAcceptingState() ? " [ shape = doublecircle ]" : "")
      << ";\n";

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



// ---- State implementation --------------------------------------------------
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
  stringstream ss;
  ss << "state " << id << ": ";

  for (const auto& I : Transitions) {
    const Transition& T = *I;
    ss << T.String();
  }

  return ss.str();
}

// ---- Transition implementation ---------------------------------------------
void Transition::CreateInit(State& From, const State& To,
                            TransitionVector& Transitions) {

  assert(From.ID() == 0);

  OwningPtr<Transition> T(new Transition(From, To));
  Transitions.push_back(T.get());
  From.AddTransition(T);
}

Transition* Transition::Parse(const Event& Ev, const State& From) {
  return new Transition(Ev, From);
}

Transition* Transition::Parse(const Expression& Expr, State& From,
                              StateVector& States,
                              TransitionVector& Transitions,
                              size_t& CurrentStateID) {

  assert(false && "unimplemented");
}

Transition::Transition(const Event& E, const State& From)
  : Init(false), Ev(&E), From(&From) {}

Transition::Transition(const State& From, const State& To)
  : Init(true), Ev(NULL), From(&From), To(&To) {}

string Transition::ShortLabel() const {
  assert(Init || (Ev != NULL));

  if (Init)
    return "<init>";

  switch (Ev->type()) {
  default:
    assert(false && "unhandled Event::Type");

  case Event::REPETITION:
    return "repeat";

  case Event::NOW:
    return "NOW";

  case Event::FUNCTION:
    return Ev->function().function().name();
  }

  llvm_unreachable("");
}

string Transition::String() const {
  assert(To);

  return (Twine()
    + "--"
    + "EV"
    + "-->("
    + Twine(To->ID())
    + ")"
  ).str();
}

} // namespace tesla

