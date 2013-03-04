/*! @file Names.cpp  Implementation of TESLA name helpers. */
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

#include "tesla.pb.h"
#include "Names.h"

#include "llvm/ADT/Twine.h"

#include <string>

using llvm::Twine;


std::string tesla::ArgString(const Argument& A) {
  switch (A.type()) {
  case Argument::Constant:
    return A.value();

  case Argument::Variable:
    return (Twine()
      + Twine(A.index())
      + "('"
      + A.name()
      + "'):"
      + A.value()
    ).str();

  case Argument::Any:
    return "<anything>";
  }
}

std::string tesla::ShortName(const Argument& A) {
  assert(&A != NULL);

  switch (A.type()) {
  case Argument::Constant:
    return A.value();

  case Argument::Variable:
    return A.name();

  case Argument::Any:
    return "X";
  }
}

std::string tesla::ShortName(const Identifier& ID) {
  if (ID.has_name())
    return ID.name();

  return ShortName(ID.location());
}

std::string tesla::ShortName(const Location& Loc) {
  return (Twine()
    + Loc.filename()
    + ":"
    + Twine(Loc.line())
    + "#"
    + Twine(Loc.counter())
  ).str();
}


bool tesla::operator == (const Location& x, const Location& y) {
  return (
    // Don't rely on operator==(string&,string&); it might produce unexpected
    // results depending on the presence of NULL terminators.
    (strcmp(x.filename().c_str(), y.filename().c_str()) == 0)
    && (x.line() == y.line())
    && (x.counter() == y.counter())
  );
}


bool tesla::operator < (const Location& x, const Location& y) {
  // Again, don't trust operator<(string&,string&) because of NULL funniness.
  return ((strcmp(x.filename().c_str(), y.filename().c_str()) < 0)
          || (x.line() < y.line())
          || (x.counter() < y.counter()));
}


bool tesla::operator == (const Identifier& x, const Identifier& y) {
  if (x.has_name())
    return (x.name() == y.name());

  return (x.location() == y.location());
}


bool tesla::operator < (const Identifier& x, const Identifier& y) {
  if (x.has_name()) {
    if (!y.has_name())
      return true;

    return (x.name() < y.name());
  }

  return (x.location() < y.location());
}

