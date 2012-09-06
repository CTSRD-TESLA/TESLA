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

#ifndef _TESLA_H_
#define _TESLA_H_

#include "References.h"
#include "yaml.h"

#include "llvm/ADT/OwningPtr.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/SmallString.h"

#include <set>
#include <string>
#include <vector>

namespace clang {
  class ASTContext;
  class BinaryOperator;
  class CallExpr;
  class Expr;
}

namespace tesla {

class AutomatonContext;
class TeslaEvent;


//! A TESLA expression, eg previously(x) || eventually(y).
class TeslaExpr : public yaml::HasYaml {
public:
  static TeslaExpr* Parse(clang::Expr*, Location AssertionLocation,
      clang::ASTContext&);

  yaml::Node* Yaml() const;

protected:
  TeslaExpr(llvm::StringRef ExprType) : ExprType(ExprType) {}

  //! Subclasses should override this to expose more information.
  virtual yaml::Sequence* SubExpressions() const { return NULL; }

private:
  std::string ExprType;
};


//! TESLA allows a very limited vocabulary of boolean operations.
class BooleanExpr : public TeslaExpr {
public:
  enum BooleanOp { BOp_And, BOp_Or, BOp_Xor };

  BooleanExpr(BooleanOp Operation, TeslaExpr *LHS, TeslaExpr *RHS);
  yaml::Sequence* SubExpressions() const;

  static BooleanExpr* Parse(
      clang::BinaryOperator *Bop, Location AssertionLocation,
      clang::ASTContext& Diag);

private:
  BooleanOp Op;
  llvm::OwningPtr<TeslaExpr> LHS;
  llvm::OwningPtr<TeslaExpr> RHS;
};

/// A sequence of TESLA events, eg entry(syscall), predicate(foo), TESLA_NOW.
class Sequence : public TeslaExpr {
public:
  Sequence(llvm::MutableArrayRef<llvm::OwningPtr<TeslaEvent> > Events);
  ~Sequence();

  yaml::Sequence* SubExpressions() const;

  static Sequence* Parse(clang::CallExpr*, Location AssertionLocation,
      clang::ASTContext&);

private:
  llvm::SmallVector<TeslaEvent*, 3> Events;
};


/// An inline TESLA assertion.
class TeslaAssertion : public yaml::HasYaml {
public:
  TeslaAssertion(Location, const AutomatonContext*, TeslaExpr*);

  Location SourceLocation() const { return Loc; }

  static TeslaAssertion* Parse(clang::CallExpr*, clang::ASTContext&);
  virtual yaml::Node* Yaml() const;

private:
  Location Loc;
  const AutomatonContext* Context;
  llvm::OwningPtr<TeslaExpr> Expression;
};

}

#include "Events.h"

#endif /* !_TESLA_H_ */

