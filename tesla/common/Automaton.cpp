/*! @file Automaton.cpp  Definition of @ref tesla::Automaton. */
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
#include "Debug.h"
#include "Names.h"
#include "Protocol.h"
#include "State.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <tesla.h>

#include <llvm/ADT/SmallPtrSet.h>
#include <llvm/ADT/Twine.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/raw_ostream.h>   // TODO: remove once TODOs below fixed

#include <google/protobuf/text_format.h>

#include <sstream>
#include <set>
#if __has_include(<unordered_map>) and !defined(__linux__)
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

#include <stdio.h>
#ifndef NDEBUG
#include <stdlib.h>
#endif

using google::protobuf::TextFormat;

using namespace llvm;

using std::find;
using std::map;
using std::string;
using std::stringstream;
using std::vector;

namespace tesla {

namespace internal {

static const char *XorOnlyName = "tesla-xor-only";
cl::opt<bool> SuppressInclusiveOr(XorOnlyName, cl::init(false), cl::Hidden,
                                  cl::desc("Treat inclusive OR as XOR"));

class NFAParser {
public:
  NFAParser(const AutomatonDescription& A,
            const Usage* Use,
            const AutomataMap* Descriptions = NULL)
    : Automaton(A), Use(Use), Descriptions(Descriptions),
      SubAutomataAllowed(true)
  {
  }

  NFAParser& AllowSubAutomata(bool Allow);

  /**
   * Parse the NFA, assign it ID @a id and put it in @a Out.
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
  State* Parse(const AssertionSite&, State& InitialState, bool, bool);
  State* Parse(const FunctionEvent&, State& InitialState, bool, bool);
  State* Parse(const FieldAssignment&, State& InitialState, bool, bool);
  State* SubAutomaton(const Identifier&, State& InitialState);

  // Inclusive-Or stuff
  void ConvertIncOrToExcOr(State& LHSStart, State& RHSStart, State& LHSFinal, State& RHSFinal, State& EndState);
  void CalculateReachableTransitionsBetween(const State& InitialState, State& EndState, SmallVector<Transition*,16>& Ts);
  SmallVector<Transition*,16> CreateTransitionChainCopy(SmallVector<Transition*,16>& chain, State& OldStartState, State& NewStartState);

  const AutomatonDescription& Automaton;
  const Usage* Use;
  const AutomataMap* Descriptions;

  bool SubAutomataAllowed;
  State* Start;
  StateVector States;
  TransitionVector Transitions;
};

}


// ---- Automaton implementation ----------------------------------------------
Automaton::Automaton(size_t id, const AutomatonDescription& A,
                     const Usage *Use, StringRef Name,
                     ArrayRef<State*> S, const TransitionSets& Transitions)
  : id(id), assertion(A), use(Use), name(Name), Transitions(Transitions)
{
  assert(!Use || A.identifier() == Use->identifier());
  States.insert(States.begin(), S.begin(), S.end());
}

bool Automaton::IsRealisable() const {
  for (auto i : Transitions)
    for (const Transition *T : i)
      if (!T->IsRealisable())
        return false;

  return true;
}

const Transition* Automaton::Init() const
{
  for (auto& TEq : *this) {
    const Transition *Head = *TEq.begin();
    if (Head->RequiresInit())
      return Head;
  }

  return NULL;
}

const Transition* Automaton::Cleanup() const
{
  for (auto& TEq : *this) {
    const Transition *Head = *TEq.begin();
    if (Head->RequiresCleanup())
      return Head;
  }

  return NULL;
}

string Automaton::String() const {
  stringstream ss;
  ss << "automaton '" << Name() << "' {\n";

  for (State *S : States) {
    assert(S != NULL);
    ss << "\t" << S->String() << "\n";
  }

  ss << "}";

  return ss.str();
}

string Automaton::Dot() const {
  static const string GraphAttributes(
    "truecolor=true"
    ", "
    "bgcolor=\"transparent\""
    ", "
    "dpi=60"
    ", "
    "size=\"8,10\""
    ", "
    "fontname = \"Monospace\""
    ", "
    "labeljust = \"l\""
    ", "
    "labelloc = bottom"
  );

  stringstream ss;
  ss
    << "/*\n"
    << " * " << Name() << "\n"
    << " */\n"
    << "digraph automaton_" << id << " {\n"
    << "\tgraph [ " << GraphAttributes << " ];\n"
    << "\tnode ["
    << " shape = circle,"
    << " fontname = \"Monospace\","
    << " style = filled, fillcolor = \"white\""
    << "];\n"
    << "\tedge [ fontname = \"Monospace\" ];\n"
    << "\n"
    ;

