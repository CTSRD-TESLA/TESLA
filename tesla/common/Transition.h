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
#include "Protocol.h"
#include "Types.h"

#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/OwningPtr.h>
#include <llvm/ADT/SmallPtrSet.h>
#include <llvm/Support/Casting.h>

#include <string>

namespace tesla {

// TESLA IR classes
class FieldAssignment;
class FunctionEvent;
class Identifier;
class Location;
class NowEvent;

typedef llvm::ArrayRef<const Argument*> ReferenceVector;
typedef llvm::MutableArrayRef<const Argument*> MutableReferenceVector;

//! A set of TESLA transitions that are considered equivalent.
typedef llvm::SmallPtrSet<const Transition*,4> TEquivalenceClass;

//! Sets of transition equivalence classes.
typedef std::vector<TEquivalenceClass> TransitionSets;

typedef llvm::SmallVector<llvm::SmallVector<Transition*, 16>, 4> TransitionVectors;

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
   * @param[in]       Init         Transition triggers class initialisation.
   * @param[in]       Cleanup      Transition triggers class cleanup.
   */
  static void Create(State& From, State& To, TransitionSets& Transitions,
                     bool Init = false, bool Cleanup = false);

  static void Create(State& From, State& To, const FunctionEvent&,
                     TransitionSets&, bool Init, bool Cleanup);

  static void Create(State& From, State& To, const FieldAssignment&,
                     TransitionSets&, bool Init, bool Cleanup);

  static void Create(State& From, State& To, const NowEvent&,
                     const AutomatonDescription&, TransitionSets&,
                     bool Init, bool Cleanup);

  static void CreateSubAutomaton(State& From, State& To,
                                 const Identifier&, TransitionSets&,
                                 bool Init, bool Cleanup);

  /// Creates a transition between the specified states, with the same
  /// transition type as the copied transition.  This is used when constructing
  /// DFA transitions from NFA transitions.
  static void Copy(State &From, State& To, const Transition* Other,
                   TransitionSets &);

  virtual ~Transition() {}

  const State& Source() const { return From; }
  const State& Destination() const { return To; }

  /// Does this transition consume and produce the same symbols as another?
  bool EquivalentTo(const Transition &T) const { return Equiv(T); }

  //! This transition triggers initialisation of its TESLA automata class.
  bool RequiresInit() const { return Init; }

  //! This transition triggers cleanup of its TESLA automata class.
  bool RequiresCleanup() const { return Cleanup; }

  //! Arguments referenced by this transition.
  virtual const ReferenceVector Arguments() const = 0;


  /**
   * The references known at the point this transition occurs.
   *
   * @param[out] Args    where to store the resulting array of arguments
   * @param[out] Ref     a reference to the created arguments; includes length
   */
  void ReferencesThusFar(llvm::OwningArrayPtr<const Argument*>& Args,
                         ReferenceVector& Ref) const;

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

protected:
  static void Register(llvm::OwningPtr<Transition>&, State& From, State& To,
                       TransitionSets&);

  static void Append(const llvm::OwningPtr<Transition>&, TransitionSets&);

  Transition(const State& From, const State& To, bool Init, bool Cleanup)
    : From(From), To(To), Init(Init), Cleanup(Cleanup)
  {
  }

  virtual bool Equiv(const Transition&) const = 0;


  const State& From;
  const State& To;

  bool Init;            //!< This transition triggers initialisation.
  bool Cleanup;         //!< This transition triggers cleanup.
};


/// An unconditional (and unrealisable) transition.
class NullTransition : public Transition {
public:
  bool IsRealisable() const { return false; }
  std::string ShortLabel() const { return "ε"; }
  std::string DotLabel() const { return "&#949;"; }    // epsilon

  const ReferenceVector Arguments() const {
    return ReferenceVector();
  }

  bool EquivalentExpression(const Transition* Other) const {
    return llvm::isa<NullTransition>(Other);
  }

  static bool classof(const Transition *T) {
    return T->getKind() == Null;
  }
  virtual TransitionKind getKind() const { return Null; };

protected:
  virtual bool Equiv(const Transition &T) const {
    return T.getKind() == Null;
  }

private:
  NullTransition(const State& From, const State& To, bool Init, bool Cleanup)
    : Transition(From, To, Init, Cleanup) {}

  friend class Transition;
};


/// The "now" event transition.
class NowTransition : public Transition {
public:
  bool IsRealisable() const { return true; }
  std::string ShortLabel() const { return "NOW"; }
  std::string DotLabel() const { return "NOW"; }

