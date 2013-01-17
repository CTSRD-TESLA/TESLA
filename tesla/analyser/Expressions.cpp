/*! @file expressions.cpp  Parsing functions for TESLA expressions. */
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
using std::vector;

namespace tesla {

bool ParseExpression(Expression *Exp, Expr *E, Assertion *A,
                     vector<ValueDecl*>& References, ASTContext& Ctx) {

  E = E->IgnoreImplicit();

  if (auto Call = dyn_cast<CallExpr>(E)) {
    Exp->set_type(Expression::SEQUENCE);
    return ParseSequence(Exp->mutable_sequence(), Call, A, References, Ctx);
  }

  else if (auto Bop = dyn_cast<BinaryOperator>(E)) {
    Exp->set_type(Expression::BOOLEAN_EXPR);
    return ParseBooleanExpr(Exp->mutable_booleanexpr(), Bop, A, References,
                            Ctx);
  }

  Report("Not a valid TESLA expression", E->getLocStart(), Ctx)
    << E->getSourceRange();
  return false;
}


bool ParseBooleanExpr(BooleanExpr *Expr, BinaryOperator *Bop, Assertion *A,
                      vector<ValueDecl*>& References, ASTContext& Ctx) {

  switch (Bop->getOpcode()) {
    default:
      Report("Invalid boolean operation on TESLA expressions",
          Bop->getOperatorLoc(), Ctx)
        << Bop->getSourceRange();
      return false;

    case BO_LAnd: Expr->set_operation(BooleanExpr::BE_And); break;
    case BO_LOr:  Expr->set_operation(BooleanExpr::BE_Or);  break;
    case BO_Xor:  Expr->set_operation(BooleanExpr::BE_Xor); break;
  }

  return (
    ParseExpression(Expr->add_expression(), Bop->getLHS(), A, References, Ctx)
    && ParseExpression(Expr->add_expression(), Bop->getRHS(), A, References,
                       Ctx)
  );
}


bool ParseSequence(Sequence *Seq, CallExpr *Call, Assertion *A,
                   vector<ValueDecl*>& References, ASTContext& Ctx) {

  FunctionDecl *Fun = Call->getDirectCallee();
  if (!Fun) {
    Report("Expected direct call to TESLA sequence", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  if (Fun->getName().compare("__tesla_sequence") != 0) {
    Report("Expected call to TESLA sequence", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  for (auto Arg = Call->arg_begin(); Arg != Call->arg_end(); ++Arg)
    if (!ParseEvent(Seq->add_event(), *Arg, A, References, Ctx))
      return false;

  return true;
}

}

