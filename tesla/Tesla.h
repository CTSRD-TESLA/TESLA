/*
 * Copyright (c) 2012 Jonathan Anderson
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

#ifndef TESLA_H
#define TESLA_H

#include "llvm/ADT/OwningPtr.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/SmallString.h"

#include "clang/Basic/Diagnostic.h"

#include <set>
#include <string>
#include <vector>

// We don't need to include these to take pointers and references to them.
namespace clang {
  class ASTContext;
  class BinaryOperator;
  class CallExpr;
  class Expr;
  class FunctionDecl;
  class NamedDecl;

  struct StmtRange;
}

namespace tesla {

/// A reference to a declaration or literal. Small and cheap to copy.
class Reference {
public:
  Reference(clang::NamedDecl *D);
  Reference(clang::Expr *E);

  std::string Description() const;

  bool isValid() const { return (Decl || Literal); }
  bool operator < (const Reference&) const;

private:
  const void* get() const;

  clang::NamedDecl *Decl;
  clang::Expr *Literal;
};

/// Something that can describe itself.
class Desc {
public:
  virtual ~Desc() {}
  virtual std::set<clang::FunctionDecl*> FunctionsToInstrument();
  virtual void References(std::set<Reference>&) const = 0;
  virtual llvm::StringRef Description() const = 0;
};

/**
 * A TESLA automaton can be per-thread (using its implicit synchronisation)
 * or global (with explicit synchronisation).
 */
class AutomatonContext : public Desc {
public:
  AutomatonContext(llvm::StringRef Name);

  void References(std::set<Reference>&) const {}
  llvm::StringRef Description() const { return Descrip; }

  static const AutomatonContext* Parse(clang::Expr*, clang::ASTContext&);

private:
  std::string Descrip;
};


/**
 * A unique, location-based identifier for a TESLA assertion.
 *
 * I don't <i>expect</i> anyone to try and put more than one assertion on a
 * single line of C source code, but you never know, so we use __COUNTER__ as
 * well as __FILE__ and __LINE__.
 */
class Location : public Desc {
public:
  Location(llvm::StringRef Filename, llvm::APInt Line, llvm::APInt Counter);

  void References(std::set<Reference>&) const {}
  llvm::StringRef Description() const { return Descrip; }

  static Location* Parse(
      clang::Expr *Filename, clang::Expr *Line, clang::Expr *Counter,
      clang::ASTContext& Diag);

private:
  llvm::StringRef Filename;
  llvm::APInt Line;
  llvm::APInt Counter;

  std::string Descrip;
};


/// An event that can be instrumented (function entry, field assignment, etc.).
class TeslaEvent : public Desc {
public:
  static TeslaEvent* Parse(clang::Expr*, Location AssertionLocation,
      clang::ASTContext&);
};

/// A repetition of events.
class Repetition : public TeslaEvent {
public:
  /** Construct a Repetition, taking ownership of Events passed in. */
  Repetition(llvm::OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
      llvm::APInt Min);
  Repetition(llvm::OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
      llvm::APInt Min, llvm::APInt Max);

  void Init(llvm::OwningArrayPtr<TeslaEvent*>& Events);

  void References(std::set<Reference>&) const;
  llvm::StringRef Description() const { return Descrip; }

  static Repetition* Parse(
      clang::CallExpr*, Location AssertionLocation, clang::ASTContext&);

private:
  llvm::OwningArrayPtr<TeslaEvent*> Events;
  unsigned Len;

  bool HasMin;
  llvm::APInt Min;

  bool HasMax;
  llvm::APInt Max;

  std::string Descrip;
};

/// The "now" event: we have reached a TESLA inline assertion.
class Now : public TeslaEvent {
public:
  Now(Location Loc);

  void References(std::set<Reference>&) const {}
  llvm::StringRef Description() const { return Descrip; }

private:
  Location ID;
  std::string Descrip;
};


/// A TESLA event that has to do with a function.
class FunctionEvent : public TeslaEvent {
public:
  FunctionEvent(clang::FunctionDecl *Function) : Function(Function) {}
  std::set<clang::FunctionDecl*> FunctionsToInstrument();
  void References(std::set<Reference>&) const {}

protected:
  clang::FunctionDecl *Function;
};

