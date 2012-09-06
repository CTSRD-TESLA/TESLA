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

#include "References.h"

using namespace llvm;


namespace tesla {

// ==== FunctionRef implementation =============================================
bool FunctionRef::operator < (const FunctionRef& Other) const {
  return (Name < Other.Name);
}



// ==== Argument implementation ================================================
yaml::Node* Argument::Yaml() const {
  auto Map = new yaml::Map;

  Map->set("type", "argument");
  Map->set("id", "identifier");
  // TODO: finish this properly (something the LLVM bits will understand)

  return Map;
}



// ==== Manifest implementation ================================================
Manifest& Manifest::operator += (const Manifest& orig)
{
  Fns.insert(orig.Fns.begin(), orig.Fns.end());

  return *this;
}



// ==== AutomatonContext implementation ========================================
const AutomatonContext PerThreadContext("per-thread");
const AutomatonContext GlobalContext("global");
const AutomatonContext InvalidContext("invalid!");

AutomatonContext::AutomatonContext(StringRef Name) : Name(Name) {}

yaml::Node* AutomatonContext::Yaml() const {
  auto Map = new yaml::Map();

  Map->set("type", yaml::Value::of("context"));
  Map->set("name", yaml::Value::of(Name));

  return Map;
}



// ==== Location implementation ================================================
Location::Location(StringRef Filename, APInt Line, APInt Counter)
  : Filename(Filename), Line(Line), Counter(Counter) {}

yaml::Node* Location::Yaml() const {
  return yaml::Value::of(Filename
      + ":" + Line.toString(10, false)
      + "#" + Counter.toString(10, false)
    );
}

}

