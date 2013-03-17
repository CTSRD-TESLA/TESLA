/*
 * Copyright (c) 2012-2013 Jonathan Anderson
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

#include "llvm/Support/CommandLine.h"

#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendActions.h"
#include "clang/Tooling/CompilationDatabase.h"
#include "clang/Tooling/Tooling.h"

#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Signals.h"

#include <google/protobuf/text_format.h>

using namespace clang::tooling;
using namespace llvm;
using namespace tesla;

using std::string;


cl::opt<string> OutputFile(
  "o",
  cl::desc("<output file>"),
  cl::Required);

cl::list<string> SourcePaths(
  cl::Positional,
  cl::desc("<source0> [... <sourceN>]"),
  cl::OneOrMore);


int main(int argc, const char **argv) {
  sys::PrintStackTraceOnErrorSignal();
  llvm::PrettyStackTraceProgram X(argc, argv);

  // Add a preprocessor definition to indicate we're doing TESLA parsing.
  std::vector<const char*> args(argv, argv + argc);
  args.push_back("-D");
  args.push_back("__TESLA_ANALYSER__");

  // Change argc and argv to refer to the vector's memory.
  // The CompilationDatabase will modify these, so we shouldn't pass in
  // args.data() directly.
  argc = (int) args.size();
  assert(((size_t) argc) == args.size());    // check for overflow

  argv = args.data();

  OwningPtr<CompilationDatabase> Compilations(
    FixedCompilationDatabase::loadFromCommandLine(argc, argv));

  if (!Compilations)
    report_fatal_error(
        "Need compilation options, e.g. tesla-analyser foo.c -- -I ../include");

  cl::ParseCommandLineOptions(argc, argv);

  OwningPtr<TeslaActionFactory> Factory(new TeslaActionFactory(OutputFile));

  ClangTool Tool(*Compilations, SourcePaths);
  return Tool.run(Factory.get());
}

