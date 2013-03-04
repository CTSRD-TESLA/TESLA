/*! @file Transition.h  Declaration of @ref Transition and subclasses. */
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

#ifndef TRANSITION_H
#define TRANSITION_H

#include "Names.h"
#include "Types.h"

#include <llvm/ADT/OwningPtr.h>
#include <llvm/Support/Casting.h>

#include <string>

#include "tesla.pb.h"

namespace tesla {

// TESLA IR classes
class FieldAssignment;
class FunctionEvent;
class Identifier;
class Location;
class NowEvent;

/// A transition from one TESLA state to another.
class Transition {
public:
  /**
   * Create an unconditional transition.
   *
   * An unconditional transition (&#949; in the automata literature) cannot be
   * driven by instrumentation, so it should only appear in an @ref NFA.
   *
   * @param[in,out]   From         The state to transition from; will be given
   *                               ownership of the new transition.
   * @param[in]       To           The state to transition to.
   * @param[out]      Transitions  A place to record the new transition.
   */
  static void Create(State& From, const State& To,
                     TransitionVector& Transitions);

  static void Create(State& From, const State& To, const FunctionEvent&,
                     TransitionVector&);

  static void Create(State& From, const State& To, const FieldAssignment&,
                     TransitionVector&);

  static void Create(State& From, const State& To, const NowEvent&,
                     TransitionVector&);

  static void CreateSubAutomaton(State& From, const State& To,
                                 const Identifier&, TransitionVector&);

  /// Creates a transition between the specified states, with the same
  /// transition type as the copied transition.  This is used when constructing
  /// DFA transitions from NFA transitions.
  static void Copy(State &From, const State& To, const Transition* Other,
                   TransitionVector &);

  virtual ~Transition() {}

  const State& Source() const { return From; }
  const State& Destination() const { return To; }

  //! Can this transition be captured by real instrumentation code?
  virtual bool IsRealisable() const = 0;

  //! A short, human-readable label.
  virtual std::string ShortLabel() const = 0;

  //! A label that can go in a .dot file (can use newline, Greek HTML codes...).
  virtual std::string DotLabel() const = 0;

  virtual std::string String() const;
  virtual std::string Dot() const;

  //! Information for LLVM's RTTI (isa<>, cast<>, etc.).
  enum TransitionKind { Null, Now, Fn, FieldAssign, SubAutomaton };
  virtual TransitionKind getKind() const = 0;
  /// Is this transition one that will be triggered with the same events, but
  //with a different target node.
  virtual bool IsEquivalent(const Transition &T) const = 0;

protected:

  static void Register(llvm::OwningPtr<Transition>&, State&,
                       TransitionVector&);

  Transition(const State& From, const State& To);

  const State& From;
  const State& To;
};


/// An unconditional (and unrealisable) transition.
class NullTransition : public Transition {
public:
  bool IsRealisable() const { return false; }
  std::string ShortLabel() const { return "ε"; }
  std::string DotLabel() const { return "&#949;"; }    // epsilon

  static bool classof(const Transition *T) {
    return T->getKind() == Null;
  }
  virtual TransitionKind getKind() const { return Null; };

  virtual bool IsEquivalent(const Transition &T) const {
    return T.getKind() == Null;
  }

private:
  NullTransition(const State& From, const State& To)
    : Transition(From, To) {}

  friend class Transition;
};


/// The "now" event transition.
class NowTransition : public Transition {
public:
  bool IsRealisable() const { return true; }
  std::string ShortLabel() const { return "NOW"; }
  std::string DotLabel() const { return "NOW"; }

  static bool classof(const Transition *T) {
    return T->getKind() == Now;
  }
  virtual TransitionKind getKind() const { return Now; };

  virtual bool IsEquivalent(const Transition &T) const {
    return T.getKind() == Now;
  }

private:
  NowTransition(const State& From, const State& To, const NowEvent& Ev);
  NowTransition(const State& From, const State& To, const Location &L);

  const Location& Loc;

