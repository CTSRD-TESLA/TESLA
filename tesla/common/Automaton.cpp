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
#include <llvm/Support/raw_ostream.h>   // TODO: remove once TODOs below fixed

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

#ifndef NDEBUG
#include <stdlib.h>
#endif

using google::protobuf::TextFormat;

using namespace llvm;

using std::map;
using std::string;
using std::stringstream;
using std::vector;

namespace tesla {

namespace internal {

class NFAParser {
public:
  NFAParser(const AutomatonDescription& A,
            const map<Identifier,AutomatonDescription*>* Descriptions = NULL)
    : Automaton(A), Descriptions(Descriptions), SubAutomataAllowed(true)
  {
  }

  NFAParser& AllowSubAutomata(bool Allow);

  /**
   * Parse the NFA, assign it @ref #id and put it in @ref #Out.
   *
   * @param[out]  Out    where to store the NFA
   * @param[in]   id     an integer ID for the resulting NFA
   */
  void Parse(OwningPtr<NFA>& Out, unsigned int id);

private:
  State* Parse(const Expression&, State& InitialState);
  State* Parse(const BooleanExpr&, State& InitialState);
  State* Parse(const Sequence&, State& InitialState);
  State* Parse(const NowEvent&, State& InitialState);
  State* Parse(const FunctionEvent&, State& InitialState);
  State* Parse(const FieldAssignment&, State& InitialState);
  State* SubAutomaton(const Identifier&, State& InitialState);

  const AutomatonDescription& Automaton;
  const map<Identifier,AutomatonDescription*>* Descriptions;

