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

#ifndef _TESLA_EVENTS_H_
#define _TESLA_EVENTS_H_

#include "References.h"
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
  class BinaryOperator;
  class CallExpr;
  class Expr;
  class NamedDecl;

  struct StmtRange;
}

namespace tesla {


//! An event that can be instrumented (function entry, field assignment, etc.).
class TeslaEvent : public yaml::HasYaml {
public:
  yaml::Node* Yaml() const;
  static TeslaEvent* Parse(clang::Expr*, Location AssertionLocation,
      clang::ASTContext&);

protected:
  TeslaEvent(std::string EventType) : EventType(EventType) {}

  //! Subclasses should use this to expose information about themselves.
  virtual yaml::Node* EventData() const = 0;

private:
  std::string EventType;
};


//! A repetition of events.
class Repetition : public TeslaEvent {
public:
  /** Construct a Repetition, taking ownership of Events passed in. */
  Repetition(llvm::OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
      llvm::APInt Min);
  Repetition(llvm::OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
      llvm::APInt Min, llvm::APInt Max);

  yaml::Node* EventData() const;

  static Repetition* Parse(
      clang::CallExpr*, Location AssertionLocation, clang::ASTContext&);

private:
  llvm::OwningArrayPtr<TeslaEvent*> Events;
  unsigned Len;

  llvm::APInt Min, Max;
  bool HaveMax;
};

/// The "now" event: we have reached a TESLA inline assertion.
class Now : public TeslaEvent {
public:
  Now(Location Loc);
  yaml::Node* EventData() const;

private:
  Location ID;
};


/// A TESLA event that has to do with a function.
class FunctionEvent : public TeslaEvent {
public:
  FunctionEvent(FunctionRef Function, std::string FnEventType,
                const std::vector<Argument*>& Args = std::vector<Argument*>(),
                Argument *ExpectedReturn = NULL);

  yaml::Node* EventData() const;

private:
  std::string FnEventType;
  FunctionRef Function;

  yaml::Map* Args;
  Argument* ExpectedReturn;
};

/// Entering a function.
class FunctionEntry : public FunctionEvent {
public:
  FunctionEntry(FunctionRef Function);
  static FunctionEntry* Parse(clang::CallExpr*, clang::ASTContext&);
};

/// Leaving a function.
class FunctionExit : public FunctionEvent {
public:
  FunctionExit(FunctionRef Function);
  static FunctionExit* Parse(clang::CallExpr*, clang::ASTContext&);
};

/// A function call (entry and return value bound together as a single event).
class FunctionCall : public FunctionEvent {
public:
  FunctionCall(FunctionRef Fn, std::vector<Argument*> Params,
               Argument* ExpectedReturn);

  static FunctionCall* Parse(clang::CallExpr*, clang::ASTContext&);
  static FunctionCall* Parse(
      clang::BinaryOperator *Bop, clang::ASTContext& Ctx);

private:
  llvm::OwningArrayPtr<Argument*> ParamStorage;
  llvm::ArrayRef<Argument*> Params;

  llvm::OwningPtr<Argument> ExpectedReturn;
};

}

#endif /* !_TESLA_EVENTS_H_ */

