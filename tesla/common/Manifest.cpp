/*! @file Manifest.cpp  Definition of @ref tesla::Manifest. */
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

#include "Debug.h"
#include "Manifest.h"
#include "Names.h"

#include "tesla.pb.h"

#include <llvm/IR/Function.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>

#include <llvm/Support/CommandLine.h>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/system_error.h>

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
  for (auto i : Automata)
    delete i.second;
}

const Automaton* Manifest::FindAutomaton(const Identifier& ID) const {
  auto i = Automata.find(ID);
  if (i == Automata.end())
    panic("TESLA manifest does not contain assertion " + ShortName(ID));

  return i->second;
}

const Automaton* Manifest::FindAutomaton(const Location& Loc) const {
  Identifier ID;
  *ID.mutable_location() = Loc;

  return FindAutomaton(ID);
}


Manifest*
Manifest::load(raw_ostream& ErrorStream, Automaton::Type T, StringRef Path) {
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
  map<Identifier,const Automaton*> Automata;

  // Note the top-level automata that are explicitly named as roots.
  ArrayRef<const Usage*> Roots(Protobuf->root().data(), Protobuf->root_size());
  map<Identifier,const Usage*> Uses;
  for (auto *U : Roots)
    Uses[U->identifier()] = U;

  for (auto& A : Protobuf->automaton())
    Descriptions[A.identifier()] = &A;

  vector<Automaton::Lifetime> Lifetimes;

  int id = 0;
  for (auto i : Descriptions) {
    const Identifier& ID = i.first;
    const AutomatonDescription *Descrip = i.second;

    OwningPtr<NFA> N(NFA::Parse(Descrip, Uses[ID], id++));
    if (!N) {
      for (auto i : Automata) delete i.second;
      for (auto i : Descriptions) delete i.second;
      return NULL;
    }

    OwningPtr<Automaton> Result;

    if (T == Automaton::Unlinked)
      Result.reset(N.take());

    else {
      N.reset(N->Link(Descriptions));

      if (T == Automaton::Linked)
        Result.reset(N.take());

      else
        Result.reset(DFA::Convert(N.get()));
    }

    Automaton::Lifetime L = Result->getLifetime();
    if (L.Init != NULL
        and find(Lifetimes.begin(), Lifetimes.end(), L) == Lifetimes.end())
        Lifetimes.push_back(L);

    Automata[ID] = Result.take();
  }

  raw_ostream& debug = debugs("tesla.manifest.lifetimes");
  debug << "--------\nUnique automata lifetimes:\n";
  for (auto& Lifetime : Lifetimes)
    debug << " * " << Lifetime.String() << "\n";
  debug << "--------\n";

  return new Manifest(Protobuf, Descriptions, Automata, Roots, Lifetimes);
}

StringRef Manifest::defaultLocation() { return ManifestName; }

} // namespace tesla