  bool SubAutomataAllowed;
  StateVector States;
  TransitionSets Transitions;
};

}


// ---- Automaton implementation ----------------------------------------------
Automaton::Automaton(size_t id, const AutomatonDescription& A, StringRef Name,
                     ArrayRef<State*> S, const TransitionSets& Transitions)
  : id(id), assertion(A), name(Name), Transitions(Transitions)
{
  States.insert(States.begin(), S.begin(), S.end());
}

bool Automaton::IsRealisable() const {
  for (auto i : Transitions)
    for (const Transition *T : i)
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

  for (State *S : States) {
    ss << "\n\t" << S->Dot() << "\n";

    for (auto *T : *S)
      ss << T->Dot();
  }

  ss
    << "\tlabel = \"" << Name() << "\";\n"
    << "\tlabelloc = top;\n"
    << "\tlabeljust = left;\n"
    << "}";

  return ss.str();
}



// ---- NFA implementation ----------------------------------------------------
NFA* NFA::Parse(const AutomatonDescription *A, unsigned int id) {
  OwningPtr<NFA> N;
  internal::NFAParser(*A).Parse(N, id);
  assert(N);

  return N.take();
}

NFA* NFA::Link(const map<Identifier,AutomatonDescription*>& Descriptions) {
  assert(id < 1000);

  OwningPtr<NFA> N;
  internal::NFAParser(assertion, &Descriptions)
    .AllowSubAutomata(false)
    .Parse(N, id);
  assert(N);

  return N.take();
}

NFA::NFA(size_t id, const AutomatonDescription& A, StringRef Name,
         ArrayRef<State*> S, const TransitionSets& T)
  : Automaton(id, A, Name, S, T)
{
}


namespace internal {
NFAParser& NFAParser::AllowSubAutomata(bool Allow) {
  assert(Allow || Descriptions != NULL && "need a source of subautomata");
  SubAutomataAllowed = Allow;

  return *this;
}

void NFAParser::Parse(OwningPtr<NFA>& Out, unsigned int id) {
  size_t VariableRefs = 0;
  for (auto A : Automaton.argument())
    if (A.type() == Argument::Variable)
      VariableRefs++;

  State *Start = State::CreateStartState(States, VariableRefs);

  // Parse the automaton entry point, if provided...
  if (Automaton.has_beginning()) {
    Start = Parse(Automaton.beginning(), *Start);
    if (!Start) {
      string Str;
      TextFormat::PrintToString(Automaton.beginning(), &Str);
      report_fatal_error(
        "TESLA: failed to parse automaton 'beginning' event: " + Str);
    }
  }

  // Parse the main automaton itself.
  State *End = Parse(Automaton.expression(), *Start);
  if (!End)
    report_fatal_error(
      "TESLA: failed to parse automaton '" + ShortName(Automaton.identifier()));

  // Parse the automaton finalisation point, if provided...
  if (Automaton.has_end()) {
    End = Parse(Automaton.end(), *End);
    if (!End) {
      string Str;
      TextFormat::PrintToString(Automaton.end(), &Str);
      report_fatal_error(
        "TESLA: failed to parse automaton 'end' event: " + Str);
    }
  }

  const Identifier &ID = Automaton.identifier();

  string Description;
  TextFormat::PrintToString(Automaton, &Description);

  Out.reset(new NFA(id, Automaton, ShortName(ID), States, Transitions));
}

State* NFAParser::Parse(const Expression& Expr, State& Start) {
  switch (Expr.type()) {
  case Expression::BOOLEAN_EXPR:
    return Parse(Expr.booleanexpr(), Start);

  case Expression::SEQUENCE:
    return Parse(Expr.sequence(), Start);

  case Expression::NULL_EXPR:
    return &Start;

  case Expression::NOW:
    return Parse(Expr.now(), Start);

  case Expression::FUNCTION:
    return Parse(Expr.function(), Start);

  case Expression::FIELD_ASSIGN:
    return Parse(Expr.fieldassign(), Start);

  case Expression::SUB_AUTOMATON:
    if (SubAutomataAllowed)
      return SubAutomaton(Expr.subautomaton(), Start);

    else {
      // If sub-automata are not allowed, find and parse the sub's definition.
      assert(Descriptions != NULL);
      const Identifier& ID = Expr.subautomaton();
      auto i = Descriptions->find(ID);
      if (i == Descriptions->end())
        report_fatal_error("subautomaton '" + ShortName(ID) + "' not defined");

      return Parse(i->second->expression(), Start);
    }
  }
}

State* NFAParser::Parse(const BooleanExpr& Expr, State& Branch) {
  assert(Expr.expression_size() == 2);
  const Expression& LHS = Expr.expression(0);
  const Expression& RHS = Expr.expression(1);

  State *LHSFinal = Parse(LHS, Branch);
  State *RHSFinal = Parse(RHS, Branch);

  if (!LHSFinal || !RHSFinal)
    return NULL;

  State *Join = State::Create(States);
  Transition::Create(*LHSFinal, *Join, Transitions);
  Transition::Create(*RHSFinal, *Join, Transitions);

  switch (Expr.operation()) {
  case BooleanExpr::BE_Xor:
    return Join;

  case BooleanExpr::BE_Or:
    // TODO: convert to exclusive-or
    llvm::errs() << "TESLA WARNING: using unsupported inclusive OR feature\n";
    return Join;

  case BooleanExpr::BE_And:
    // TODO: join two (sets of) final states together
    llvm::errs() << "TESLA WARNING: using unsupported AND feature\n";
    return Join;
  }
}

State* NFAParser::Parse(const Sequence& Seq, State& Start) {
  State *Current = &Start;
  for (const Expression& E : Seq.expression())
    Current = Parse(E, *Current);

  return Current;
}

State* NFAParser::Parse(const NowEvent& now, State& InitialState) {
  State *Final = State::Create(States);
  Transition::Create(InitialState, *Final, now, Automaton, Transitions);
  return Final;
}

State* NFAParser::Parse(const FunctionEvent& Ev, State& InitialState) {
  State *Final = State::Create(States);
  Transition::Create(InitialState, *Final, Ev, Transitions);
  return Final;
}

State* NFAParser::Parse(const FieldAssignment& Assign, State& InitialState) {
  State *Final = State::Create(States);
  Transition::Create(InitialState, *Final, Assign, Transitions);
  return Final;
}

State* NFAParser::SubAutomaton(const Identifier& ID, State& InitialState) {
  State *Final = State::Create(States);
  Transition::CreateSubAutomaton(InitialState, *Final, ID, Transitions);
  return Final;
}


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

class DFABuilder {
  /// The NFA state sets that we've seen so far and their corresponding DFA
  /// states
  unordered_map<NFAState, State*, NFAStateHash> DFAStates;
  /// The NFA states that we've completely built.
  unordered_set<unsigned> FinishedStates;
  /// States that have been created, but not yet emitted
  llvm::SmallVector<std::pair<NFAState, bool>, 16> UnfinishedStates;
  StateVector States;
  TransitionSets Transitions;
  /// Collect the set of NFA states that correspond to a single DFA state (i.e.
  /// all of the states that are reachable from the input state via epsilon
  /// transitions)
  void collectFrontier(NFAState& N, const State* S, bool& Start) {
    N.insert(S->ID());
    Start |= S->IsStartState();
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

    State *DS = Start
      ? State::CreateStartState(States, RefCount)
      : State::Create(States);

    DFAStates.insert(std::make_pair(NStates, DS));
    UnfinishedStates.push_back(std::make_pair(NStates, Start));
    return DS;
  }

  State *stateForNFAState(const State *S) {
    if (RefCount == 0)
      RefCount = S->References().size();

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
        }
      }
    }
    // FIXME: We can end up with a lot of accepting states, which could be
    // folded into a single one.
    DFA *D = new DFA(N->ID(),
                     const_cast<AutomatonDescription&>(N->getAssertion()),
                     N->Name(), States, Transitions);
#ifndef NDEBUG
    if (getenv("VERBOSE_DEBUG")) {
      fprintf(stderr, "NFA: %s\n", N->String().c_str());
      // Construct the DFA object
      fprintf(stderr, "DFA: %s\n", D->String().c_str());
      dumpStateMap();
    }
#endif
    return D;
  }

private:
  size_t RefCount = 0;
};


} // internal namespace

// ---- DFA implementation ----------------------------------------------------
DFA* DFA::Convert(const NFA* N) {
  internal::DFABuilder B;
  return B.ConstructDFA(N);
}

DFA::DFA(size_t id, AutomatonDescription& A, StringRef Name,
         ArrayRef<State*> S, const TransitionSets& T)
  : Automaton(id, A, Name, S, T)
{
#ifndef NDEBUG
  for (auto i : T)
    for (const Transition* T: i)
      assert(T->IsRealisable());
#endif
}

} // namespace tesla

