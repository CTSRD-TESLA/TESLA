/** @file  read.cpp    Tool for reading TESLA manifests. */
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

#include "Manifest.h"
#include "tesla.pb.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Pass.h"

using namespace llvm;
using namespace tesla;

using std::string;

cl::opt<string> ManifestName(cl::desc("[manifest file]"),
                             cl::Positional, cl::Optional);

enum Command {
  ListFunctions
};

cl::opt<Command> UserCommand(cl::desc("Command to execute"), cl::Required,
  cl::values(
    clEnumValN(ListFunctions, "list-functions",
               "List functions that require instrumentation"),
    clEnumValEnd)
);

int
main(int argc, char *argv[]) {
  cl::ParseCommandLineOptions(argc, argv);

  auto& out = llvm::outs();
  auto& err = llvm::errs();

  OwningPtr<Manifest> Manifest(
    ManifestName.empty()
      ? Manifest::load(llvm::errs())
      : Manifest::load(llvm::errs(), ManifestName));

  if (!Manifest) {
    err << "Unable to read manifest '" << ManifestName << "'\n";
    return false;
  }

  switch (UserCommand) {
  case ListFunctions:
    for (auto& Fn : Manifest->FunctionsToInstrument()) {
      assert(Fn.has_function());
      auto Name = Fn.function().name();

      out
        << "Function '" << Name << "':\n  "
        << Fn.ShortDebugString()
        << "\n\n"
        ;
    }
    break;
  }

  google::protobuf::ShutdownProtobufLibrary();
  return 0;
}

