/*! @file Manifest.cpp  Contains the definition of @ref Manifest. */
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

#include "tesla.pb.h"

#include "Manifest.h"
#include "Names.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/system_error.h"

#include <google/protobuf/text_format.h>

using namespace llvm;

using std::map;
using std::string;
using std::vector;

namespace tesla {

cl::opt<string> ManifestName("tesla-manifest", cl::init(".tesla"), cl::Hidden,
  cl::desc("Name of TESLA manifest file"));

const string Manifest::SEP = "===\n";


Manifest::~Manifest() {
  for (auto i : Automata) {
    delete i.second.Unlinked;
    delete i.second.Linked;
    delete i.second.Deterministic;
  }
}

const Automaton* Manifest::FindAutomaton(const Identifier& ID,
                                         Automaton::Type T) const {

  auto i = Automata.find(ID);
  if (i == Automata.end())
    report_fatal_error(
      "TESLA manifest does not contain assertion " + ShortName(ID));

  auto& Versions = i->second;

  switch (T) {
  case Automaton::Unlinked:       return Versions.Unlinked;
  case Automaton::Linked:         return Versions.Linked;
  case Automaton::Deterministic:  return Versions.Deterministic;
  }
}

const Automaton* Manifest::FindAutomaton(const Location& Loc,
                                         Automaton::Type T) const {

  Identifier ID;
  *ID.mutable_location() = Loc;

  return FindAutomaton(ID, T);
}


Manifest*
Manifest::load(raw_ostream& ErrorStream, StringRef Path) {
  llvm::SourceMgr SM;
  OwningPtr<MemoryBuffer> Buffer;

  error_code Error = MemoryBuffer::getFile(Path, Buffer);
  if (Error != 0) {
    ErrorStream
      << "Failed to open TESLA analysis file '" << Path << "': "
      << Error.message() << "\n"
      ;

    return NULL;
  }

  OwningPtr<ManifestFile> Protobuf(new ManifestFile);
  if (!::google::protobuf::TextFormat::ParseFromString(Buffer->getBuffer(),
                                                       Protobuf.get())) {
    ErrorStream << "Error parsing TESLA manifest '" << Path << "'\n";
    return NULL;
  }

  AutomataMap Descriptions;
  map<Identifier,AutomataVersions> Automata;

  // Note the top-level automata that are explicitly named as roots.
  ArrayRef<const Identifier*> Roots(Protobuf->root().data(),
                                    Protobuf->root_size());

  for (auto& ID : Protobuf->root())
    Automata[ID];

  for (auto& A : Protobuf->automaton())
    Descriptions[A.identifier()] = &A;

  int id = 0;
  for (auto i : Descriptions) {
    const Identifier& ID = i.first;
    const AutomatonDescription *Descrip = i.second;

    OwningPtr<NFA> A(NFA::Parse(Descrip, id++));
    if (!A) {
      for (auto i : Automata) {
        auto& Versions = i.second;
        delete Versions.Unlinked;
        delete Versions.Linked;
        delete Versions.Deterministic;
      }
      for (auto i : Descriptions) delete i.second;
      return NULL;
    }

    NFA *Linked = A->Link(Descriptions);
    DFA *Deterministic = DFA::Convert(Linked);
    Automata[ID] = AutomataVersions(A.take(), Linked, Deterministic);
  }

  return new Manifest(Protobuf, Descriptions, Automata, Roots);
}

StringRef Manifest::defaultLocation() { return ManifestName; }

} // namespace tesla

