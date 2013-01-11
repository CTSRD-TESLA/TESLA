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

#ifndef	TESLA_INSTRUMENTATION_H
#define	TESLA_INSTRUMENTATION_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Function.h"
#include "llvm/IRBuilder.h"

#include "tesla.pb.h"

namespace llvm {
  class BasicBlock;
  class Constant;
  class Instruction;
  class LLVMContext;
  class Module;
  class Twine;
  class Type;
  class Value;
}

namespace tesla {

/// Instrumentation on a single instruction that does not change control flow.
class InstInstrumentation {
public:
   /// Optionally decorate an instruction with calls to instrumentation.
   /// @returns whether or not any instrumentation was actually added.
   virtual bool Instrument(llvm::Instruction&) = 0;
};

/// A container for function arguments, which shouldn't be very numerous.
typedef llvm::SmallVector<llvm::Value*,3> ArgVector;

/// A container for a few types (e.g., of function arguments).
typedef llvm::SmallVector<llvm::Type*,3> TypeVector;

/*!
 * Create a BasicBlock that passes values to printf.
 *
 *
 *
 * TODO: remove this once we do more meaningful instrumentation.
 */
llvm::BasicBlock* CallPrintf(llvm::Module& Mod,
                             const llvm::Twine& Prefix,
                             llvm::Function *F = NULL,
                             llvm::BasicBlock *InsertBefore = NULL);

/**
 * Find the function within a given module that receives instrumentation events
 * of a given type.
 *
 * @returns  NULL if no such function exists yet
 */
llvm::Function *FindInstrumentationFn(llvm::Module& M, llvm::StringRef Name,
                                      FunctionEvent::Direction Dir,
                                      FunctionEvent::CallContext Ctx);

/**
 * Find the constant for a libtesla context (either @ref TESLA_SCOPE_PERTHREAD
 * or @ref TESLA_SCOPE_GLOBAL).
 */
llvm::Constant* TeslaContext(Automaton::Context Context,
                             llvm::LLVMContext& Ctx);

/**
 * Map instrumentation arguments into a @ref tesla_key that can be used to
 * look up automata.
 *
 * @param  RegType     the @ref register_t type
 */
llvm::Value* ConstructKey(llvm::IRBuilder<>& Builder,
                          llvm::Type *RegType,
                          llvm::Function::ArgumentListType& InstrumentationArgs,
                          FunctionEvent FnEventDescription);

}

#endif	/* !TESLA_INSTRUMENTATION_H */

