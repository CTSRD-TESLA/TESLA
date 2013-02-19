/** @file Visitor.cpp  Definition of @ref TeslaVisitor. */
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

#include "Parsers.h"
#include "Visitor.h"



using namespace clang;


namespace tesla {

TeslaVisitor::TeslaVisitor(ASTContext *Context)
  : Context(Context), Diag(Context->getDiagnostics())
{
}

TeslaVisitor::~TeslaVisitor() {
  for (Assertion *A : Assertions)
    delete A;
}

bool TeslaVisitor::VisitCallExpr(CallExpr *E) {
  FunctionDecl *F = E->getDirectCallee();
  if (!F) return true;
  if (!F->getName().startswith("__tesla_inline_assertion")) return true;

  OwningPtr<Assertion> Assert(new Assertion);
  if (!ParseInlineAssertion(Assert.get(), E, *Context)) {
    static int ParseFailure =
      Diag.getCustomDiagID(DiagnosticsEngine::Error,
        "Failed to parse TESLA inline assertion");

    Diag.Report(E->getLocStart(), ParseFailure) << E->getSourceRange();
    return false;
  }

  Assertions.push_back(Assert.take());

  return true;
}

} // namespace tesla

