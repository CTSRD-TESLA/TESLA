/** @file AST.cpp    Definition of @ref TeslaAction and @ref TeslaConsumer. */
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

#include "AST.h"

#include "Parser.h"
#include "Visitor.h"

#include <clang/AST/ASTContext.h>
#include <clang/Tooling/Tooling.h>

#include <llvm/Support/raw_ostream.h>

#include <google/protobuf/text_format.h>

#include <string>

using namespace clang;
using namespace tesla;
using std::string;


namespace tesla {

TeslaConsumer::TeslaConsumer(llvm::StringRef In, llvm::StringRef Out)
  : InFile(In), OutFile(Out)
{
}

void TeslaConsumer::HandleTranslationUnit(ASTContext &Context) {
  TeslaVisitor Visitor(InFile, &Context);

  if (!Visitor.TraverseDecl(Context.getTranslationUnitDecl()))
    report_fatal_error("TESLA: error analysing '" + InFile + "'");

  string ErrorInfo;
  llvm::raw_fd_ostream Out(OutFile.str().c_str(), ErrorInfo);
  if (Out.has_error())
    report_fatal_error("TESLA: unable to open '" + OutFile + "': " + ErrorInfo);

  ManifestFile Result;
  for (const AutomatonDescription *A : Visitor.GetAutomata())
    *Result.add_automaton() = *A;

  for (const Usage *U : Visitor.RootAutomata())
    *Result.add_root() = *U;

  string ProtobufText;
  google::protobuf::TextFormat::PrintToString(Result, &ProtobufText);
  Out << ProtobufText;
}


ASTConsumer* TeslaAction::CreateASTConsumer(CompilerInstance &C,
                                            llvm::StringRef InFile)
{
  return new TeslaConsumer(InFile, OutFile);
}


FrontendAction* TeslaActionFactory::create() {
  return new TeslaAction(OutFile);
}

} // namespace tesla

