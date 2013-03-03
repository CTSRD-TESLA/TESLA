/*! @file Names.h  Names of TESLA instrumentation points. */
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

#ifndef _TESLA_NAMES_H_
#define _TESLA_NAMES_H_

#include <string>

namespace tesla {

class Argument;
class Identifier;
class Location;

const std::string TESLA_BASE = "__tesla_";

const std::string AUTOMATON         = TESLA_BASE + "automaton_";

const std::string GLOBAL            = TESLA_BASE + "global";
const std::string PERTHREAD         = TESLA_BASE + "perthread";

const std::string ANY               = TESLA_BASE + "any";
const std::string EVENT             = TESLA_BASE + "event";
const std::string IGNORE            = TESLA_BASE + "ignore";
const std::string NOW               = TESLA_BASE + "now";
const std::string OPTIONAL          = TESLA_BASE + "optional";
const std::string SEQUENCE          = TESLA_BASE + "sequence";

const std::string INLINE_ASSERTION  = TESLA_BASE + "inline_assertion";

const std::string INSTR_BASE        = TESLA_BASE + "instrumentation_";

const std::string CALL              = INSTR_BASE + "call";
const std::string RETURN            = INSTR_BASE + "return";

const std::string CALLEE_ENTER      = INSTR_BASE + "callee_enter_";
const std::string CALLEE_LEAVE      = INSTR_BASE + "callee_return_";
const std::string CALLER_ENTER      = INSTR_BASE + "caller_enter_";
const std::string CALLER_LEAVE      = INSTR_BASE + "caller_return_";

const std::string ASSERTION_REACHED = INSTR_BASE + "assertion_reached";

//! Convert an @ref Argument into something human-readable.
std::string ArgString(const Argument&);

//! Convert an @ref Argument into a very short, human-readable name.
std::string ShortName(const Argument&);

//! Convert an @ref Identifier into a short, human-readable name.
std::string ShortName(const Identifier&);

//! Convert an @ref Location into a short, human-readable name.
std::string ShortName(const Location&);

bool operator == (const Location&, const Location&);
bool operator < (const Location&, const Location&);

bool operator == (const Identifier&, const Identifier&);
bool operator < (const Identifier&, const Identifier&);

} /* namespace tesla */

#endif

