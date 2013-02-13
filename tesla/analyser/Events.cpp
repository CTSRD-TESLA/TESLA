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
#include "llvm/ADT/StringSwitch.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/Basic/Diagnostic.h"

using namespace clang;
using std::vector;

namespace tesla {

bool ParseEvent(Event *Ev, Expr *E, Assertion *A,
                vector<ValueDecl*>& References, ASTContext& Ctx) {

  E = E->IgnoreImplicit();

  if (auto Ref = dyn_cast<DeclRefExpr>(E)) {
    auto D = Ref->getDecl();
    assert(D);

    // The __tesla_ignore "event" helps TESLA assertions look like ISO C.
    if (D->getName() == "__tesla_ignore") {
      Ev->set_type(Event::IGNORE);
      return true;
    }

    // The only other static __tesla_event is the "now" event.
    if (D->getName() != "__tesla_now") {
      Report("TESLA static reference must be __tesla_ignore or __tesla_now",
             E->getLocStart(), Ctx)
        << E->getSourceRange();
      return false;
    }

    Ev->set_type(Event::NOW);
    *Ev->mutable_now()->mutable_location() = A->location();
    return true;
  } else if (auto Bop = dyn_cast<BinaryOperator>(E)) {
    // This is a call-and-return like "foo(x) == y".
    Ev->set_type(Event::FUNCTION);
    return ParseFunctionCall(Ev->mutable_function(), Bop, References, Ctx);
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
    return ParseRepetition(Ev->mutable_repetition(), Call, A, References, Ctx);
  }

  typedef bool (*FnEventParser)(FunctionEvent*, CallExpr*, vector<ValueDecl*>&,
                                ASTContext&);

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
  return Parser(Ev->mutable_function(), Call, References, Ctx);
}


bool ParseRepetition(Repetition *Repetition, CallExpr *Call, Assertion *A,
                     vector<ValueDecl*>& References,
                     ASTContext& Ctx) {
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
    if (!ParseEvent(Repetition->add_event(), Ev, A, References, Ctx)) {
      Report("Failed to parse repeated event", Ev->getLocStart(), Ctx)
        << Ev->getSourceRange();
      return false;
    }
  }

  return true;
}


bool ParseFunctionCall(FunctionEvent *FnEvent, CallExpr *Call,
                       vector<ValueDecl*>& References,
                       ASTContext& Ctx) {
#ifndef NDEBUG
  auto Predicate = Call->getDirectCallee();
  assert(Predicate != NULL);
  assert(Predicate->getName() == "__tesla_call");
#endif

  if (Call->getNumArgs() != 1) {
    Report("TESLA predicate should have one (boolean) argument",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  auto Bop = dyn_cast<BinaryOperator>(Call->getArg(0)->IgnoreImplicit());
  if (!Bop || (Bop->getOpcode() != BO_EQ)) {
    Report("A TESLA predicate should be of the form foo(x) == y",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return false;
  }

  return ParseFunctionCall(FnEvent, Bop, References, Ctx);
}


bool ParseFunctionCall(FunctionEvent *Event, BinaryOperator *Bop,
                       vector<ValueDecl*>& References,
                       ASTContext& Ctx) {

  // TODO: better distinguishing between callee and/or caller
  Event->set_context(FunctionEvent::Callee);

  // Since we might care about the return value, we must instrument exiting
  // the function rather than entering it.
  Event->set_direction(FunctionEvent::Exit);

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
  if (!ParseArgument(Event->mutable_expectedreturnvalue(), RetVal, References,
                     Ctx))
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
    if (!ParseArgument(Event->add_argument(), I->IgnoreImplicit(), References,
                       Ctx))
      return false;
  }

  return true;
}


bool ParseFunctionEntry(FunctionEvent *Event, CallExpr *Call,
                        vector<ValueDecl*>& References,
                        ASTContext& Ctx) {
  assert(Call->getDirectCallee() != NULL);
  assert(Call->getDirectCallee()->getName() == "__tesla_entered");

  // TODO: better distinguishing between callee and/or caller
  Event->set_context(FunctionEvent::Callee);
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

  for (auto I = Fn->param_begin(); I != Fn->param_end(); ++I) {
    if (!ParseArgument(Event->add_argument(), *I, References, Ctx, true))
      return false;
  }

  return ParseFunctionRef(Event->mutable_function(), Fn, Ctx);
}


bool ParseFunctionExit(FunctionEvent *Event, CallExpr *Call,
                       vector<ValueDecl*>& References,
                       ASTContext& Ctx) {
  assert(Call->getDirectCallee() != NULL);
  assert(Call->getDirectCallee()->getName() == "__tesla_leaving");

  // TODO: better distinguishing between callee and/or caller
  Event->set_context(FunctionEvent::Callee);
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

  for (auto I = Fn->param_begin(); I != Fn->param_end(); ++I) {
    if (!ParseArgument(Event->add_argument(), *I, References, Ctx))
      return false;
  }

  return ParseFunctionRef(Event->mutable_function(), Fn, Ctx);
}

}

