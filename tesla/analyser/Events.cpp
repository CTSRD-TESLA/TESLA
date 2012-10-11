/*! @file events.cpp  Parsers for TESLA events. */
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

bool ParseEvent(Event *Ev, Expr *E, Location AssertLoc, ASTContext& Ctx) {
  E = E->IgnoreImplicit();

  if (auto Ref = dyn_cast<DeclRefExpr>(E)) {
    // Is this a "now" event?
    auto D = Ref->getDecl();
    assert(D);
    if (D->getName() != "__tesla_now") return false;

    Ev->set_type(Event::NOW);
    *Ev->mutable_now()->mutable_location() = AssertLoc;
    return true;
  } else if (auto Bop = dyn_cast<BinaryOperator>(E)) {
    // This is a call-and-return like "foo(x) == y".
    Ev->set_type(Event::FUNCTION);
    return ParseFunctionCall(Ev->mutable_function(), Bop, Ctx);
  }

  // Otherwise, it's a call to a TESLA "function" like __tesla_predicate().
  auto Call = dyn_cast<CallExpr>(E);
  if (!Call) {
    Report("Event should look like a function call", E->getLocStart(), Ctx)
      << E->getSourceRange();
    return false;
  }

  auto Callee = Call->getDirectCallee();
  if (!Callee) {
    Report("TESLA event referenced indirectly", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  if (Callee->getName() == "__tesla_repeat") {
    Ev->set_type(Event::REPETITION);
    return ParseRepetition(Ev->mutable_repetition(), Call, AssertLoc, Ctx);
  }

  typedef bool (*FnEventParser)(FunctionEvent*, CallExpr*, ASTContext&);
  FnEventParser Parser = llvm::StringSwitch<FnEventParser>(Callee->getName())
    .Case("__tesla_entered", &ParseFunctionEntry)
    .Case("__tesla_leaving", &ParseFunctionExit)
    .Case("__tesla_call",    &ParseFunctionCall)
    .Default(NULL);

  if (!Parser) {
    Report("Unknown TESLA event", E->getLocStart(), Ctx)
      << E->getSourceRange();
    return false;
  }

  Ev->set_type(Event::FUNCTION);
  return Parser(Ev->mutable_function(), Call, Ctx);
}


bool ParseRepetition(Repetition *Repetition, CallExpr *Call,
                     Location AssertLoc, ASTContext& Ctx) {
  unsigned Args = Call->getNumArgs();
  if (Args < 3) {
    Report("Repetition must have at least three arguments (min, max, events)",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  auto Min = ParseIntegerLiteral(Call->getArg(0), Ctx);
  Repetition->set_min(Min.getLimitedValue());

  auto Max = ParseIntegerLiteral(Call->getArg(1), Ctx);
  if (Max != INT_MAX) Repetition->set_max(Max.getLimitedValue());

  for (unsigned i = 2; i < Args; ++i) {
    auto Ev = Call->getArg(i);
    if (!ParseEvent(Repetition->add_event(), Ev, AssertLoc, Ctx)) {
      Report("Failed to parse repeated event", Ev->getLocStart(), Ctx)
        << Ev->getSourceRange();
      return false;
    }
  }

  return true;
}


bool ParseFunctionCall(FunctionEvent *FnEvent, CallExpr *Call,
                       ASTContext& Ctx) {
  auto Predicate = Call->getDirectCallee();
  assert(Predicate != NULL);
  assert(Predicate->getName() == "__tesla_call");

  if (Call->getNumArgs() != 1) {
    Report("TESLA predicate should have one (boolean) argument",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return NULL;
  }

  auto Bop = dyn_cast<BinaryOperator>(Call->getArg(0)->IgnoreImplicit());
  if (!Bop || (Bop->getOpcode() != BO_EQ)) {
    Report("A TESLA predicate should be of the form foo(x) == y",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  return ParseFunctionCall(FnEvent, Bop, Ctx);
}


bool ParseFunctionCall(FunctionEvent *Event, BinaryOperator *Bop,
                       ASTContext& Ctx) {
  Expr *LHS = Bop->getLHS();
  bool LHSisICE = LHS->isIntegerConstantExpr(Ctx);

  Expr *RHS = Bop->getRHS();

  if (!(LHSisICE ^ RHS->isIntegerConstantExpr(Ctx))) {
    Report("One of {LHS,RHS} must be ICE", Bop->getLocStart(), Ctx)
      << Bop->getSourceRange();
    return false;
  }

  Expr *RetVal = (LHSisICE ? LHS : RHS);
  Expr *FnCall = (LHSisICE ? RHS : LHS);
  if (!ParseArgument(Event->mutable_expectedreturnvalue(), RetVal, Ctx))
    return false;

  auto FnCallExpr = dyn_cast<CallExpr>(FnCall);
  if (!FnCallExpr) {
    Report("Not a function call", FnCall->getLocStart(), Ctx)
      << FnCall->getSourceRange();
    return false;
  }

  auto Fn = FnCallExpr->getDirectCallee();
  if (!Fn) {
    Report("Not a direct function call", FnCallExpr->getLocStart(), Ctx)
      << FnCallExpr->getSourceRange();
    return false;
  }

  if (!ParseFunctionRef(Event->mutable_function(), Fn, Ctx)) return false;

  for (auto I = FnCallExpr->arg_begin(); I != FnCallExpr->arg_end(); ++I) {
    if (!ParseArgument(Event->add_argument(), I->IgnoreImplicit(), Ctx))
      return false;

// TODO: put this into Argument::Parse
#if 0
    auto P = I->IgnoreImplicit();

    // Each parameter must be one of:
    //  - a call to a TESLA pseudo-function,
    //  - a reference to a named declaration or
    //  - an integer constant expression.
    if (auto Call = dyn_cast<CallExpr>(P)) {
      auto Fn = Call->getDirectCallee();
      if (!Fn) {
        Report("Should only call TESLA pseudo-functions here",
            P->getLocStart(), Ctx) << P->getSourceRange();
        return NULL;
      }

      Params.push_back(Fn);
    } else if (auto DRE = dyn_cast<DeclRefExpr>(P)) {
      Params.push_back(DRE->getDecl());
    } else if (P->isIntegerConstantExpr(Ctx)) {
      Params.push_back(P);
    } else {
      P->dump();

      Report("Invalid argument to function within TESLA assertion",
          P->getLocStart(), Ctx) << P->getSourceRange();
      return NULL;
    }
#endif
  }

  return true;
}


bool ParseFunctionEntry(FunctionEvent *Event, CallExpr *Call, ASTContext& Ctx) {
  assert(Call->getDirectCallee() != NULL);
  assert(Call->getDirectCallee()->getName() == "__tesla_entered");

  Event->set_direction(FunctionEvent::Entry);

  if ((Call->getNumArgs() != 1) || (Call->getArg(0) == NULL)) {
    Report("__tesla_entered predicate should have one argument: the function",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  auto FnRef = dyn_cast<DeclRefExpr>(Call->getArg(0)->IgnoreImplicit());
  if (!FnRef) {
    Report("Expected a function call", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  auto Fn = dyn_cast<FunctionDecl>(FnRef->getDecl());
  assert(Fn != NULL);

  return ParseFunctionRef(Event->mutable_function(), Fn, Ctx);
}


bool ParseFunctionExit(FunctionEvent *Event, CallExpr *Call, ASTContext& Ctx) {
  assert(Call->getDirectCallee() != NULL);
  assert(Call->getDirectCallee()->getName() == "__tesla_leaving");

  Event->set_direction(FunctionEvent::Exit);

  if ((Call->getNumArgs() != 1) || (Call->getArg(0) == NULL)) {
    Report("__tesla_leaving predicate should have one argument: the function",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  auto FnRef = dyn_cast<DeclRefExpr>(Call->getArg(0)->IgnoreImplicit());
  if (!FnRef) {
    Report("Expected a function call", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  auto Fn = dyn_cast<FunctionDecl>(FnRef->getDecl());
  assert(Fn != NULL);

  return ParseFunctionRef(Event->mutable_function(), Fn, Ctx);
}

}

