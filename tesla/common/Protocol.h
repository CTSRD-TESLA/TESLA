/*! @file Protocol.h
 *
 * Declaration of protocol buffer helper functions.
 *
 * Annoyingly, Google Protocol Buffers don't provide operator== methods.
 * This file declares a few, as well as a couple of operator< functions.
 */
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

#ifndef PROTOCOL_H
#define PROTOCOL_H

#include "tesla.pb.h"

namespace tesla {

int ArgIndex(const Argument&);

/**
 * The name of the argument, or if it is an indirect argument, the name of
 * the base variable from which we can look up the argument.
 */
std::string BaseName(const Argument&);

template<class T>
inline bool operator != (const T& x, const T& y) { return !(x == y); }

inline bool operator ==
    (const AutomatonDescription& x, const AutomatonDescription& y) {

  if ((x.identifier() != y.identifier())
      || (x.context() != y.context())
      || (x.expression() != y.expression())
      || (x.argument_size() != y.argument_size()))
    return false;

  for (size_t i = 0; i < x.argument_size(); i++)
    if (x.argument(i) != y.argument(i))
      return false;

  if (x.has_source() != y.has_source())
    return false;

  if (x.has_source() && (x.source() != y.source()))
    return false;

  return true;
}

inline bool operator == (const Location& x, const Location& y) {
  return (
    // Don't rely on operator==(string&,string&); it might produce unexpected
    // results depending on the presence of NULL terminators.
    (strcmp(x.filename().c_str(), y.filename().c_str()) == 0)
    && (x.line() == y.line())
    && (x.counter() == y.counter())
  );
}

inline bool operator == (const Identifier& x, const Identifier& y) {
  if (x.has_name())
    return (x.name() == y.name());

  return (x.location() == y.location());
}

inline bool operator==(const Argument &A1, const Argument &A2) {
  if (A1.type() != A2.type())
    return false;

  if (A1.has_index() ^ A2.has_index())
    return false;

  if (A1.has_index() && ((A1.index() != A2.index())))
    return false;

  if (A1.has_name() ^ A2.has_name())
    return false;

  if (A1.has_name() && (A1.name() != A2.name()))
    return false;

  if (A1.has_value() ^ A2.has_value())
    return false;

  if (A1.has_value() && (A1.value() != A2.value()))
    return false;

  if (A1.has_constantmatch() ^ A2.has_constantmatch())
    return false;

  if (A1.has_indirection() ^ A2.has_indirection())
    return false;

  if (A1.has_value() && (A1.indirection() != A2.indirection()))
    return false;

  if (A1.has_field() ^ A2.has_field())
    return false;

  if (A1.has_field() && (A1.field() != A2.field()))
    return false;

  return true;
}

inline bool operator==(const AssertionSite &X, const AssertionSite &Y) {
  return X.location() == Y.location();
}

inline bool operator==(const FunctionRef &X, const FunctionRef &Y) {
  return (X.name() == Y.name());
}

inline bool operator==(const FunctionEvent &E1, const FunctionEvent &E2) {
  if (E1.function() != E2.function())
    return false;

  if (E1.has_direction() ^ E2.has_direction())
    return false;

  if (E1.has_direction() && (E1.direction() != E2.direction()))
    return false;

  if (E1.has_context() ^ E2.has_context())
    return false;

  if (E1.has_context() && (E1.context() != E2.context()))
    return false;

  if (E1.has_expectedreturnvalue() ^ E2.has_expectedreturnvalue())
    return false;

  if (E1.has_expectedreturnvalue()
      && (E1.expectedreturnvalue() != E2.expectedreturnvalue()))
    return false;

  if (E1.argument_size() != E2.argument_size()) return false;
  for (int i=0 ; i<E1.argument_size() ; i++)
    if (E1.argument(i) != E2.argument(i)) return false;

  return true;
}

inline bool operator==(const StructField &X, const StructField &Y) {
  return (
    (X.type() == Y.type())
    && (X.base() == Y.base())
    && (X.name() == Y.name())
    && (X.index() == Y.index())
  );
}

inline bool operator==(const FieldAssignment &X, const FieldAssignment &Y) {
  return (
    (X.field() == Y.field())
    && (X.operation() == Y.operation())
    && (X.value() == Y.value())
    && (X.strict() == Y.strict())
  );
}


inline bool operator < (const Location& x, const Location& y) {
  // Again, don't trust operator<(string&,string&) because of NULL funniness.
  int cmp = strcmp(x.filename().c_str(), y.filename().c_str());
  if (cmp < 0) return true;
  if (cmp > 0) return false;

  if (x.line() < y.line()) return true;
  if (x.line() > y.line()) return false;

  return (x.counter() < y.counter());
}

inline bool operator < (const Identifier& x, const Identifier& y) {
  if (x.has_name()) {
    if (!y.has_name())
      return true;

    return (x.name() < y.name());
  }

  return (x.location() < y.location());
}

inline bool operator == (const BooleanExpr& x, const BooleanExpr& y) {
  if ((x.operation() != y.operation())
      || (x.expression_size() != y.expression_size()))
    return false;

  for (size_t i = 0; i < x.expression_size(); i++)
    if (x.expression(i) != y.expression(i))
      return false;

  return true;
}

inline bool operator == (const Sequence& x, const Sequence& y) {
  if ((x.expression_size() != y.expression_size()))
    return false;

  for (size_t i = 0; i < x.expression_size(); i++)
    if (x.expression(i) != y.expression(i))
      return false;

  if (x.has_minreps() != y.has_minreps())
    return false;

  if (x.has_minreps() && (x.minreps() != y.minreps()))
    return false;

  if (x.has_maxreps() != y.has_maxreps())
    return false;

  if (x.has_maxreps() && (x.maxreps() != y.maxreps()))
    return false;

  return true;
}

inline bool operator == (const Expression& x, const Expression& y) {
  if (x.type() != y.type())
    return false;

  switch (x.type()) {
  case Expression::BOOLEAN_EXPR:
    return (x.booleanexpr() == y.booleanexpr());

  case Expression::SEQUENCE:
    return (x.sequence() == y.sequence());

  case Expression::NULL_EXPR:
    return true;

  case Expression::ASSERTION_SITE:
    return (x.assertsite() == y.assertsite());

  case Expression::FUNCTION:
    return (x.function() == y.function());

  case Expression::FIELD_ASSIGN:
    return (x.fieldassign() == y.fieldassign());

  case Expression::SUB_AUTOMATON:
    return (x.subautomaton() == y.subautomaton());
  }
}

inline bool operator == (const Usage& x, const Usage& y) {
  if ((x.identifier() != y.identifier())
      || (x.has_beginning() != y.has_beginning())
      || (x.has_end() != y.has_end()))
    return false;

  if (x.has_beginning() && (x.beginning() != y.beginning()))
    return false;

  if (x.has_end() && (x.end() != y.end()))
    return false;

  return true;
}

} // namespace tesla

#endif  // TRANSITION_H

