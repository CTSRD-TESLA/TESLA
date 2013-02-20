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
#include "Names.h"
#include "State.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <llvm/ADT/SmallPtrSet.h>
#include <llvm/ADT/Twine.h>
#include <llvm/Support/raw_ostream.h>  // TODO: remove once DFA::Convert(NFA) works

#include <google/protobuf/text_format.h>

#include <sstream>
#include <set>
#include <unordered_map>
#include <unordered_set>

using namespace llvm;

using std::string;
using std::stringstream;
using std::vector;

namespace tesla {


// ---- Automaton implementation ----------------------------------------------
Automaton* Automaton::Create(const InlineAssertion *A, unsigned int id,
                             Type Type) {
  // First, do the easy thing: parse into an NFA.
  NFA *N = NFA::Parse(A, id);
  assert(N != NULL);

  // Only convert to DFA if we have to.
  if ((Type == Deterministic) && !N->IsRealisable())
    return DFA::Convert(N);

  return N;
}


Automaton::Automaton(size_t id, const InlineAssertion& A,
                     StringRef Name, StringRef Desc,
                     ArrayRef<State*> S, ArrayRef<Transition*> T)
  : id(id), assertion(A), name(Name), description(Desc)
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

string Automaton::String() const {
  stringstream ss;
  ss << "automaton " << id << " {\n";

  for (State *S : States) {
    assert(S != NULL);
    ss << "\t" << S->String() << "\n";
  }

  ss << "}";

  return ss.str();
}

string Automaton::Dot() const {
  stringstream ss;
  ss << "digraph automaton_" << id << " {\n";

  ss << "\tnode [ shape = circle ];\n";

  for (State *S : States)
    ss << "\t" << S->Dot() << "\n";

  for (Transition *T : Transitions)
    ss << T->Dot();

  ss << "}";

  return ss.str();
}



// ---- NFA implementation ----------------------------------------------------
NFA* NFA::Parse(const InlineAssertion *A, unsigned int id) {
  assert(A != NULL);

  StateVector States;
  TransitionVector Transitions;

  State *Start = State::Create(States);

  if (Parse(A->expression(), *Start, States, Transitions) == NULL) {
    for (State *S : States)
      delete S;

    return NULL;
  }

  const Location &Loc = A->location();

  string Description;
  ::google::protobuf::TextFormat::PrintToString(*A, &Description);

  return new NFA(id, *A, ShortName(Loc), Description, States, Transitions);
}

State* NFA::Parse(const Expression& Expr, State& Start,
                  StateVector& States, TransitionVector& Transitions) {

  switch (Expr.type()) {
  case Expression::BOOLEAN_EXPR:
    return Parse(Expr.booleanexpr(), Start, States, Transitions);

  case Expression::SEQUENCE:
    return Parse(Expr.sequence(), Start, States, Transitions);
  }
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
    llvm_unreachable("unhandled BooleanExpr::Operation");

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
  case Event::IGNORE:
    return Ignore(Start, States, Transitions);

  case Event::REPETITION:
    return Parse(Ev.repetition(), Start, States, Transitions);

  case Event::NOW:
    return Parse(Ev.now(), Start, States, Transitions);

  case Event::FUNCTION:
    return Parse(Ev.function(), Start, States, Transitions);
  }
}

