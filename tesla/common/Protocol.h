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

//! Compare any two protocol buffers.
bool operator == (const ::google::protobuf::Message&,
                  const ::google::protobuf::Message&);

//! != is defined as !(==).
template<class T>
inline bool operator != (const T& x, const T& y) { return !(x == y); }

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

} // namespace tesla

#endif  // TRANSITION_H