/// Entering a function.
class FunctionEntry : public FunctionEvent {
public:
  FunctionEntry(clang::FunctionDecl *Function);
  llvm::StringRef Description() const { return Descrip; }

private:
  llvm::SmallString<32> Descrip;
};

/// Leaving a function.
class FunctionExit : public FunctionEvent {
public:
  FunctionExit(clang::FunctionDecl *Function);
  llvm::StringRef Description() const { return Descrip; }

private:
  llvm::SmallString<32> Descrip;
};

/// A function call (entry and return value bound together as a single event).
class FunctionCall : public FunctionEvent {
public:
  FunctionCall(clang::FunctionDecl *Fn,
      std::vector<Reference>& Params, Reference& RetVal);

  void References(std::set<Reference>&) const;
  llvm::StringRef Description() const { return Descrip; }

  static FunctionCall* Parse(clang::CallExpr*, clang::ASTContext&);
  static FunctionCall* Parse(
      clang::BinaryOperator *Bop, clang::ASTContext& Ctx);

private:
  std::vector<Reference> Params;
  Reference RetVal;

  std::string Descrip;
};


/// A TESLA expression, eg previously(x) || eventually(y).
class TeslaExpr : public Desc {
public:
  static TeslaExpr* Parse(clang::Expr*, Location AssertionLocation,
      clang::ASTContext&);
};

class BooleanExpr : public TeslaExpr {
public:
  /// TESLA allows a very limited vocabulary of boolean operations.
  enum BooleanOp { BOp_And, BOp_Or, BOp_Xor };

  BooleanExpr(BooleanOp Operation, TeslaExpr *LHS, TeslaExpr *RHS);

  std::set<clang::FunctionDecl*> FunctionsToInstrument();
  void References(std::set<Reference>&) const;
  llvm::StringRef Description() const { return Descrip; }

  static BooleanExpr* Parse(
      clang::BinaryOperator *Bop, Location AssertionLocation,
      clang::ASTContext& Diag);

private:
  BooleanOp Op;
  llvm::OwningPtr<TeslaExpr> LHS;
  llvm::OwningPtr<TeslaExpr> RHS;

  std::string Descrip;
};

/// A sequence of TESLA events, eg entry(syscall), predicate(foo), TESLA_NOW.
class Sequence : public TeslaExpr {
public:
  Sequence(llvm::MutableArrayRef<llvm::OwningPtr<TeslaEvent> > Events);
  ~Sequence() {
    for (auto I = Events.begin(); I != Events.end(); I++) delete *I;
  }

  std::set<clang::FunctionDecl*> FunctionsToInstrument();
  void References(std::set<Reference>&) const;
  llvm::StringRef Description() const { return Descrip; }

  static Sequence* Parse(clang::CallExpr*, Location AssertionLocation,
      clang::ASTContext&);

private:
  llvm::SmallVector<TeslaEvent*, 3> Events;
  llvm::SmallString<200> Descrip;
};


/// An inline TESLA assertion.
class TeslaAssertion : public Desc {
public:
  TeslaAssertion(Location, const AutomatonContext*, TeslaExpr*);

  std::set<clang::FunctionDecl*> FunctionsToInstrument();

  void References(std::set<Reference>&) const;
  std::set<Reference> References() const;

  static TeslaAssertion* Parse(clang::CallExpr*, clang::ASTContext&);
  virtual llvm::StringRef Description() const;

private:
  Location Loc;
  const AutomatonContext* Context;
  llvm::OwningPtr<TeslaExpr> Expression;
};


// A couple of basic helpers.
clang::DiagnosticBuilder Report(llvm::StringRef Message, clang::SourceLocation,
    clang::ASTContext&,
    clang::DiagnosticsEngine::Level Level = clang::DiagnosticsEngine::Error);

llvm::StringRef ParseStringLiteral(clang::Expr*, clang::ASTContext&);
llvm::APInt ParseIntegerLiteral(clang::Expr*, clang::ASTContext&);

}

#endif /* !TESLA_H */

