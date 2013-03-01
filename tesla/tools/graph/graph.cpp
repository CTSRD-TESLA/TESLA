/** @file  graph.cpp    Tool for graphing TESLA manifests. */
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

#include "Automaton.h"
#include "Manifest.h"

#include "tesla.pb.h"

#include <llvm/IR/Function.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Pass.h>


using namespace llvm;
using namespace tesla;

using std::string;

cl::opt<string> ManifestName(cl::desc("<input file>"),
                             cl::Positional, cl::Required);

cl::opt<string> OutputFile("o", cl::desc("<output file>"), cl::init("-"));

cl::opt<Automaton::Type> Determinism(cl::desc("automata determinism:"),
      cl::values(
        clEnumValN(Automaton::NonDeterministic, "n" ,
                   "non-determinism allowed"),
        clEnumValN(Automaton::Deterministic, "d" , "determinism required"),
        clEnumValEnd),
      cl::init(Automaton::NonDeterministic));

int
main(int argc, char *argv[]) {
  cl::ParseCommandLineOptions(argc, argv);

  bool UseFile = (OutputFile != "-");
  OwningPtr<raw_fd_ostream> outfile;

  if (UseFile) {
    string OutErrorInfo;
    outfile.reset(new raw_fd_ostream(OutputFile.c_str(), OutErrorInfo));
  }

  raw_ostream& out = UseFile ? *outfile : llvm::outs();
  auto& err = llvm::errs();

  OwningPtr<Manifest> Manifest(Manifest::load(llvm::errs(), ManifestName));
  if (!Manifest) {
    err << "Unable to read manifest '" << ManifestName << "'\n";
    return false;
  }

  for (size_t i = 0; i < Manifest->size(); i++) {
    OwningPtr<const Automaton> Automaton(
      Manifest->ParseAutomaton(i, Determinism));

    out << Automaton->Dot() << "\n\n";
    out.flush();
  }

  google::protobuf::ShutdownProtobufLibrary();
  return 0;
}

