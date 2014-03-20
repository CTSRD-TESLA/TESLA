/** @file  print.cpp    Output information about TESLA automata. */
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

enum OutputFormat { dot, instr, names, source, summary, text };
cl::opt<OutputFormat> Format("format", cl::desc("output format"),
  cl::values(
    clEnumVal(dot,        "GraphViz dot"),
    clEnumVal(instr,      "instrumentation points"),
    clEnumVal(names,      "automata names"),
    clEnumVal(source,     "automata definitions from the original source code"),
    clEnumVal(summary,    "succinct summaries"),
    clEnumVal(text,       "textual automata representations"),
    NULL
  ),
  cl::init(summary)
);

cl::opt<Automaton::Type> Determinism(cl::desc("automata determinism:"),
      cl::values(
        clEnumValN(Automaton::Unlinked,      "r", "raw (unlinked) NFA"),
        clEnumValN(Automaton::Linked,        "n", "NFA"),
        clEnumValN(Automaton::Deterministic, "d", "DFA"),
        clEnumValEnd),
      cl::init(Automaton::Deterministic));


typedef std::vector<const Automaton*> AutomataVec;

static void PrintGraphvizDot(const AutomataVec&, llvm::raw_ostream&);
static void PrintInstrPoints(const AutomataVec&, llvm::raw_ostream&);
static void PrintAutomataNames(const AutomataVec&, llvm::raw_ostream&);
static void PrintSources(const AutomataVec&, llvm::raw_ostream&);
static void PrintSummaries(const AutomataVec&, llvm::raw_ostream&);
static void PrintTextFormat(const AutomataVec&, llvm::raw_ostream&);


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

  OwningPtr<Manifest> Manifest(
    Manifest::load(llvm::errs(), Determinism, ManifestName));

  if (!Manifest) {
    err << "Unable to read manifest '" << ManifestName << "'\n";
    return 1;
  }

  AutomataVec Automata;
  for (auto i : Manifest->AllAutomata()) {
    Identifier ID = i.first;
    auto *A = Manifest->FindAutomaton(ID);
    assert(A);

    Automata.push_back(A);
  }

  switch (Format) {
  case dot:
    PrintGraphvizDot(Automata, out);
    break;

  case instr:
    PrintInstrPoints(Automata, out);
    break;

  case names:
    PrintAutomataNames(Automata, out);
    break;

  case source:
    PrintSources(Automata, out);
    break;

  case summary:
    PrintSummaries(Automata, out);
    break;

  case text:
    PrintTextFormat(Automata, out);
    break;
  }

  google::protobuf::ShutdownProtobufLibrary();
  return 0;
}


static void PrintGraphvizDot(const AutomataVec& A, llvm::raw_ostream& out) {
  for (auto i : A) {
    out << i->Dot() << "\n\n";
  }
}


static void PrintInstrPoints(const AutomataVec& A, llvm::raw_ostream& out) {
  llvm::SmallVector<Transition const*, 16> Transitions;

  for (const Automaton *i : A) {
    for (auto& TransClass : *i)
    {
      const Transition *T = *TransClass.begin();

      bool AlreadyHave = false;
      for (auto& Existing : Transitions)
      {
        if (T->EquivalentTo(*Existing))
        {
          AlreadyHave = true;
          break;
        }
      }

      if (not AlreadyHave)
      {
        Transitions.push_back(T);
      }
    }
  }

  for (auto& t : Transitions)
    out << t->ShortLabel() << "\n";
}


static void PrintAutomataNames(const AutomataVec& A, llvm::raw_ostream& out) {
  for (auto i : A) {
    out << i->Name() << "\n";
  }
}


static void PrintSources(const AutomataVec& A, llvm::raw_ostream& out) {
  for (const Automaton *i : A) {
    out << i->Name() << ":\n" << i->SourceCode() << "\n";
  }
}


static void PrintSummaries(const AutomataVec& A, llvm::raw_ostream& out) {
  for (const Automaton *i : A) {
    out
      << i->Name() << ":\n"
      << i->StateCount() << " states, "
      << "responds to " << i->TransitionCount() << " events:\n"
      ;

    for (auto& TransClass : *i) {
      auto& Head(**TransClass.begin());
      out << "  " << Head.ShortLabel() << "\n";
    }
  }
}


static void PrintTextFormat(const AutomataVec& A, llvm::raw_ostream& out) {
  for (const Automaton *i : A) {
    out << i->String() << "\n\n";
  }
}
