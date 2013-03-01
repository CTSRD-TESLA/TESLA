/*! @file Manifest.cpp  Contains the definition of @ref Manifest. */
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

#include "tesla.pb.h"

#include "Manifest.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/system_error.h"

#include "llvm/Pass.h"

#include "Names.h"
#include <google/protobuf/text_format.h>

using namespace llvm;

using std::map;
using std::string;
using std::vector;

namespace tesla {

cl::opt<string> ManifestName("tesla-manifest", cl::init(".tesla"), cl::Hidden,
  cl::desc("Name of TESLA manifest file"));

const string Manifest::SEP = "===\n";


const Automaton* Manifest::FindAutomaton(const Identifier& ID,
                                         Automaton::Type T) const {

  auto i = Automata.find(ID);
  if (i == Automata.end())
    return NULL;

  NFA *A = i->second;
  if (T == Automaton::NonDeterministic)
    return A;

  else
    return DFA::Convert(A);
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

  map<Identifier,AutomatonDescription*> Descriptions;
  map<Identifier,NFA*> Automata;

  const string& CompleteBuffer = Buffer->getBuffer().str();

  // The text file delineates individual automata with the string '==='.
  for (size_t Pos = 0; Pos < CompleteBuffer.length(); ) {
    size_t End = CompleteBuffer.find(SEP, Pos + 1);
    const string& Substr = CompleteBuffer.substr(Pos, End - Pos);

    OwningPtr<AutomatonDescription> A(new AutomatonDescription);
    if (!::google::protobuf::TextFormat::ParseFromString(Substr, &(*A))) {
      ErrorStream << "Error parsing TESLA automaton in '" << Path << "'\n";

      for (auto i : Descriptions) delete i.second;
      return NULL;
    }

    Identifier ID = A->identifier();
    Descriptions[ID] = A.take();
    Pos = End + SEP.length();
  }

  int id = 0;
  for (auto i : Descriptions) {
    const AutomatonDescription *Descrip = i.second;

    OwningPtr<NFA> A(NFA::Parse(Descrip, id++));
    if (!A) {
      for (auto i : Automata) delete i.second;
      for (auto i : Descriptions) delete i.second;
      return NULL;
    }

    Automata[i.first] = A.take();
  }

  return new Manifest(Descriptions, Automata);
}

StringRef Manifest::defaultLocation() { return ManifestName; }


vector<FunctionEvent> Manifest::FunctionsToInstrument() {
  vector<FunctionEvent> FnEvents;

  for (auto i : Descriptions) {
    auto SubEvents = FunctionsToInstrument(i.second->expression());
    FnEvents.insert(FnEvents.end(), SubEvents.begin(), SubEvents.end());
  }

  return FnEvents;
}


vector<FunctionEvent> Manifest::FunctionsToInstrument(const Expression& Ex) {
  vector<FunctionEvent> Events;

  switch (Ex.type()) {
  case Expression::NULL_EXPR:     // fallthrough
  case Expression::NOW:           // fallthrough
  case Expression::FIELD_ASSIGN:
    break;

  case Expression::FUNCTION:
    Events.push_back(Ex.function());
    break;

  case Expression::BOOLEAN_EXPR:
    for (auto& E : Ex.booleanexpr().expression()) {
      auto Sub = FunctionsToInstrument(E);
      Events.insert(Events.end(), Sub.begin(), Sub.end());
    }
    break;

  case Expression::SEQUENCE:
    for (auto& E : Ex.sequence().expression()) {
      auto Sub = FunctionsToInstrument(E);
      Events.insert(Events.end(), Sub.begin(), Sub.end());
    }
    break;

  case Expression::SUB_AUTOMATON: {
    auto i = Descriptions.find(Ex.subautomaton());
    if (i == Descriptions.end())
      report_fatal_error(
        "can't find automaton '" + ShortName(Ex.subautomaton()) + "'");

    auto Sub = FunctionsToInstrument(i->second->expression());
    Events.insert(Events.end(), Sub.begin(), Sub.end());
    break;
  }

  }

  return Events;
}

} // namespace tesla

