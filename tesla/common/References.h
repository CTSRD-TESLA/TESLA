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

#ifndef _TESLA_REFERENCES_H_
#define _TESLA_REFERENCES_H_

#include "yaml.h"

#include "llvm/ADT/OwningPtr.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/SmallString.h"

#include <set>
#include <string>
#include <vector>

namespace clang {
  class ASTContext;
  class Expr;
  class FunctionDecl;
}

namespace tesla {

class TeslaEvent;


//! A reference to a particular C function.
class FunctionRef {
public:
  FunctionRef(llvm::StringRef Name) : Name(Name) {}

  std::string getName() const { return Name; }

  bool operator < (const FunctionRef&) const;

  static FunctionRef Parse(clang::FunctionDecl*);

private:
  std::string Name;
  // TODO: some kind of disambiguation?
};


/*!
 * Within a TESLA assertion, a function argument is always either an lvalue or
 * else a literal.
 */
class Argument : public yaml::HasYaml {
public:
  Argument(llvm::StringRef Identifier);
  yaml::Node* Yaml() const;

  static Argument* Parse(clang::Expr*);

private:
  std::string Identifier;
};


//! A collection of things to instrument.
class Manifest {
public:
  Manifest() {}
  Manifest(const Manifest&);

  Manifest& operator += (const Manifest&);

  const std::set<FunctionRef>& Functions() { return Fns; }

private:
  std::set<FunctionRef> Fns;
};


/*!
 * A TESLA automaton can be per-thread (using its implicit synchronisation)
 * or global (with explicit synchronisation).
 */
class AutomatonContext : public yaml::HasYaml {
public:
  AutomatonContext(llvm::StringRef Name);
  yaml::Node* Yaml() const;

  static const AutomatonContext* Parse(clang::Expr*, clang::ASTContext&);

private:
  std::string Name;
};


/*!
 * A unique, location-based identifier for a TESLA assertion.
 *
 * I don't <i>expect</i> anyone to try and put more than one assertion on a
 * single line of C source code, but you never know, so we use __COUNTER__ as
 * well as __FILE__ and __LINE__.
 */
class Location : public yaml::HasYaml {
public:
  Location(llvm::StringRef Filename, llvm::APInt Line, llvm::APInt Counter);

  yaml::Node* Yaml() const;

  static Location* Parse(
      clang::Expr *Filename, clang::Expr *Line, clang::Expr *Counter,
      clang::ASTContext& Diag);

private:
  std::string Filename;
  llvm::APInt Line;
  llvm::APInt Counter;
};

}

#endif /* !_TESLA_REFERENCES_H_ */