  const ReferenceVector Arguments() const { return Refs; }
  const Location& Location() const { return Ev.location(); }

  bool EquivalentExpression(const Transition* Other) const {
    auto *T = llvm::dyn_cast<NowTransition>(Other);
    if (!T) return false;

    return T->Ev == Ev;
  }

  static bool classof(const Transition *T) {
    return T->getKind() == Now;
  }
  virtual TransitionKind getKind() const { return Now; };

protected:
  virtual bool Equiv(const Transition &T) const {
    return T.getKind() == Now;
  }

private:
  NowTransition(const State& From, const State& To, const NowEvent& Ev,
                const ReferenceVector& Refs, bool Init, bool Cleanup)
    : Transition(From, To, Init, Cleanup), Ev(Ev), Refs(Refs)
  {
  }

  const NowEvent& Ev;
  const ReferenceVector Refs;

  friend class Transition;
};


/// A function-related transition.
class FnTransition : public Transition {
public:
  bool IsRealisable() const { return true; }
  std::string ShortLabel() const;
  std::string DotLabel() const;

  const FunctionEvent& FnEvent() const { return Ev; }
  const ReferenceVector Arguments() const;

  bool EquivalentExpression(const Transition* Other) const {
    auto *T = llvm::dyn_cast<FnTransition>(Other);
    if (!T) return false;

    return T->Ev == Ev;
  }

  static bool classof(const Transition *T) {
    return T->getKind() == Fn;
  }

  virtual TransitionKind getKind() const { return Fn; };

protected:
  virtual bool Equiv(const Transition &T) const {
    return (T.getKind() == Fn) &&
        (Ev == llvm::cast<FnTransition>(&T)->FnEvent());
  }

private:
  FnTransition(const State& From, const State& To, const FunctionEvent& Ev,
               bool Init, bool Cleanup)
    : Transition(From, To, Init, Cleanup), Ev(Ev) {}

  const FunctionEvent& Ev;

  friend class Transition;
};


/// A field assignment transition.
class FieldAssignTransition : public Transition {
public:
  bool IsRealisable() const { return true; }
  std::string ShortLabel() const;
  std::string DotLabel() const;

  const ReferenceVector Arguments() const { return Refs; }
  const FieldAssignment& Assignment() const { return Assign; }

  bool EquivalentExpression(const Transition* Other) const {
    auto *T = llvm::dyn_cast<FieldAssignTransition>(Other);
    if (!T) return false;

    return T->Assign == Assign;
  }

  static bool classof(const Transition *T) {
    return T->getKind() == FieldAssign;
  }

  virtual TransitionKind getKind() const { return FieldAssign; };

protected:
  virtual bool Equiv(const Transition &T) const {
    return (T.getKind() == FieldAssign) &&
        (Assign == llvm::cast<FieldAssignTransition>(&T)->Assignment());
  }

private:
  FieldAssignTransition(const State& From, const State& To,
                        const FieldAssignment& A, bool Init, bool Cleanup);

  static const char *OpString(FieldAssignment::AssignType);

  const FieldAssignment& Assign;

  llvm::OwningArrayPtr<const Argument*> ReferencedVariables;
  ReferenceVector Refs;

  friend class Transition;
};


/// A sub-automaton.
class SubAutomatonTransition : public Transition {
public:
  bool IsRealisable() const { return false; }
  std::string ShortLabel() const { return ShortName(ID); }
  std::string DotLabel() const { return ShortName(ID); }

  const ReferenceVector Arguments() const;
  const Identifier& GetID() const { return ID; }

  bool EquivalentExpression(const Transition* Other) const {
    auto *T = llvm::dyn_cast<SubAutomatonTransition>(Other);
    if (!T) return false;

    return T->ID == ID;
  }

  static bool classof(const Transition *T) {
    return T->getKind() == SubAutomaton;
  }

  virtual TransitionKind getKind() const { return SubAutomaton; };

protected:
  virtual bool Equiv(const Transition &T) const {
    return (T.getKind() == SubAutomaton) &&
        (ID == llvm::cast<SubAutomatonTransition>(&T)->ID);
  }

private:
  SubAutomatonTransition(const State& From, const State& To,
                         const Identifier& ID, bool Init, bool Cleanup)
    : Transition(From, To, Init, Cleanup), ID(ID) {}

  const Identifier& ID;

  friend class Transition;
};


} // namespace tesla

#endif  // TRANSITION_H