  for (State *S : States) {
    ss << "\t" << S->Dot() << "\n";
  }

  int i = 0;
  for (auto EquivalenceClass : Transitions) {
    string color = ("\"/dark28/" + Twine(i++ % 8 + 1) + "\"").str();
    auto *Head = *EquivalenceClass.begin();

    ss
      << "\n\t/*\n"
      << "\t * " << Head->ShortLabel() << "\n"
      << "\t */\n"
      << "\tedge [ "
      << "label = \"" << Head->DotLabel()
      ;

    if (Head->RequiresInit())
      ss << "\\n&laquo;init&raquo;";

    if (Head->RequiresCleanup())
      ss << "\\n&laquo;cleanup&raquo;";

    ss
      << "\",\n\t\t"
      << "color = " << color << ", "
      << "fontcolor = " << color
      << " ];\n";

    for (auto *T : EquivalenceClass)
      ss
        << "\t" << T->Source().ID() << " -> " << T->Destination().ID() << ";\n"
        ;
  }

  string Src;
  if (assertion.has_source()) {
    Src = "\n" + assertion.source();

    for (size_t i = Src.find("\n"); i != string::npos; i = Src.find("\n", i))
      Src.replace(i, 1, "\\l");

    /* Poor man's quote-escaping (std::string is so under-featured!): */
    for (size_t i = Src.find('"'); i != string::npos; i = Src.find('"', i + 2))
      Src.replace(i, 1, "\\");
  }

  ss
    << "\n\t/*\n"
    << "\t * Footer:\n"
    << "\t */\n"
    << "\tlabel = \"" << Name() << Src << "\";\n"
    << "}";

