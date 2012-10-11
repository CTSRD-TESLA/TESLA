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

#include "llvm/Function.h"
#include "llvm/Instructions.h"
#include "llvm/LLVMContext.h"
#include "llvm/Module.h"
#include "llvm/Pass.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/system_error.h"

#include <google/protobuf/text_format.h>

using namespace llvm;

using std::string;
using std::vector;

namespace tesla {

cl::opt<string> ManifestName("tesla-manifest", cl::init(".tesla"), cl::Hidden,
  cl::desc("Name of TESLA manifest file"));

const string Manifest::SEP = "===\n";

Manifest::Manifest(ArrayRef<Automaton*> Automata)
  : Storage(new Automaton*[Automata.size()]),
    Automata(Storage.get(), Automata.size())
{
  for (size_t i = 0; i < Automata.size(); i++)
    Storage[i] = Automata[i];
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

  SmallVector<Automaton*, 3> Automata;
  const string& CompleteBuffer = Buffer->getBuffer().str();

  // The text file delineates individual automata with the string '==='.
  for (size_t Pos = 0; Pos < CompleteBuffer.length(); ) {
    size_t End = CompleteBuffer.find(SEP, Pos + 1);
    const string& Substr = CompleteBuffer.substr(Pos, End - Pos);

    OwningPtr<Automaton> Auto(new Automaton);
    if (!::google::protobuf::TextFormat::ParseFromString(Substr, &(*Auto))) {
      ErrorStream << "Error parsing TESLA automaton in '" << Path << "'\n";

      for (auto A : Automata) delete A;
      return NULL;
    }

    Automata.push_back(Auto.take());
    Pos = End + SEP.length();
  }

  return new Manifest(Automata);
}

StringRef Manifest::defaultLocation() { return ManifestName; }

vector<FunctionEvent> Manifest::FunctionsToInstrument() {
  vector<FunctionEvent> FnEvents;

  for (auto& Ev : Events()) {
    assert(Event::Type_IsValid(Ev.type()));
    if (Ev.type() == Event::FUNCTION) FnEvents.push_back(Ev.function());
  }

  // TODO: unroll repeated events; return a vector<FunctionRef>

  return FnEvents;
}

vector<Event> ExprEvents(const Expression& E) {
  assert(Expression::Type_IsValid(E.type()));

  vector<Event> Events;

  switch (E.type()) {
    case Expression::BOOLEAN_EXPR:
      assert(E.has_booleanexpr());
      for (auto& Expr : E.booleanexpr().expression()) {
        auto Sub = ExprEvents(Expr);
        for (auto& Ev : Sub) assert(Event::Type_IsValid(Ev.type()));
        Events.insert(Events.end(), Sub.begin(), Sub.end());
      }
      break;

    case Expression::SEQUENCE:
      assert(E.has_sequence());
      auto Seq = E.sequence().event();
      Events.insert(Events.begin(), Seq.begin(), Seq.end());
      break;
  }

  return Events;
}

vector<Event> Manifest::Events() {
  vector<Event> AllEvents;

  for (auto *A : Automata) {
    auto Expr = ExprEvents(A->expression());
    for (auto& Ev : Expr) assert(Event::Type_IsValid(Ev.type()));
    AllEvents.insert(AllEvents.end(), Expr.begin(), Expr.end());
  }

  return AllEvents;
}

}

