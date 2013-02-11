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

#include "Types.h"

#include <llvm/ADT/OwningPtr.h>
#include <llvm/Support/Casting.h>

#include <string>

namespace tesla {

// TESLA IR classes
class FunctionEvent;
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

  static void Create(State& From, const State& To, const NowEvent&,
                     TransitionVector&);

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
  enum TransitionKind { Null, Now, Fn };
  TransitionKind getKind() const { return Kind; }

protected:

  static void Register(llvm::OwningPtr<Transition>&, State&,
                       TransitionVector&);

  Transition(const TransitionKind Kind, const State& From, const State& To);

  const TransitionKind Kind;
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

private:
  NullTransition(const State& From, const State& To)
    : Transition(Null, From, To) {}

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

private:
  NowTransition(const State& From, const State& To, const NowEvent& Ev);

  const Location& Loc;

  friend class Transition;
};

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

private:
  FnTransition(const State& From, const State& To, const FunctionEvent& Ev)
    : Transition(Fn, From, To), Ev(Ev) {}

  const FunctionEvent& Ev;

  friend class Transition;
};

} // namespace tesla

#endif  // TRANSITION_H

