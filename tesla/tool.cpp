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

#include "Tesla.h"

#include "llvm/Support/CommandLine.h"

#include "clang/AST/ASTConsumer.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendActions.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Tooling/CompilationDatabase.h"
#include "clang/Tooling/Tooling.h"

using namespace clang;
using namespace clang::tooling;
using namespace llvm;
using namespace tesla;


namespace tesla {

class TeslaVisitor : public RecursiveASTVisitor<TeslaVisitor> {
public:
  explicit TeslaVisitor(ASTContext *Context)
      : Context(Context), Diag(Context->getDiagnostics())
  {
  }

  bool VisitCallExpr(CallExpr *E) {
    FunctionDecl *F = E->getDirectCallee();
    if (!F) return true;
    if (!F->getName().startswith("__tesla_inline_assertion")) return true;

    if (TeslaAssertion *Assertion = TeslaAssertion::Parse(E, *Context)) {
      llvm::outs() << Assertion->Description() << "\n";
      return true;
    }

    static int ParseFailure =
      Diag.getCustomDiagID(DiagnosticsEngine::Error,
        "Failed to parse TESLA inline assertion");

    Diag.Report(E->getLocStart(), ParseFailure) << E->getSourceRange();
    return false;
  }

private:
  ASTContext *Context;
  DiagnosticsEngine& Diag;
};


class TeslaConsumer : public clang::ASTConsumer {
public:
  explicit TeslaConsumer(ASTContext *Context) : Visitor(Context) {}

  virtual void HandleTranslationUnit(clang::ASTContext &Context) {
    Visitor.TraverseDecl(Context.getTranslationUnitDecl());
  }
private:
  TeslaVisitor Visitor;
};

class TeslaAction : public clang::ASTFrontendAction {
public:
  virtual clang::ASTConsumer *CreateASTConsumer(
    clang::CompilerInstance &Compiler, llvm::StringRef InFile) {
    return new TeslaConsumer(&Compiler.getASTContext());
  }
};

cl::opt<std::string> BuildPath(
  "p",
  cl::desc("<build-path, DiagnosticsEngine&>"),
  cl::Optional);

cl::list<std::string> SourcePaths(
  cl::Positional,
  cl::desc("<source0> [... <sourceN>]"),
  cl::OneOrMore);

}

int main(int argc, const char **argv) {
  llvm::OwningPtr<CompilationDatabase> Compilations(
    FixedCompilationDatabase::loadFromCommandLine(argc, argv));

  if (!Compilations)
    llvm::report_fatal_error(
        "Need compilation options, e.g. "
        "tesla input.c -- clang -D TESLA"
    );

  cl::ParseCommandLineOptions(argc, argv);

  ClangTool Tool(*Compilations, SourcePaths);
  return Tool.run(newFrontendActionFactory<TeslaAction>());
}

