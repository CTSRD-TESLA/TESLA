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

#include <google/protobuf/text_format.h>

#include <sstream>
#include <set>
#if __has_include(<unordered_map>)
#include <unordered_map>
#include <unordered_set>
using std::unordered_map;
using std::unordered_set;
#else
#include <tr1/unordered_map>
#include <tr1/unordered_set>
using std::tr1::unordered_map;
using std::tr1::unordered_set;
#endif

using namespace llvm;

using std::string;
using std::stringstream;
using std::vector;

namespace tesla {


// ---- Automaton implementation ----------------------------------------------
Automaton* Automaton::Create(const AutomatonDescription *A, unsigned int id,
                             Type Type) {
  // First, do the easy thing: parse into an NFA.
  NFA *N = NFA::Parse(A, id);
  assert(N != NULL);

  // Only convert to DFA if we have to.
  if ((Type == Deterministic) && !N->IsRealisable())
    return DFA::Convert(N);

  return N;
}


Automaton::Automaton(size_t id, const AutomatonDescription& A,
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

  ss
    << "\tlabel = \"" << Name() << "\";\n"
    << "\tlabelloc = top;\n"
    << "\tlabeljust = left;\n"
    << "}";

  return ss.str();
}



// ---- NFA implementation ----------------------------------------------------
NFA* NFA::Parse(const AutomatonDescription *A, unsigned int id) {
  assert(A != NULL);

  StateVector States;
  TransitionVector Transitions;

  State *Start = State::Create(States);

  if (Parse(A->expression(), *Start, States, Transitions) == NULL) {
    for (State *S : States)
      delete S;

    return NULL;
  }

  const Identifier &ID = A->identifier();

  string Description;
  ::google::protobuf::TextFormat::PrintToString(*A, &Description);

  return new NFA(id, *A, ShortName(ID), Description, States, Transitions);
}

State* NFA::Parse(const Expression& Expr, State& Start,
                  StateVector& States, TransitionVector& Transitions) {

  switch (Expr.type()) {
  case Expression::BOOLEAN_EXPR:
    return Parse(Expr.booleanexpr(), Start, States, Transitions);

  case Expression::SEQUENCE:
    return Parse(Expr.sequence(), Start, States, Transitions);

  case Expression::NULL_EXPR:
    return &Start;

  case Expression::NOW:
    return Parse(Expr.now(), Start, States, Transitions);

  case Expression::FUNCTION:
    return Parse(Expr.function(), Start, States, Transitions);

  case Expression::FIELD_ASSIGN:
    return Parse(Expr.fieldassign(), Start, States, Transitions);

  case Expression::SUB_AUTOMATON:
    return SubAutomaton(Expr.subautomaton(), Start, States, Transitions);
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
  Transition::Create(*LHSFinal, *Join, Transitions);
  Transition::Create(*RHSFinal, *Join, Transitions);

  switch (Expr.operation()) {
  default:
    llvm_unreachable("unhandled BooleanExpr::Operation");

  case BooleanExpr::BE_Or:
    return Join;

  case BooleanExpr::BE_And:
    // TODO: join two (sets of) final states together
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
  for (const Expression& E : Seq.expression())
    Current = Parse(E, *Current, States, Transitions);

  return Current;
}

State* NFA::Ignore(State& Start, StateVector& States,
                   TransitionVector& Transitions) {

  State *Final = State::Create(States);
  Transition::Create(Start, *Final, Transitions);
  return Final;
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

State* NFA::Parse(const FieldAssignment& Assign, State& InitialState,
                  StateVector& States, TransitionVector& Trans) {

  State *Final = State::Create(States);
  Transition::Create(InitialState, *Final, Assign, Trans);
  return Final;
}

State* NFA::SubAutomaton(const Identifier& ID, State& InitialState,
                         StateVector& States, TransitionVector& Trans) {

  State *Final = State::Create(States);
  Transition::CreateSubAutomaton(InitialState, *Final, ID, Trans);
  return Final;
}


NFA::NFA(size_t id, const AutomatonDescription& A, StringRef Name, StringRef Desc,
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
  /// The NFA state sets that we've seen so far and their corresponding DFA
  /// states
  unordered_map<NFAState, State*, NFAStateHash> DFAStates;
  /// The NFA states that we've completely built.
  unordered_set<unsigned> FinishedStates;
  /// States that have been created, but not yet emitted
  llvm::SmallVector<std::pair<NFAState, bool>, 16> UnfinishedStates;
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
  State *stateForNFAStates(NFAState& NStates, bool Start) {
    auto Existing = DFAStates.find(NStates);
    if (Existing != DFAStates.end()) 
      return Existing->second;
    State *DS = Start ? State::CreateStartState(States) : State::Create(States);
    DFAStates.insert(std::make_pair(NStates, DS));
    UnfinishedStates.push_back(std::make_pair(NStates, Start));
    return DS;
  }

  State *stateForNFAState(const State *S) {
    NFAState NStates;
    bool Start = false;
    collectFrontier(NStates, S, Start);
    return stateForNFAStates(NStates, Start);
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
    // The set of DFA states that correspond to the current location
    NFAState CurrentState;
    stateForNFAState(N->States.front());
    while (!UnfinishedStates.empty()) {
      CurrentState = UnfinishedStates.back().first;
      bool Start = UnfinishedStates.back().second;
      UnfinishedStates.pop_back();
      // Find the NFA states that correspond to the current state.
      State *DS = stateForNFAStates(CurrentState, Start);
      if (FinishedStates.find(DS->ID()) != FinishedStates.end())
        continue;
      FinishedStates.insert(DS->ID());
      // Now we have a state, we need to handle its transitions.
      // If there is only one state in the current state set, then we can just
      // copy all of the transitions from it.
      unordered_set<Transition*> FinishedTransitions;
      // Loop over all of the NFA states and find their outgoing transitions
      for (auto SI=CurrentState.begin(), SE=CurrentState.end() ; SI!=SE ; ++SI) {
        unsigned I = *SI;
        State *NState = N->States[I];
        Start = false;
        for (auto TI=NState->begin(), TE=NState->end() ; TI!=TE ; ++TI) {
          Transition *T = *TI;
          if (T->getKind() == Transition::Null) continue;
          assert(T->IsRealisable());
          if (FinishedTransitions.count(T) != 0) continue;
          NFAState Destinations;
          collectFrontier(Destinations, &T->Destination(), Start);
          FinishedTransitions.insert(T);
          // Find the other transitions from this state that are equivalent to this one.
          auto DTI = TI;
          for (++DTI ; DTI!=TE ; ++DTI) {
            if ((*DTI)->IsEquivalent(*T)) {
              assert(FinishedTransitions.count(*DTI) == 0);
              FinishedTransitions.insert(*DTI);
              collectFrontier(Destinations, &(*DTI)->Destination(), Start);
            }
          }
          auto DSI = SI;
          for (++DSI ; DSI!=SE ; ++DSI)
            for (Transition *DT : *N->States[*DSI]) {
            if (DT->IsEquivalent(*T)) {
              assert(FinishedTransitions.count(DT) == 0);
              FinishedTransitions.insert(DT);
              collectFrontier(Destinations, &DT->Destination(), Start);
            }
          }

          State *Dest = stateForNFAStates(Destinations, Start);
          Transition::Copy(*DS, *Dest, T, Transitions);
#ifndef NDEBUG
          fprintf(stderr, "Old: %s\n", T->String().c_str());
          fprintf(stderr, "New: %s\n", Transitions.back()->String().c_str());
#endif
        }
      }
    }
    // FIXME: We can end up with a lot of accepting states, which could be
    // folded into a single one.
    DFA *D = new DFA(N->ID(), const_cast<AutomatonDescription&>(N->getAssertion()),
        N->Name(), N->Description(), States, Transitions);
#ifndef NDEBUG
    fprintf(stderr, "NFA: %s\n", N->String().c_str());
    // Construct the DFA object
    fprintf(stderr, "DFA: %s\n", D->String().c_str());
    dumpStateMap();
#endif
    return D;
  }
};


} // internal namespace

// ---- DFA implementation ----------------------------------------------------
DFA* DFA::Convert(const NFA* N) {
  internal::DFABuilder B;
  return B.ConstructDFA(N);
}

DFA::DFA(size_t id, AutomatonDescription& A, StringRef Name, StringRef Desc,
         ArrayRef<State*> S, ArrayRef<Transition*> T)
  : Automaton(id, A, Name, Desc, S, T)
{
  for (__unused const Transition* T: T) {
    assert(T->IsRealisable());
  }
}

} // namespace tesla

