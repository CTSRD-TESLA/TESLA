/** @file Visitor.cpp  Definition of @ref tesla::TeslaVisitor. */
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

#include "Names.h"
#include "Parser.h"
#include "Visitor.h"

#include <clang/AST/ASTContext.h>

using namespace clang;
using std::string;


namespace tesla {

template<class T>
void ReportError(ASTContext& Ctx, StringRef Message, T *Subject) {
  DiagnosticsEngine& Diag = Ctx.getDiagnostics();
  int DiagID = Diag.getCustomDiagID(DiagnosticsEngine::Error,
                                    ("TESLA: " + Message).str());

  Diag.Report(Subject->getLocStart(), DiagID) << Subject->getSourceRange();
}


TeslaVisitor::TeslaVisitor(llvm::StringRef Filename, ASTContext *Context)
  : Filename(Filename), Context(Context)
{
}

TeslaVisitor::~TeslaVisitor() {
  for (auto *A : Automata)
    delete A;

  for (auto *R : Roots)
    delete R;
}

bool TeslaVisitor::VisitCallExpr(CallExpr *E) {
  FunctionDecl *F = E->getDirectCallee();
  if (!F) return true;

  StringRef FnName = F->getName();
  if (!FnName.startswith(TESLA_BASE)) return true;

  // TESLA function calls might be inline assertions.
  if (FnName == INLINE_ASSERTION) {
    OwningPtr<Parser> P(Parser::AssertionParser(E, *Context));
    if (!P)
      return false;

    OwningPtr<AutomatonDescription> Description;
    OwningPtr<Usage> Use;
    if (!P->Parse(Description, Use))
      return false;

    Automata.push_back(Description.take());
    Roots.push_back(Use.take());
    return true;
  }

  return true;
}


bool TeslaVisitor::VisitFunctionDecl(FunctionDecl *F) {
  // Only analyse non-deleted definitions (i.e. definitions with bodies).
  if (!F->doesThisDeclarationHaveABody())
    return true;


  // We only parse functions that return __tesla_automaton_description*.
  const Type *RetTy = F->getResultType().getTypePtr();
  if (!RetTy->isPointerType())
    return true;

  QualType Pointee = RetTy->getPointeeType();
  auto TypeID = Pointee.getBaseTypeIdentifier();
  if (!TypeID)
    return true;

  OwningPtr<Parser> P;
  StringRef FnName = F->getName();

  // Build a Parser appropriate to what we're parsing.
  string RetTypeName = TypeID->getName();
  if (RetTypeName == AUTOMATON_DESC)
    P.reset(Parser::AutomatonParser(F, *Context));

  else if ((RetTypeName == AUTOMATON_USAGE) && (FnName != AUTOMATON_USES))
    P.reset(Parser::MappingParser(F, *Context));

  else
    return true;


  // Actually parse the function.
  if (!P)
    return false;

  OwningPtr<AutomatonDescription> Description;
  OwningPtr<Usage> Use;
  if (!P->Parse(Description, Use))
    return false;

  if (Description)
    Automata.push_back(Description.take());

  if (Use)
    Roots.push_back(Use.take());

  return true;
}

} // namespace tesla
