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

using std::string;
using std::vector;

namespace tesla {

cl::opt<string> ManifestName("tesla-manifest", cl::init(".tesla"), cl::Hidden,
  cl::desc("Name of TESLA manifest file"));

const string Manifest::SEP = "===\n";

const Automaton* Manifest::FindAutomaton(const Location& Loc,
                                         Automaton::Type T) const {
  size_t ID = 0;
  for (InlineAssertion *A : Assertions) {
    if (A->location() == Loc)
      return Automaton::Create(A, ID, T);

    else
      ID++;
  }

  Errors
    << "Manifest contains no assertion from " + ShortName(Loc)
    << "; candiates are:\n";

  for (InlineAssertion *A : Assertions)
    Errors << " - " << ShortName(A->location()) << "\n";

  return NULL;
}

const Automaton* Manifest::ParseAutomaton(size_t ID, Automaton::Type T) const{
  return Automaton::Create(Assertions[ID], ID, T);
}

Manifest::Manifest(ArrayRef<InlineAssertion*> Assertions, raw_ostream& Errors)
  : Errors(Errors), Storage(new InlineAssertion*[Assertions.size()]),
    Assertions(Storage.get(), Assertions.size())
{
  for (size_t i = 0; i < Assertions.size(); i++)
    Storage[i] = Assertions[i];
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

  SmallVector<InlineAssertion*, 3> Assertions;
  const string& CompleteBuffer = Buffer->getBuffer().str();

  // The text file delineates individual automata with the string '==='.
  for (size_t Pos = 0; Pos < CompleteBuffer.length(); ) {
    size_t End = CompleteBuffer.find(SEP, Pos + 1);
    const string& Substr = CompleteBuffer.substr(Pos, End - Pos);

    OwningPtr<InlineAssertion> Auto(new InlineAssertion);
    if (!::google::protobuf::TextFormat::ParseFromString(Substr, &(*Auto))) {
      ErrorStream << "Error parsing TESLA automaton in '" << Path << "'\n";

      for (auto A : Assertions) delete A;
      return NULL;
    }

    Assertions.push_back(Auto.take());
    Pos = End + SEP.length();
  }

  return new Manifest(Assertions, ErrorStream);
}

StringRef Manifest::defaultLocation() { return ManifestName; }


vector<FunctionEvent> Manifest::FunctionsToInstrument() {
  vector<FunctionEvent> FnEvents;

  for (auto &A : Assertions) {
    auto SubEvents = FunctionsToInstrument(A->expression());
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