  friend class Transition;
};

inline bool operator==(const Argument &A1, const Argument &A2) {
  if (A1.type() != A2.type()) return false;
  if (A1.has_index())
    if (A2.has_index() && (A1.index() != A1.index())) return false;
  if (A1.has_name())
    if (A2.has_name() && (A1.name() != A1.name())) return false;
  if (A1.has_value())
    if (A2.has_value() && (A1.value() != A1.value())) return false;
  return true;
}
inline bool operator!=(const Argument &A1, const Argument &A2) {
  return !(A1 == A2);
}
inline bool operator==(const FunctionEvent &E1, const FunctionEvent &E2) {
  if (E1.has_direction())
    if (E2.has_direction() && (E1.direction() != E1.direction())) return false;
  if (E1.has_context())
    if (E2.has_context() && (E1.context() != E1.context())) return false;
  if (E1.has_expectedreturnvalue())
    if (E2.has_expectedreturnvalue() &&
        (E1.expectedreturnvalue() != E1.expectedreturnvalue())) return false;
  if (E1.has_expectedreturnvalue() && E2.has_expectedreturnvalue())
    if (E1.expectedreturnvalue() != E1.expectedreturnvalue()) return false;
  if (E1.argument_size() != E2.argument_size()) return false;
  for (int i=0 ; i<E1.argument_size() ; i++)
    if (E1.argument(i) != E2.argument(i)) return false;
  return true;
}


/// A function-related transition.
class FnTransition : public Transition {
public:
  bool IsRealisable() const { return true; }
  std::string ShortLabel() const;
  std::string DotLabel() const;

  const FunctionEvent& FnEvent() const { return Ev; }

  static bool classof(const Transition *T) {
    return T->getKind() == Fn;
  }

  virtual TransitionKind getKind() const { return Fn; };

  virtual bool IsEquivalent(const Transition &T) const {
    return (T.getKind() == Fn) &&
        (Ev == llvm::cast<FnTransition>(&T)->FnEvent());
  }

private:
  FnTransition(const State& From, const State& To, const FunctionEvent& Ev)
    : Transition(From, To), Ev(Ev) {}

  const FunctionEvent& Ev;

  friend class Transition;
};



inline bool operator==(const FieldAssignment &X, const FieldAssignment &Y) {
  if (X.type() != Y.type()) return false;
  if (X.index() != Y.index()) return false;

  if (X.has_base() != Y.has_base()) return false;
  if (X.has_base() && (X.base() != Y.base())) return false;

  if (X.operation() != Y.operation()) return false;
  if (X.value() != Y.value()) return false;

  return true;
}

inline bool operator!=(const FieldAssignment &X, const FieldAssignment &Y) {
  return !(X == Y);
}


/// A field assignment transition.
class FieldAssignTransition : public Transition {
public:
  bool IsRealisable() const { return true; }
  std::string ShortLabel() const;
  std::string DotLabel() const;

  const FieldAssignment& Assignment() const { return Assign; }

  static bool classof(const Transition *T) {
    return T->getKind() == FieldAssign;
  }

  virtual TransitionKind getKind() const { return FieldAssign; };

  virtual bool IsEquivalent(const Transition &T) const {
    return (T.getKind() == FieldAssign) &&
        (Assign == llvm::cast<FieldAssignTransition>(&T)->Assignment());
  }

private:
  FieldAssignTransition(const State& From, const State& To,
                        const FieldAssignment& A);

  static const char *OpString(FieldAssignment::AssignType);

  const FieldAssignment& Assign;

  llvm::OwningArrayPtr<const Argument*> ReferencedVariables;
  llvm::ArrayRef<const Argument*> Refs;

  friend class Transition;
};


/// A sub-automaton.
class SubAutomatonTransition : public Transition {
public:
  bool IsRealisable() const { return true; }
  std::string ShortLabel() const { return ShortName(ID); }
  std::string DotLabel() const { return ShortName(ID); }

  const Identifier& GetID() const { return ID; }

  static bool classof(const Transition *T) {
    return T->getKind() == FieldAssign;
  }

  virtual TransitionKind getKind() const { return SubAutomaton; };

  virtual bool IsEquivalent(const Transition &T) const {
    return (T.getKind() == SubAutomaton) &&
        (ID == llvm::cast<SubAutomatonTransition>(&T)->ID);
  }

private:
  SubAutomatonTransition(const State& From, const State& To,
                         const Identifier& ID)
    : Transition(From, To), ID(ID) {}

  const Identifier& ID;

  friend class Transition;
};


} // namespace tesla

#endif  // TRANSITION_H

