/*! @file automata.cpp  Parsers for top-level inline TESLA automata. */
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

#include "Parsers.h"

#include "llvm/ADT/APFloat.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/Basic/Diagnostic.h"

using namespace clang;

namespace tesla {

bool ParseInlineAssertion(Automaton *A, CallExpr *E, ASTContext& Ctx) {
  FunctionDecl *F = E->getDirectCallee();
  if (!F || !F->getName().startswith("__tesla_inline_assertion")) return false;

  if (E->getNumArgs() != 5) {
    Report("Wrong number of arguments to TESLA inline assertion",
        E->getLocStart(), Ctx)
      << E->getSourceRange();
    return false;
  }

  Expr *Filename    = E->getArg(0);
  Expr *Line        = E->getArg(1);
  Expr *Counter     = E->getArg(2);
  Expr *Context     = E->getArg(3);
  Expr *Expression  = E->getArg(4);

  return
    ParseLocation(A->mutable_location(), Filename, Line, Counter, Ctx)
    && ParseContext(A, Context, Ctx)
    && ParseExpression(A->mutable_expression(), Expression, A->location(), Ctx)
    ;
}


bool ParseContext(Automaton *A, Expr *E, ASTContext& Ctx) {
  auto DRE = dyn_cast<DeclRefExpr>(E->IgnoreImplicit());
  if (!DRE) {
    Report("Invalid locality specifier (must be per-thread or global)",
        E->getExprLoc(), Ctx)
      << E->getSourceRange();
    return false;
  }

  StringRef Name = DRE->getDecl()->getName();

  if (Name == "__tesla_perthread") A->set_context(Automaton::ThreadLocal);
  else if (Name == "__tesla_global") A->set_context(Automaton::Global);
  else {
    Report("Invalid locality specifier (must be per-thread or global)",
        E->getExprLoc(), Ctx)
      << E->getSourceRange();
    return false;
  }

  return true;
}


bool ParseLocation(Location *Loc, Expr *Filename, Expr *Line, Expr *Count,
                   ASTContext& Ctx) {

  *Loc->mutable_filename() = ParseStringLiteral(Filename, Ctx);

  auto LineNumber = ParseIntegerLiteral(Line, Ctx);
  if (LineNumber.getBitWidth() == 0) {
    Report("Invalid line number", Line->getExprLoc(), Ctx)
      << Line->getSourceRange();
    return false;
  }
  Loc->set_line(LineNumber.getLimitedValue());

  auto Counter = ParseIntegerLiteral(Count, Ctx);
  if (Counter.getBitWidth() == 0) {
    Report("Invalid counter value", Count->getExprLoc(), Ctx)
      << Count->getSourceRange();
    return false;
  }
  Loc->set_counter(Counter.getLimitedValue());

  return true;
}

}

