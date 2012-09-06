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

#include "Events.h"

using namespace llvm;

using std::string;
using std::vector;

namespace tesla {

// ==== TeslaEvent implementation ==============================================
yaml::Node* TeslaEvent::Yaml() const {
  auto Map = new yaml::Map;
  auto& M = *Map;

  auto Type = new yaml::Sequence;
  *Type << "event" << EventType;
  M.set("type", Type);

  // Event-specific data.
  M.set("data", EventData());

  return Map;
}



// ==== Repetition implementation ==============================================
Repetition::Repetition(OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
                       APInt Min)
  : TeslaEvent("repeat"), Events(Events.take()), Len(Len),
    Min(Min), HaveMax(false)
{
}


Repetition::Repetition(OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
                       APInt Min, APInt Max)
  : TeslaEvent("repeat"), Events(Events.take()), Len(Len),
    Min(Min), Max(Max), HaveMax(true)
{
}

yaml::Node* Repetition::EventData() const {
  auto Map = new yaml::Map();
  auto& M = *Map;

  M.set("min", Min.toString(10, false));
  if (HaveMax) M.set("max", Max.toString(10, false));

  llvm::OwningPtr<yaml::Sequence> Seq(new yaml::Sequence);
  for (unsigned I = 0; I < Len; I++) *Seq << Events[I]->Yaml();

  M.set("events", Seq.take());

  return Map;
}



// ==== Now implementation =====================================================
Now::Now(Location Loc) : TeslaEvent("now"), ID(Loc) {}

yaml::Node* Now::EventData() const {
  auto Map = new yaml::Map;
  Map->set("id", ID.Yaml());

  return Map;
}



// ==== FunctionEvent implementation ===========================================
FunctionEvent::FunctionEvent(FunctionRef Function, string FnEventType,
                             const vector<Argument*>& Args, Argument *Ret)
  : TeslaEvent("function"), FnEventType(FnEventType), Function(Function),
    ExpectedReturn(Ret)
{
  this->Args = new yaml::Map;
  // TODO: arguments in a map, maybe? we don't care about all of them.
}

yaml::Node* FunctionEvent::EventData() const {
  auto *Map = new yaml::Map;
  auto& M = *Map;

  M.set("name", yaml::Value::of(Function.getName()));
  if (!Args->empty()) M.set("args", Args);

  return Map;
}



// ==== Function{Entry,Exit,Call,Return} implementation ========================
FunctionEntry::FunctionEntry(FunctionRef Fn) : FunctionEvent(Fn, "entry") {}
FunctionExit::FunctionExit(FunctionRef Fn) : FunctionEvent(Fn, "exit") {}

FunctionCall::FunctionCall(
    FunctionRef Fn, vector<Argument*> Params, Argument* ExpectedReturn)
  : FunctionEvent(Fn, "call"), ExpectedReturn(ExpectedReturn)
{
  ParamStorage.reset(new Argument*[Params.size()]);
  for (unsigned I = 0; I < Params.size(); I++) ParamStorage[I] = Params[I];

  this->Params = ArrayRef<Argument*>(ParamStorage.get(), Params.size());
}

}

