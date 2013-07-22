/*! @file Names.h  Names of TESLA instrumentation points. */
/*
 * Copyright (c) 2012-2013 Jonathan Anderson
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

#include "Protocol.h"

#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/StringRef.h>

#include <string>

namespace tesla {

class Argument;
class Identifier;
class Location;

typedef llvm::ArrayRef<const Argument*> ReferenceVector;

const std::string LLVM_PTR_ANNOTATION = "llvm.ptr.annotation";

const std::string TESLA_BASE = "__tesla_";

const std::string AUTOMATON         = TESLA_BASE + "automaton_";
const std::string AUTOMATON_DESC    = AUTOMATON  + "description";
const std::string AUTOMATON_MAPPING = AUTOMATON  + "mapping";
const std::string AUTOMATON_USAGE   = AUTOMATON  + "usage";
const std::string AUTOMATON_USES    = TESLA_BASE + "struct_uses_automaton";

const std::string GLOBAL            = TESLA_BASE + "global";
const std::string PERTHREAD         = TESLA_BASE + "perthread";

const std::string ANY               = TESLA_BASE + "any";
const std::string EVENT             = TESLA_BASE + "event";
const std::string IGNORE            = TESLA_BASE + "ignore";
const std::string ASSERTION_SITE    = TESLA_BASE + "assertion_site";
const std::string OPTIONAL          = TESLA_BASE + "optional";
const std::string SEQUENCE          = TESLA_BASE + "sequence";

const std::string INLINE_ASSERTION  = TESLA_BASE + "inline_assertion";

const std::string INSTR_BASE        = TESLA_BASE + "instrumentation_";

const std::string STRUCT_INSTR      = INSTR_BASE + "struct_field_";
const std::string LOAD              = "load_";
const std::string STORE             = "store_";

const std::string CALL              = INSTR_BASE + "call";
const std::string RETURN            = INSTR_BASE + "return";

const std::string CALLEE            = "callee_";
const std::string CALLER            = "caller_";

const std::string ENTER             = "enter_";
const std::string EXIT              = "return_";

const std::string FLAGS             = TESLA_BASE + "flags";
const std::string MASK              = TESLA_BASE + "mask";

const std::string ASSERTION_REACHED = INSTR_BASE + "assertion_reached";

//! Convert an @ref Argument into a very short, human-readable name.
std::string ShortName(const Argument*, bool DecorateIndirection = true);

//! Convert an @ref Argument into a very short name for GraphViz's dot.
std::string DotName(const Argument*, bool DecorateIndirection = true);

//! Convert an @ref Identifier into a short, human-readable name.
std::string ShortName(const Identifier&);

//! Convert an @ref Location into a short, human-readable name.
std::string ShortName(const Location&);

//! Convert the name of an automata instance.
std::string InstanceName(const ReferenceVector&,
                         bool PlainAscii, bool DecorateIndirection);

} /* namespace tesla */

#endif
