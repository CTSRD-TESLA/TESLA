/*! @file references.cpp  Parsers for TESLA references to C primitives. */
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

#include "clang/AST/Decl.h"

using namespace clang;
using std::vector;

namespace tesla {

bool ParseFunctionRef(FunctionRef *FnRef, FunctionDecl *Fn, ASTContext& Ctx) {
  assert(Fn && "Cannot parse a NULL function declaration");

  FnRef->set_name(Fn->getName());
  if (FnRef->name().empty()) {
    Report("Function must have a name", Fn->getLocStart(), Ctx)
      << Fn->getSourceRange();
    return false;
  }

  return true;
}

static int ReferenceIndex(ValueDecl* D, vector<ValueDecl*>& References) {
  size_t Pos = 0;

  for (auto I = References.begin(); I != References.end(); I++)
    if (*I == D)
      return Pos;
    else
      ++Pos;

  References.push_back(D);

  return Pos;
}

bool ParseArgument(Argument *Arg, ValueDecl *D,
                   vector<ValueDecl*>& References,
                   ASTContext& Ctx, bool AllowAny) {

  assert(Arg != NULL);
  assert(D != NULL);

  *Arg->mutable_name() = D->getName();

  if (AllowAny)
    Arg->set_type(Argument::Any);
  else {
    Arg->set_type(Argument::Variable);
    Arg->set_index(ReferenceIndex(D, References));
  }

  return true;
}

bool ParseArgument(Argument *Arg, Expr *E, vector<ValueDecl*>& References,
                   ASTContext& Ctx) {

  assert(Arg != NULL);
  assert(E != NULL);

  auto P = E->IgnoreImplicit();
  llvm::APSInt ConstValue;

  // Each parameter must be one of:
  //  - a call to a TESLA pseudo-function,
  //  - a reference to a named declaration or
  //  - an integer constant expression.
  if (auto Call = dyn_cast<CallExpr>(P)) {
    auto Fn = Call->getDirectCallee();
    if (!Fn) {
      Report("Should only call TESLA pseudo-functions here",
          P->getLocStart(), Ctx) << P->getSourceRange();
      return false;
    }

    if (Fn->getName() != "__tesla_any") {
      Report("Invalid call; expected __tesla_any()", P->getLocStart(), Ctx)
        << P->getSourceRange();
      return false;
    }

    Arg->set_type(Argument::Any);
  } else if (auto DRE = dyn_cast<DeclRefExpr>(P)) {
    Arg->set_type(Argument::Variable);
    ValueDecl *D = DRE->getDecl();

    *Arg->mutable_name() = DRE->getDecl()->getName();
    Arg->set_index(ReferenceIndex(D, References));

  } else if (P->isIntegerConstantExpr(ConstValue, Ctx)) {
    Arg->set_type(Argument::Constant);
    *Arg->mutable_value() = "0x" + ConstValue.toString(16);
  } else {
    P->dump();

    Report("Invalid argument to function within TESLA assertion",
        P->getLocStart(), Ctx) << P->getSourceRange();
    return false;
  }

  return true;
}

}

