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
  State* Parse(const Expression&, State& InitialState,
               bool Init = false, bool Cleanup = false);

  State* Parse(const BooleanExpr&, State& InitialState);
  State* Parse(const Sequence&, State& InitialState);
  State* Parse(const NowEvent&, State& InitialState, bool, bool);
  State* Parse(const FunctionEvent&, State& InitialState, bool, bool);
  State* Parse(const FieldAssignment&, State& InitialState, bool, bool);
  State* SubAutomaton(const Identifier&, State& InitialState, bool, bool);
  
  // Inclusive-Or stuff
  void ConvertIncOrToExcOr(State& InitialState, State& EndState);
  void CalculateReachableTransitionsBetween(const State& InitialState, State& EndState, SmallVector<Transition*,16>& Ts);
  TransitionVectors GenerateTransitionPrefixesOf(SmallVector<Transition*,16>& Ts);
  void CreateParallelAutomata(TransitionVectors& prefixes, SmallVector<Transition*,16>& rhs, State& InitialState, State& EndState);
  void CreateParallelAutomaton(SmallVector<Transition*,16>& lhs, SmallVector<Transition*,16>& rhs, State& InitialState, State& EndState);
  void CreateTransitionChainCopy(SmallVector<Transition*,16>& chain, State& InitialState, State& EndState); 

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
    Start = Parse(Automaton.beginning(), *Start, true);
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
    End = Parse(Automaton.end(), *End, false, true);
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

State* NFAParser::Parse(const Expression& Expr, State& Start,
                        bool Init, bool Cleanup) {

  switch (Expr.type()) {
  case Expression::BOOLEAN_EXPR:
    if (Init)
      report_fatal_error("boolean expression cannot do initialisation");

    if (Cleanup)
      report_fatal_error("boolean expression cannot do cleanup");

    return Parse(Expr.booleanexpr(), Start);

  case Expression::SEQUENCE:
    if (Init)
      report_fatal_error("sequence transition cannot do initialisation");

    if (Cleanup)
      report_fatal_error("sequence transition cannot do cleanup");

    return Parse(Expr.sequence(), Start);

  case Expression::NULL_EXPR:
    if (Init)
      report_fatal_error("epsilon transition cannot do initialisation");

    if (Cleanup)
      report_fatal_error("epsilon transition cannot do cleanup");

    return &Start;

  case Expression::NOW:
    return Parse(Expr.now(), Start, Init, Cleanup);

  case Expression::FUNCTION:
    return Parse(Expr.function(), Start, Init, Cleanup);

  case Expression::FIELD_ASSIGN:
    return Parse(Expr.fieldassign(), Start, Init, Cleanup);

  case Expression::SUB_AUTOMATON:
    if (SubAutomataAllowed)
      return SubAutomaton(Expr.subautomaton(), Start, Init, Cleanup);

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
    ConvertIncOrToExcOr(Branch, *Join);
    return Join;

  case BooleanExpr::BE_And:
    // TODO: join two (sets of) final states together
    errs() << "TESLA WARNING: using unsupported AND feature\n";
    return Join;
  }
}

State* NFAParser::Parse(const Sequence& Seq, State& Start) {
  State *Current = &Start;
  for (const Expression& E : Seq.expression())
    Current = Parse(E, *Current);

  return Current;
}

State* NFAParser::Parse(const NowEvent& now, State& InitialState,
                        bool Init, bool Cleanup) {
  State *Final = State::Create(States);
  Transition::Create(InitialState, *Final, now, Automaton, Transitions,
                     Init, Cleanup);
  return Final;
}

State* NFAParser::Parse(const FunctionEvent& Ev, State& From,
                        bool Init, bool Cleanup) {
  State *Final = State::Create(States);
  Transition::Create(From, *Final, Ev, Transitions, Init, Cleanup);
  return Final;
}

State* NFAParser::Parse(const FieldAssignment& Assign, State& From,
                        bool Init, bool Cleanup) {
  State *Final = State::Create(States);
  Transition::Create(From, *Final, Assign, Transitions, Init, Cleanup);
  return Final;
}

State* NFAParser::SubAutomaton(const Identifier& ID, State& InitialState,
                               bool Init, bool Cleanup) {
  State *Final = State::Create(States);
  Transition::CreateSubAutomaton(InitialState, *Final, ID, Transitions,
                                 Init, Cleanup);
  return Final;
}