State* NFA::Ignore(State& Start, StateVector& States,
                   TransitionVector& Transitions) {

  State *Final = State::Create(States);
  Transition::Create(Start, *Final, Transitions);
  return Final;
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

State* NFA::Parse(const NowEvent& now, State& InitialState,
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


NFA::NFA(size_t id, const InlineAssertion& A, StringRef Name, StringRef Desc,
         ArrayRef<State*> S, ArrayRef<Transition*> T)
  : Automaton(id, A, Name, Desc, S, T)
{
}

namespace {
typedef std::set<unsigned> NFAState;
void dump(const NFAState &S) {
  for (unsigned i : S) {
    fprintf(stderr, "%d ", i);
  }
  fprintf(stderr, "\n");
}
struct NFAStateHash
{
  size_t operator()(const NFAState &S) const {
    if (S.size() == 0) return 0;
    return *S.begin();
  }
};
}

namespace internal {
class DFABuilder {
  /// The set of DFA states that correspond to the current location
  NFAState CurrentState;
  /// The NFA state sets that we've seen so far and their corresponding DFA
  /// states
  std::unordered_map<NFAState, State*, NFAStateHash> DFAStates;
  /// The NFA states that we've completely built.
  std::unordered_set<unsigned> FinishedStates;
  StateVector States;
  TransitionVector Transitions;
  /// Collect the set of NFA states that correspond to a single DFA state (i.e.
  /// all of the states that are reachable from the input state via epsilon
  /// transitions)
  void collectFrontier(NFAState& N, const State* S, bool& Start) {
    N.insert(S->ID());
    Start &= S->IsStartState();
    for (Transition *T : *S)
      if (T->getKind() == Transition::Null)
        collectFrontier(N, &T->Destination());
  }

  void collectFrontier(NFAState& N, const State* S) {
    bool B = true;
    collectFrontier(N, S, B);
  }

  State *stateForNFAState(const State *S) {
    NFAState NStates;
    bool Start = false;
    collectFrontier(NStates, S, Start);
    auto Existing = DFAStates.find(NStates);
    if (Existing != DFAStates.end()) 
      return Existing->second;
    State *DS = Start ? State::CreateStartState(States) : State::Create(States);
    DFAStates.insert(std::make_pair(NStates, DS));
    return DS;
  }
  void dumpStateMap() {
    for (auto I : DFAStates) {
      fprintf(stderr, "%d = ", (int)I.second->ID());
      dump(I.first);
    }
  }

  public:
  /// Public interface to this class.  Constructs a DFA from the provided NFA.
  DFA *ConstructDFA(const NFA *N) {
    assert(N != NULL);
    // We can't reuse these currently.  
    assert(States.empty());

    for (State *NS : N->States) {
      CurrentState.clear();
      // Find the NFA states that correspond to the current state.
      collectFrontier(CurrentState, NS);
      State *DS = stateForNFAState(NS);
      if (FinishedStates.find(DS->ID()) != FinishedStates.end())
        continue;
      FinishedStates.insert(DS->ID());
      // Now we have a state, we need to handle its transitions.
      // If there is only one state in the current state set, then we can just
      // copy all of the transitions from it.
      if (CurrentState.size() == 1) {
        for (Transition *T : NS->Transitions) {
          if (T->getKind() == Transition::Null) continue;
          assert(T->IsRealisable());
          Transition::Copy(*DS, *stateForNFAState(&T->Destination()),
              T, Transitions);
          fprintf(stderr, "Old: %s\n", T->String().c_str());
          fprintf(stderr, "New: %s\n", Transitions.back()->String().c_str());
        }
      } else {
        fprintf(stderr, "Multiple current states\n");
        // Loop over all of the NFA states and find their outgoing transitions
        for (unsigned I : CurrentState)
          for (Transition *T : *N->States[I]) {
            if (T->getKind() == Transition::Null) continue;
            assert(T->IsRealisable());
            Transition::Copy(*N->States[I], *stateForNFAState(&T->Destination()),
                T, Transitions);
            fprintf(stderr, "Old: %s\n", T->String().c_str());
            fprintf(stderr, "New: %s\n", Transitions.back()->String().c_str());
          }
      }
    }
    // FIXME: We can end up with a lot of accepting states, which could be
    // folded into a single one.
    fprintf(stderr, "NFA: %s\n", N->String().c_str());
    // Construct the DFA object
    DFA *D = new DFA(N->ID(), const_cast<Assertion&>(N->getAssertion()), N->Name(), N->Description(), States, Transitions);
    fprintf(stderr, "DFA: %s\n", D->String().c_str());
    dumpStateMap();
    return D;
  }
};


} // internal namespace

// ---- DFA implementation ----------------------------------------------------
DFA* DFA::Convert(const NFA* N) {
  internal::DFABuilder B;
  return B.ConstructDFA(N);
}

DFA::DFA(size_t id, InlineAssertion& A, StringRef Name, StringRef Desc,
         ArrayRef<State*> S, ArrayRef<Transition*> T)
  : Automaton(id, A, Name, Desc, S, T)
{
  for (__unused const Transition* T: T) {
    assert(T->IsRealisable());
  }
}

} // namespace tesla