  return ss.str();
}


Automaton::Lifetime Automaton::getLifetime() const {
  return Lifetime(getAssertion().context(), Init(), Cleanup());
}


string Automaton::Lifetime::String() const {
  return (Twine()
    + AutomatonDescription::Context_Name(Context)
    + ": ("
    + (Init ? Init->ShortLabel() : "<null>")
    + " -> "
    + (Cleanup ? Cleanup->ShortLabel() : "<null>")
    + ")"
  ).str();
}


bool Automaton::Lifetime::operator == (const Automaton::Lifetime& other) const {
  if (other.Context != Context)
    return false;

  if (other.Init == NULL xor Init == NULL)
    return false;

  if (Init != NULL and *other.Init->Protobuf() != *Init->Protobuf())
    return false;

  if (other.Cleanup == NULL xor Cleanup == NULL)
    return false;

  if (Cleanup != NULL and *other.Cleanup->Protobuf() != *Cleanup->Protobuf())
    return false;

  return true;
}


// ---- NFA implementation ----------------------------------------------------
NFA* NFA::Parse(const AutomatonDescription *A, const Usage *Use,
                unsigned int id) {
  OwningPtr<NFA> N;
  internal::NFAParser(*A, Use).Parse(N, id);
  assert(N);

  return N.take();
}

NFA* NFA::Link(const AutomataMap& Descriptions) {
  assert(id < 1000);

  OwningPtr<NFA> N;
  internal::NFAParser(assertion, use, &Descriptions)
    .AllowSubAutomata(false)
    .Parse(N, id);
  assert(N);

  return N.take();
}

NFA::NFA(size_t id, const AutomatonDescription& A,
         const Usage *Use, StringRef Name,
         ArrayRef<State*> S, const TransitionSets& T)
  : Automaton(id, A, Use, Name, S, T)
{
}


namespace internal {
NFAParser& NFAParser::AllowSubAutomata(bool Allow) {
  assert(Allow || Descriptions != NULL && "need a source of subautomata");
  SubAutomataAllowed = Allow;

  return *this;
}

void NFAParser::Parse(OwningPtr<NFA>& Out, unsigned int id) {
  debugs("tesla.automata.parsing")
    << "Parsing '" << ShortName(Automaton.identifier()) << "'...\n";

  size_t VariableRefs = 0;
  for (auto A : Automaton.argument())
    VariableRefs++;

  Start = State::NewBuilder(States)
    .SetStartState()
    .SetRefCount(VariableRefs)
    .Build();

  // Parse the automaton entry point, if provided...
  if (Use && Use->has_beginning()) {
    Start = Parse(Use->beginning(), *Start, true);
    if (!Start) {
      string Str;
      TextFormat::PrintToString(Use->beginning(), &Str);
      panic("failed to parse automaton 'beginning' event: " + Str);
    }
  }

  // Parse the main automaton itself.
  State *End = Parse(Automaton.expression(), *Start);
  if (!End)
    panic("failed to parse automaton '" + ShortName(Automaton.identifier()));

  // Parse the automaton finalisation point, if provided...
  if (Use && Use->has_end()) {
    End = Parse(Use->end(), *End, false, true);
    if (!End) {
      string Str;
      TextFormat::PrintToString(Use->end(), &Str);
      panic("failed to parse automaton 'end' event: " + Str);
    }
  }

  // Handle out-of-scope events: if we observe one, we it should cause us to
  // stay in the post-initialisation state.
  vector<const Transition*> OutOfScope;
  for (const Transition *T : Transitions) {
    // Have we already noted an equivalent out-of-scope transition?
    //
    // This check is subtly different from looping over the equivalence
    // classes created below: that equivalence is based on the transition's
    // input event only, so transitions in the same equivalence class can have
    // different in-scope vs out-of-scope characteristics.
    bool AlreadyHave = false;
    for (const Transition *Existing : OutOfScope)
      if (Existing->EquivalentTo(*T)) {
        AlreadyHave = true;
        break;
      }

    if (!AlreadyHave && !T->IsStrict() && !T->RequiresInit())
      OutOfScope.push_back(T);
  }

  for (auto *T : OutOfScope) {
    State& Destination = *(T->RequiresCleanup() ? End : Start);

    switch (T->getKind()) {
    case Transition::AssertSite:    // fall through
    case Transition::Null:          // fall through
    case Transition::SubAutomaton:
      break;

    case Transition::FieldAssign:   // fall through
    case Transition::Fn:
      Transition::Copy(*Start, Destination, T, Transitions, true);
      break;
    }
  }

  const Identifier &ID = Automaton.identifier();

  string Description;
  TextFormat::PrintToString(Automaton, &Description);

  TransitionSets TEquivClasses;
  Transition::GroupClasses(Transitions, TEquivClasses);

  Out.reset(new NFA(id, Automaton, Use, ShortName(ID), States, TEquivClasses));

  debugs("tesla.automata.parsing") << "parsed '" << Out->Name() << "'.\n\n";
}

State* NFAParser::Parse(const Expression& Expr, State& Start,
                        bool Init, bool Cleanup) {

  switch (Expr.type()) {
  case Expression::BOOLEAN_EXPR:
    if (Init)
      panic("boolean expression cannot do initialisation");

    if (Cleanup)
      panic("boolean expression cannot do cleanup");

    return Parse(Expr.booleanexpr(), Start);

  case Expression::SEQUENCE:
    if (Init)
      panic("sequence transition cannot do initialisation");

    if (Cleanup)
      panic("sequence transition cannot do cleanup");

    return Parse(Expr.sequence(), Start);

  case Expression::NULL_EXPR:
    if (Init)
      panic("epsilon transition cannot do initialisation");

    if (Cleanup)
      panic("epsilon transition cannot do cleanup");

    return &Start;

  case Expression::ASSERTION_SITE:
    return Parse(Expr.assertsite(), Start, Init, Cleanup);

  case Expression::FUNCTION:
    return Parse(Expr.function(), Start, Init, Cleanup);

  case Expression::FIELD_ASSIGN:
    return Parse(Expr.fieldassign(), Start, Init, Cleanup);

  case Expression::SUB_AUTOMATON:
    if (Init)
      panic("sub-automaton transition cannot do initialisation");

    if (Cleanup)
      panic("sub-automaton transition cannot do cleanup");

    if (SubAutomataAllowed)
      return SubAutomaton(Expr.subautomaton(), Start);

    else {
      // If sub-automata are not allowed, find and parse the sub's definition.
      assert(Descriptions != NULL);
      const Identifier& ID = Expr.subautomaton();
      auto i = Descriptions->find(ID);
      if (i == Descriptions->end())
        panic("subautomaton '" + ShortName(ID) + "' not defined");

      return Parse(i->second->expression(), Start);
    }
  }
}

State* NFAParser::Parse(const BooleanExpr& Expr, State& Branch) {
  assert(Expr.expression_size() == 2);
  const Expression& LHS = Expr.expression(0);
  const Expression& RHS = Expr.expression(1);

  State *LHSStart = State::NewBuilder(States).Build();
  State *RHSStart = State::NewBuilder(States).Build();
  State *LHSFinal = Parse(LHS, *LHSStart);
  State *RHSFinal = Parse(RHS, *RHSStart);
  Transition::Create(Branch, *LHSStart, Transitions);
  Transition::Create(Branch, *RHSStart, Transitions);

  if (!LHSFinal || !RHSFinal)
    return NULL;

  State *Join = State::NewBuilder(States).Build();
  Transition::Create(*LHSFinal, *Join, Transitions);
  Transition::Create(*RHSFinal, *Join, Transitions);

  switch (Expr.operation()) {
  case BooleanExpr::BE_Xor:
    return Join;

  case BooleanExpr::BE_Or:
    ConvertIncOrToExcOr(*LHSStart, *RHSStart, *LHSFinal, *RHSFinal, *Join);
    return Join;

  case BooleanExpr::BE_And:
    // TODO: join two (sets of) final states together
    errs() << "TESLA WARNING: using unsupported AND feature\n";
    return Join;
  }
}

State* NFAParser::Parse(const Sequence& Seq, State& Start) {
  State *Current = &Start;
  State *Final = State::NewBuilder(States).Build();

  const int Min = Seq.minreps();

  const bool InfiniteLoop = (Seq.maxreps() == __TESLA_INFINITE_REPETITIONS);

  const int Max = InfiniteLoop ? 1 : Seq.maxreps();

  for (int i = 0; i < std::max(Min, Max); i++) {
    State *RepStart = Current;
    if (i >= Min)
      Transition::Create(*Current, *Final, Transitions);

    for (const Expression& E : Seq.expression())
      Current = Parse(E, *Current);

    if (InfiniteLoop || (i > Max))
      Transition::Create(*Current, *RepStart, Transitions);
  }

  Transition::Create(*Current, *Final, Transitions);

  return Final;
}

State* NFAParser::Parse(const AssertionSite& Site, State& InitialState,
                        bool Init, bool Cleanup) {
  State *Final = State::NewBuilder(States).SetAccepting(Cleanup).Build();
  Transition::Create(InitialState, *Final, Site, Automaton, Transitions,
                     Init, Cleanup);
  return Final;
}

State* NFAParser::Parse(const FunctionEvent& Ev, State& From,
                        bool Init, bool Cleanup) {
  State *Final = State::NewBuilder(States).SetAccepting(Cleanup).Build();
  Transition::Create(From, *Final, Ev, Transitions, Init, Cleanup);
  return Final;
}

State* NFAParser::Parse(const FieldAssignment& Assign, State& From,
                        bool Init, bool Cleanup) {
  State *Final = State::NewBuilder(States).SetAccepting(Cleanup).Build();
  Transition::Create(From, *Final, Assign, Transitions, Init, Cleanup);
  return Final;
}

State* NFAParser::SubAutomaton(const Identifier& ID, State& InitialState) {
  State *Final = State::NewBuilder(States).Build();
  Transition::CreateSubAutomaton(InitialState, *Final, ID, Transitions);
  return Final;
}

string stringifyTransition(Transition* T) {
  stringstream ss;
  ss << "(" << T->Source().ID() << ")" << T->String();
  return ss.str();
}

string stringifyTransitionVector(SmallVector<Transition*,16>& Ts) {
  stringstream ss;
  for (auto T : Ts) {
    ss << stringifyTransition(T) << " ";
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

void NFAParser::ConvertIncOrToExcOr(State& LHSStart, State& RHSStart, State& LHSFinal, State& RHSFinal, State& EndState) {

  if (SuppressInclusiveOr) {
    debugs("tesla.automata.inclusive_or")
      << "Ignoring inclusive-or ('"
      << XorOnlyName
      << "' set)\n"
      ;
    return;
  }

  debugs("tesla.automata.inclusive_or")
    << "Lhs start: " << LHSStart.ID() << "\n"
    << "Rhs start: " << RHSStart.ID() << "\n"
    ;

  // Build 2D matrix of states that will be in the inclusive-or result
  SmallVector<Transition*,16> lhs, rhs;
  CalculateReachableTransitionsBetween(LHSStart, LHSFinal, lhs);
  CalculateReachableTransitionsBetween(RHSStart, RHSFinal, rhs);

  debugs("tesla.automata.inclusive_or")
    << "Lhs reachable: " << stringifyTransitionVector(lhs) << "\n"
    << "Rhs reachable: " << stringifyTransitionVector(rhs) << "\n"
    ;

  // Initialise 2D grid of states. Array index represents state position
  // in the grid, where (0,0) is top left.
  State* grid[lhs.size()+1][rhs.size()+1];
  memset(grid, 0, (lhs.size()+1)*(rhs.size()+1)*sizeof(State*));

  // Initialise first row of grid
  int j=1;
  for (Transition* T : rhs) {
    grid[0][j++] = (State*)&T->Destination();
  }

  // Populate grid, cloning states and transitions as necessary
  int i=0;
  for (Transition* T1 : lhs) {
    State* T1Dest = (State*)&T1->Destination();
    // Create copy of rhs starting at T1Dest
    SmallVector<Transition*,16> rhsCopy = CreateTransitionChainCopy(rhs, RHSStart, *T1Dest);
    debugs("tesla.automata.inclusive_or")
      << "Dumping rhsCopy (size=" << rhsCopy.size() << "): " << stringifyTransitionVector(rhsCopy) << "\n";

    j=1;
    for (Transition* T2 : rhsCopy) {
      State* T3Source = grid[i][j];
      State* T3Dest = (State*)&T2->Destination();
      Transition::Copy(*T3Source, *T3Dest, T1, Transitions);
      grid[i+1][j] = T3Dest;
      debugs("tesla.automata.inclusive_or")
        << "Setting grid[" << i+1 << "][" << j << "] to " << T3Dest->ID() << "\n";
      // if this is the last rhsCopy or the last transition in a rhsCopy, then create
      // epsilon transitions from every state to EndState
      if (i == lhs.size()-1 || j == rhs.size()) {
        Transition::Create(*T3Dest, EndState, Transitions);
      }
      j++;
    }
    i++;
  }

  debugs("tesla.automata.inclusive_or") << "Dumping grid:\n";
  for (i=0; i<lhs.size()+1; i++) {
    for (j=0; j<rhs.size()+1; j++) {
      if (grid[i][j]) {
        debugs("tesla.automata.inclusive_or")
          << "grid[" << i << "][" << j << "] = " << grid[i][j]->ID() << "\n";
      }
    }
  }

}

void NFAParser::CalculateReachableTransitionsBetween(const State& Start, State& End, SmallVector<Transition*,16>& Ts) {
  if (Start.ID() == End.ID()) {
    return;
  }
  for (auto TI=Start.begin(), TE=Start.end() ; TI!=TE ; ++TI) {
    Transition* T = *TI;
    if (find(Ts.begin(), Ts.end(), T) == Ts.end()) { // we haven't seen this T before
      Ts.push_back(T);
      CalculateReachableTransitionsBetween(T->Destination(), End, Ts);
    }
  }
}

SmallVector<Transition*,16> NFAParser::CreateTransitionChainCopy(SmallVector<Transition*,16>& chain, State& OldStartState, State& NewStartState) {
  SmallVector<Transition*,16> clone;

  debugs("tesla.automata.inclusive_or")
    << "Creating copy of transition chain: "
    << stringifyTransitionVector(chain) << "\n"
    ;

  debugs("tesla.automata.inclusive_or")
    << "Old start state: " << OldStartState.ID() << "\n"
    << "New start state: " << NewStartState.ID() << "\n"
    ;

  // mapping from states in chain to clone, to preserve looping
  map<State*,State*> stateMap;
  stateMap[&OldStartState] = &NewStartState;

  for (auto TI=chain.begin(), TE=chain.end(); TI != TE; TI++) {
    Transition* T = *TI;
    debugs("tesla.automata.inclusive_or")
      << "Creating copy of transition: " << stringifyTransition(T) << "\n";

    // get the right source and destination states (to preserve looping)
    State* NewSource = NULL;
    State* NewDest = NULL;

    State* TSource = (State*)&T->Source();
    if (stateMap.find(TSource) != stateMap.end()) {
      NewSource = stateMap[TSource];
    }
    else {
      NewSource = State::NewBuilder(States).Build();
      stateMap[TSource] = NewSource;
    }

    State* TDest = (State*)&T->Destination();
    if (stateMap.find(TDest) != stateMap.end()) {
      NewDest = stateMap[TDest];
    }
    else {
      NewDest = State::NewBuilder(States).Build();
      stateMap[TDest] = NewDest;
    }

    // clone transition
    if (isa<NullTransition>(T)) { // epsilon edges
      Transition::Create(*NewSource, *NewDest, Transitions);
    }
    else {
      Transition::Copy(*NewSource, *NewDest, T, Transitions);
    }
    clone.push_back(Transitions.back()); // ASSUME: Transition::Copy(...) adds to the back of Transitions
  }

  debugs("tesla.automata.inclusive_or")
    << "Dumping transition chain copy before returning: "
    << stringifyTransitionVector(clone) << "\n"
    ;
  return clone;
}

typedef std::set<unsigned> NFAState;
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
  llvm::SmallVector<
    std::pair<NFAState, std::pair<bool,bool> >, 16> UnfinishedStates;
  StateVector States;
  TransitionVector Transitions;
  /// Collect the set of NFA states that correspond to a single DFA state (i.e.
  /// all of the states that are reachable from the input state via epsilon
  /// transitions)
  void collectFrontier(NFAState& N, const State* S, bool& Start, bool& Final) {
    N.insert(S->ID());
    Start |= S->IsStartState();
    Final |= S->IsAcceptingState();
    for (Transition *T : *S)
      if (T->getKind() == Transition::Null)
        collectFrontier(N, &T->Destination());
  }

  void collectFrontier(NFAState& N, const State* S) {
    bool Start = true;
    bool Final = true;
    collectFrontier(N, S, Start, Final);
  }
  State *stateForNFAStates(NFAState& NStates, bool Start, bool Final) {
    auto Existing = DFAStates.find(NStates);
    if (Existing != DFAStates.end())
      return Existing->second;

    auto Builder = State::NewBuilder(States);
    Builder.SetStartState(Start);
    Builder.SetAccepting(Final);
    if (Start)
      Builder.SetRefCount(RefCount);

    std::stringstream Name;
    std::copy(NStates.begin(), NStates.end(),
              std::ostream_iterator<int>(Name,","));
    Builder.SetName(StringRef("NFA:" + Name.str()).drop_back(1));

    State *DS = Builder.Build();
    DFAStates.insert(std::make_pair(NStates, DS));
    UnfinishedStates.push_back(
      std::make_pair(NStates, std::make_pair(Start, Final)));
    return DS;
  }

  State *stateForNFAState(const State *S) {
    if (RefCount == 0)
      RefCount = S->References().size();

    NFAState NStates;
    bool Start = false;
    bool Final = false;
    collectFrontier(NStates, S, Start, Final);
    return stateForNFAStates(NStates, Start, Final);
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
      auto StartFinal = UnfinishedStates.back().second;
      bool Start = StartFinal.first;
      bool Final = StartFinal.second;
      UnfinishedStates.pop_back();
      // Find the NFA states that correspond to the current state.
      State *DS = stateForNFAStates(CurrentState, Start, Final);
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
        Final = false;
        for (auto TI=NState->begin(), TE=NState->end() ; TI!=TE ; ++TI) {
          Transition *T = *TI;
          if (T->getKind() == Transition::Null) continue;
          assert(T->IsRealisable());
          if (FinishedTransitions.count(T) != 0) continue;
          NFAState Destinations;
          collectFrontier(Destinations, &T->Destination(), Start, Final);
          FinishedTransitions.insert(T);
          // Find the other transitions from this state that are equivalent to this one.
          auto DTI = TI;
          for (++DTI ; DTI!=TE ; ++DTI) {
            if ((*DTI)->EquivalentTo(*T)) {
              assert(FinishedTransitions.count(*DTI) == 0);
              FinishedTransitions.insert(*DTI);
              collectFrontier(Destinations, &(*DTI)->Destination(), Start, Final);
            }
          }
          auto DSI = SI;
          for (++DSI ; DSI!=SE ; ++DSI)
            for (Transition *DT : *N->States[*DSI]) {
            if (DT->EquivalentTo(*T)) {
              assert(FinishedTransitions.count(DT) == 0);
              FinishedTransitions.insert(DT);
              collectFrontier(Destinations, &DT->Destination(), Start, Final);
            }
          }

          State *Dest = stateForNFAStates(Destinations, Start, Final);
          Transition::Copy(*DS, *Dest, T, Transitions);
        }
      }
    }
    TransitionSets TEquivClasses;
    Transition::GroupClasses(Transitions, TEquivClasses);

    return new DFA(N->ID(),
                   const_cast<AutomatonDescription&>(N->getAssertion()),
                   N->Use(), N->Name(), States, TEquivClasses);
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

DFA::DFA(size_t id, AutomatonDescription& A, const Usage* Use, StringRef Name,
         ArrayRef<State*> S, const TransitionSets& T)
  : Automaton(id, A, Use, Name, S, T)
{
#ifndef NDEBUG
  for (auto i : T)
    for (const Transition* T: i)
      assert(T->IsRealisable());
#endif
}

} // namespace tesla