string stringifyTransitionVector(SmallVector<Transition*,16>& Ts) {
  stringstream ss;
  for (auto T : Ts) {
    ss << T->String() << " ";
  }
  return ss.str();
}

string stringifyTransitionVectors(TransitionVectors& TVs) {
  stringstream ss;
  ss << "[";
  for (auto& TV : TVs) {
    ss << "{";
    ss << stringifyTransitionVector(TV);
    ss << "}, ";
  }
  ss << "]";
  return ss.str();
}

void NFAParser::ConvertIncOrToExcOr(State& InitialState, State& EndState) {
#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Converting inclusive-or to exclusive-or\n";
  }
#endif  
  /* 
   * X `inclusive-or` Y is computed as:
   * (prefix*(X) || Y) | (X || prefix*(Y)) | (X || Y)
   * where
   *   X and Y are sequences of transitions
   *   prefix*(X) is the set of sets of transition prefixes of X 
   *     (This is equivalent to the powerset of X minus X itself.)
   *   || is the parallel operator that allow possible interleavings of the 
   *     lhs and rhs
   *
   * For example, ab `inclusive-or` cd refers to the following automaton:
   *   = (prefix*(ab) || cd)           | (ab || prefix*(cd))         | (ab || cd)
   *   = (ø || cd) | (a || cd)         | (ab || ø) | (ab || c)       | (ab || cd)
   *   = (cd)      | (a || cd)         | (ab)      | (ab || c)       | (ab || cd)
   *   = (cd)      | (acd | cad | cda) | (ab)      | abc | acb | cab | abcd | acbd | acdb | cdab | cabd | cadb
   *   = cd        | acd | cad | cda   | ab        | abc | acb | cab | abcd | acbd | acdb | cdab | cabd | cadb
   */
  // separate lhs and rhs into different vectors
  SmallVector<Transition*,16> lhs, rhs;
  auto TI = InitialState.begin();
  Transition *LhsFirstT = *TI;
  Transition *RhsFirstT = *(TI+1);

#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Lhs: " << LhsFirstT->String() << "\n";
    errs() << "Rhs: " << RhsFirstT->String() << "\n";
  }
#endif 

  lhs.push_back(LhsFirstT);
  rhs.push_back(RhsFirstT);
  CalculateReachableTransitionsBetween(LhsFirstT->Destination(), EndState, lhs);
  CalculateReachableTransitionsBetween(RhsFirstT->Destination(), EndState, rhs);

#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Calculated reachable transitions for lhs: " << stringifyTransitionVector(lhs) << "\n";
    errs() << "Calculated reachable transitions for rhs: " << stringifyTransitionVector(rhs) << "\n";
  }
#endif 

  // End is already the result of lhs | rhs
  // We need to add to this:
  //   (prefix*(lhs) || rhs) | (lhs || prefix*(rhs)) | (lhs || rhs)
  TransitionVectors lhsPrefixes = GenerateTransitionPrefixesOf(lhs);
  TransitionVectors rhsPrefixes = GenerateTransitionPrefixesOf(rhs);
  CreateParallelAutomata(lhsPrefixes, rhs, InitialState, EndState);
  CreateParallelAutomata(rhsPrefixes, lhs, InitialState, EndState);
  CreateParallelAutomaton(lhs, rhs, InitialState, EndState);
}

void NFAParser::CalculateReachableTransitionsBetween(const State& Start, State& End, SmallVector<Transition*,16>& Ts) {
  Transition* T = *Start.begin();
  if (Start.ID() == End.ID()) {
    return;
  }
  if (!isa<NullTransition>(T)) { // skip epsilon edges
    Ts.push_back(T);
  }
  CalculateReachableTransitionsBetween(T->Destination(), End, Ts);
}

TransitionVectors NFAParser::GenerateTransitionPrefixesOf(SmallVector<Transition*,16>& Ts) {
#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Generating transition prefixes of " << stringifyTransitionVector(Ts) << "\n";
  }
