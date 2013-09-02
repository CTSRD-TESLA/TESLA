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

#include "Transition.h"

#include "tesla.pb.h"

#include <libtesla.h>

#include <llvm/ADT/SmallVector.h>
#include <llvm/ADT/StringRef.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>

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
class FieldAssignTransition;
class FnTransition;
class Transition;

//! Instrumentation for a function event.
class FnInstrumentation {
public:
  void AppendInstrumentation(const Automaton&, const FunctionEvent&,
                             TEquivalenceClass&);

  llvm::Function *getInstrumentationFunction() { return InstrFn; }
protected:
  FnInstrumentation(llvm::Module& M, const llvm::Function *TargetFn,
                    llvm::Function *InstrFn, FunctionEvent::Direction Dir)
    : M(M), TargetFn(TargetFn), InstrFn(InstrFn), Dir(Dir)
  {
  }

  llvm::Module& M;                  //!< The current module.
  const llvm::Function *TargetFn;   //!< The function being instrumented.
  llvm::Function *InstrFn;          //!< The instrumentation function.
  FunctionEvent::Direction Dir;     //!< Which way we instrument (in or out).
};

/**
 * Creates a new instrumentation function for a callable object (a function, an
 * Objective-C method).
 */
llvm::Function* CallableInstrumentation(llvm::Module& Mod,
                                        llvm::StringRef Name,
                                        llvm::FunctionType*,
                                        FunctionEvent::Direction Dir,
                                        FunctionEvent::CallContext Context,
                                        bool SuppressDebugInstr);

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

/// Call @ref tesla_update_state().
void UpdateState(const Automaton&, uint32_t Symbol, llvm::Value *Key,
                 llvm::Module&, llvm::BasicBlock *Next, llvm::IRBuilder<>&);

/// Extract the @a register_t type from an @a llvm::Module.
llvm::Type* IntPtrType(llvm::Module&);


/**
 * Find the constant for a libtesla context (either @ref TESLA_CONTEXT_THREAD
 * or @ref TESLA_CONTEXT_GLOBAL).
 */
llvm::Constant* TeslaContext(AutomatonDescription::Context Context,
                             llvm::LLVMContext& Ctx);

/*! Find a @a BasicBlock within a @a Function. */
llvm::BasicBlock* FindBlock(llvm::StringRef Name, llvm::Function&);

/**
 * Cast an integer-ish @a Value to another type.
 *
 * We use this for casting to register_t, but it's possible that other integer
 * types might work too. Maybe.
 */
llvm::Value* Cast(llvm::Value *From, llvm::StringRef Name,
                  llvm::Type *NewType, llvm::IRBuilder<>&);

/*!
 * Initialise the instrumentation function's preamble.
 *
 * For instance, we might like to insert a (conditional) printf that describes
 * the event being interpreted.
 */
llvm::BasicBlock* CreateInstrPreamble(llvm::Module& Mod, llvm::Function *F,
                                      const llvm::Twine& Prefix,
                                      bool SuppressDebugInstrumentation);

//! Map a set of values into a @ref tesla_key.
llvm::Value* ConstructKey(llvm::IRBuilder<>&, llvm::Module&,
                          llvm::ArrayRef<llvm::Value*> Args);

//! Declare a reference to an external @ref tesla_automaton.
llvm::Constant* ExternAutomatonDescrip(const Automaton*, llvm::Module&);

//! Construct a @ref tesla_automaton for a @ref tesla::Automaton.
llvm::Constant* ConstructAutomatonDescription(const Automaton*, llvm::Module&);

//! Poke through indirection, struct fields, etc.
llvm::Value* GetArgumentValue(llvm::Value* Param, const Argument& ArgDescrip,
                              llvm::IRBuilder<>& Builder,
                              bool AtAssertionSite = false);

//! Find (or create) one function-event instrumentation function.
llvm::Function* FunctionInstrumentation(llvm::Module&, const llvm::Function&,
                                        FunctionEvent::Direction,
                                        FunctionEvent::CallContext,
                                        bool SuppressDebugInstr);

//! Find (or create) one function-event instrumentation function given a
llvm::Function* ObjCMethodInstrumentation(llvm::Module&,
                                          llvm::StringRef Selector,
                                          llvm::FunctionType*,
                                          FunctionEvent::Direction,
                                          FunctionEvent::CallContext,
                                          bool SuppressDebugInstr);

//! Find (or create) one struct-field-event instrumentation function.
llvm::Function* StructInstrumentation(llvm::Module&, llvm::StructType*,
                                      llvm::StringRef FieldName, size_t Index,
                                      bool Store, bool SuppressDebugInstr);
}

#endif	/* !TESLA_INSTRUMENTATION_H */
