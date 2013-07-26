/*! @file Automaton.h  Declaration of @ref tesla::Automaton. */
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

#ifndef AUTOMATON_H
#define AUTOMATON_H

#include "Transition.h"

#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/StringRef.h>

#include <map>


namespace tesla {

// TESLA IR classes
class AutomatonDescription;
class BooleanExpr;
class Expression;
class FieldAssignment;
class FunctionEvent;
class Identifier;
class NowEvent;
class Sequence;

// Automata classes
class State;

namespace internal {
  class DFABuilder;
  class NFAParser;
}

typedef std::map<Identifier,const AutomatonDescription*> AutomataMap;

/**
 * An automata representation of a TESLA assertion.
 *
 * This representation can be either deterministic (for easy generation of
 * instrumentation code) or non-deterministic (for easy creation and analysis).
 *
 * An @ref Automaton owns its consituent @ref State objects; @ref Transition
 * ownership rests with the @ref State objects.
 */
class Automaton {
  friend class internal::DFABuilder;
public:
  //! Automata representations, in increasing order of realisability.
  enum Type {
    /**
     * An NFA representation that includes sub-automata pseudo-transitions, e.g.
     * "transition from state 2 to state 8 via sub-automaton 'active_close'".
     */
    Unlinked,

    //! An NFA with realisable transitions.
    Linked,

    //! A DFA that can actually be implemented as instrumentation.
    Deterministic,
  };

  typedef llvm::SmallVector<State*,10> StateVector;


  virtual ~Automaton() {}
  virtual bool IsRealisable() const;

  size_t ID() const { return id; }
  const AutomatonDescription& getAssertion() const { return assertion; }
  const Usage* Use() const { return use; }
  size_t StateCount() const { return States.size(); }
  size_t TransitionCount() const { return Transitions.size(); }

  std::string Name() const { return name; } //!< Short, unique name.
  std::string String() const;               //!< Human-readable representation.
  std::string Dot() const;                  //!< GraphViz representation.

  //! Automaton specificiation from original source code.
  std::string SourceCode() const { return assertion.source(); }

  //! Iterate over state transitions.
  TransitionSets::const_iterator begin() const { return Transitions.begin(); }
  TransitionSets::const_iterator end() const  { return Transitions.end(); }

protected:
  Automaton(size_t id, const AutomatonDescription&,
            const Usage*, llvm::StringRef Name,
            llvm::ArrayRef<State*>, const TransitionSets&);

  const size_t id;
  const AutomatonDescription& assertion;  //!< Automaton states.
  const Usage *use;                       //!< How the automaton is used.
  const std::string name;

  StateVector States;
  TransitionSets Transitions;
};



/**
 * A non-deterministic automaton that represents a TESLA assertion.
 *
 * An NFA isn't easy to write recognition code for, but it is simple to
 * construct, allow us to perform visual inspection and can be mechanically
 * converted to a DFA.
 *
 * The flow is, therefore: C -> TESLA IR -> NFA -> DFA -> instrumentation.
 *
 * Objects of this type might accidentally be realisable (that is, DFAs), but
 * the type system makes no guarantees.
 */
class NFA : public Automaton {
  friend class DFA;

public:
  static NFA* Parse(const AutomatonDescription*, const Usage*, unsigned int id);

  /**
   * Construct a version of this @ref Automaton with all sub-automata
   * transitions replaced by real NFA elements (states and transitions).
   *
   * @param  Desc        where to find definitions of sub-automata
   */
  NFA* Link(const AutomataMap& Desc);

private:
  NFA(size_t id, const AutomatonDescription& A,
      const Usage*, llvm::StringRef Name,
      llvm::ArrayRef<State*>, const TransitionSets&);

  friend class internal::NFAParser;
};


/**
 * A DFA description of a TESLA assertion.
 *
 * Objects of this type are guaranteed to be realisable.
 */
class DFA : public Automaton {
  friend class internal::DFABuilder;

public:
  static DFA* Convert(const NFA*);
  bool IsRealisable() const { return true; }

private:
  DFA(size_t id, AutomatonDescription& A,
      const Usage*, llvm::StringRef Name,
      llvm::ArrayRef<State*>, const TransitionSets&);
};

} // namespace tesla

#endif   // AUTOMATON_H