#endif 

  TransitionVectors prefixes;
  // add empty prefix
  SmallVector<Transition*,16> lastPrefix;
  prefixes.push_back(lastPrefix);
  if (Ts.size() > 1) { // catch corner case where length of Ts is 1
    bool nonEmptyPrefix = false;
    for (auto T : Ts) {
      lastPrefix.push_back(T);
      prefixes.push_back(lastPrefix);
      nonEmptyPrefix = true;
    }
    if (nonEmptyPrefix) {
      prefixes.pop_back(); // delete the last element as it is not a prefix
    }
  }

#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Computed prefixes: " << stringifyTransitionVectors(prefixes) << "\n";
  }
#endif

  return prefixes;
}

void NFAParser::CreateParallelAutomata(TransitionVectors& prefixes, SmallVector<Transition*,16>& rhs, State& InitialState, State& EndState) {
  for (auto prefix : prefixes) {
    CreateParallelAutomaton(prefix, rhs, InitialState, EndState);
  }
}

// Compute the automaton for lhs || rhs (where || is the parallel operator)
void NFAParser::CreateParallelAutomaton(SmallVector<Transition*,16>& lhs, SmallVector<Transition*,16>& rhs, State& InitialState, State& EndState) {
  /* 
   * We build the automaton recursively by repeatedly decomposing lhs || rhs,
   * until it cannot be decomposed any further.
   * For example, ab || cd can be decomposed as follows:
   *   ab || cd = a (b || cd)                    | c (ab || d)
   *            = a ( b (ø || cd) | c (b || d) ) | c ( a (b || d)  | d ( ab || ø) )
   *            = a ( bcd | c (bd | db) )        | c ( a (bd | db) | dab )
   *            = a ( bcd | cbd | cdb )          | c ( abd | adb | dab )
   *            = abcd | acbd | acdb             | cabd | cadb | cdab
   */
#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Entering CreateParallelAutomaton(" << stringifyTransitionVector(lhs) << "," << stringifyTransitionVector(rhs) << ")\n";
  }
#endif

  if (lhs.empty()) {
    CreateTransitionChainCopy(rhs, InitialState, EndState);
  }
  else if (rhs.empty()) {
    CreateTransitionChainCopy(lhs, InitialState, EndState);
  }
  else {
    // Decompose as per above comment
    // a (b ||cd)
    Transition *LhsFirstT = lhs.front();
    State *LhsFirstTNewDest = State::Create(States);
    Transition::Copy(InitialState, *LhsFirstTNewDest, LhsFirstT, Transitions);
    SmallVector<Transition*,16> lhsCopy = lhs;
    lhsCopy.erase(lhsCopy.begin()); // TODO: use a more efficient data structure (deque?)
    CreateParallelAutomaton(lhsCopy, rhs, *LhsFirstTNewDest, EndState);
    
    // c (ab || d)
    Transition *RhsFirstT = rhs.front();
    State *RhsFirstTNewDest = State::Create(States);
    Transition::Copy(InitialState, *RhsFirstTNewDest, RhsFirstT, Transitions);
    SmallVector<Transition*,16> rhsCopy = rhs;
    rhsCopy.erase(rhsCopy.begin()); // TODO: use a more efficient data structure (deque?)
    CreateParallelAutomaton(lhs, rhsCopy, *RhsFirstTNewDest, EndState);
  }

#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Exiting CreateParallelAutomaton(" << stringifyTransitionVector(lhs) << "," << stringifyTransitionVector(rhs) << ")\n";
  }
#endif
}

void NFAParser::CreateTransitionChainCopy(SmallVector<Transition*,16>& chain, State& InitialState, State& EndState) {
  State* CurrSource = &InitialState;
#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Creating copy of transition chain: " << stringifyTransitionVector(chain) << "\n";
  }
#endif
  for (auto TI=chain.begin(), TE=chain.end()-1; TI != TE; TI++) {
    Transition* T = *TI;
#ifndef NDEBUG
  if (getenv("VERBOSE_DEBUG")) {
    errs() << "Creating copy of transition: " << T->String() << "\n";
  }
#endif
    State* TDest = State::Create(States);
    Transition::Copy(*CurrSource, *TDest, T, Transitions);
    CurrSource = TDest;
  }
  // last transition copy goes from CurrSource -> End
  Transition::Copy(*CurrSource, EndState, chain.back(), Transitions);
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

