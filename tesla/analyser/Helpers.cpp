/*! @file helpers.cpp  Helper functions for Clang-specific TESLA parsing. */
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

#include <memory>
#include <sstream>

#include "llvm/ADT/APFloat.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/Basic/Diagnostic.h"

using namespace clang;
using namespace llvm;

using std::ostringstream;
using std::string;
using std::vector;

namespace tesla {

DiagnosticBuilder Report(StringRef Message, SourceLocation Loc,
    ASTContext& Ctx, DiagnosticsEngine::Level Level) {

  DiagnosticsEngine& Diag = Ctx.getDiagnostics();
  int DiagID = Diag.getCustomDiagID(Level, Message);
  return Diag.Report(Loc, DiagID);
}


string ParseStringLiteral(Expr* E, ASTContext& Ctx) {
  auto LiteralValue = dyn_cast<StringLiteral>(E->IgnoreImplicit());
  if (!LiteralValue) {
    Report("Not a valid TESLA string literal", E->getExprLoc(), Ctx);
    return "";
  }

  return LiteralValue->getString();
}


APInt ParseIntegerLiteral(Expr* E, ASTContext& Ctx) {
  auto LiteralValue = dyn_cast<IntegerLiteral>(E->IgnoreImplicit());
  if (!LiteralValue) {
    Report("Not a valid TESLA integer literal", E->getExprLoc(), Ctx);
    return APInt();
  }

  return LiteralValue->getValue();
}

}

