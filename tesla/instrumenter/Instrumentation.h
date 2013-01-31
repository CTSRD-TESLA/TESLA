/*! @file Instrumentation.h  Declaration of instrumentation helpers. */
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

#ifndef	TESLA_INSTRUMENTATION_H
#define	TESLA_INSTRUMENTATION_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"

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

class Automaton;
class FnTransition;

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

/// Extract the @ref register_t type from a @ref Module.
llvm::Type* RegisterType(llvm::Module&);

/**
 * Find the constant for a libtesla context (either @ref TESLA_SCOPE_PERTHREAD
 * or @ref TESLA_SCOPE_GLOBAL).
 */
llvm::Constant* TeslaContext(Assertion::Context Context,
                             llvm::LLVMContext& Ctx);

/*! Find the libtesla function @ref tesla_update_state. */
llvm::Function* FindStateUpdateFn(llvm::Module&,
                                  llvm::Type *IntType);

/**
 * Cast an integer-ish @ref Value to another type.
 *
 * We use this for casting to register_t, but it's possible that other integer
 * types might work too. Maybe.
 */
llvm::Value* Cast(llvm::Value *From, llvm::StringRef Name,
                  llvm::Type *NewType, llvm::IRBuilder<>&);

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

//! Map a set of values into a @ref tesla_key.
llvm::Value* ConstructKey(llvm::IRBuilder<>&, llvm::Module&,
                          llvm::ArrayRef<llvm::Value*> Args);

/**
 * Convert a TESLA function state transition into instrumentation code.
 *
 * @param  T     the transition in a TESLA automaton
 * @param  A     the TESLA automaton
 * @param  M     the module containing the instrumentation functions.
 */
bool AddInstrumentation(const FnTransition& T, const Automaton& A,
                        llvm::Module& M);

}

#endif	/* !TESLA_INSTRUMENTATION_H */

