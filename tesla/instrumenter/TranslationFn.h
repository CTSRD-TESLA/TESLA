//! @file TranslationFn.h  Declaration of @ref tesla::TranslationFn.
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

#ifndef	TESLA_TRANSLATION_FN_H
#define	TESLA_TRANSLATION_FN_H

#include "InstrContext.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <libtesla.h>

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
class EventTranslator;
class InstrContext;
class TranslationFn;



/**
 * An instrumentation function that translates program events such as
 * "called foo(42,97)" into automaton-friendly events such as
 * "send symbol 3 to automaton 'foo' with instance name (42,97)".
 *
 * Event translators match program events against programmer-supplied
 * patterns and, when they match, forward events to libtesla.
 */
class TranslationFn {
public:
  void InsertCallBefore(llvm::Instruction*, llvm::ArrayRef<llvm::Value*>);
  void InsertCallAfter(llvm::Instruction*, llvm::ArrayRef<llvm::Value*>);

  /**
   * Add instrumentation for an assertion.
   */
  EventTranslator AddInstrumentation(const Automaton&);

  /**
   * Add instrumentation for a function-esque event.
   *
   * This currents includes C function calls and Objective-C messages,
   * but could include C++ methods and other things in the future.
   *
   * Languages that use C calling conventions for FFI (a lot of them)
   * should Just Work today.
   */
  EventTranslator AddInstrumentation(const FunctionEvent&,
                                     llvm::StringRef Label = "");

  // TODO: drop this if ObjC doesn't absolutely need it
  llvm::Function* getImplementation() { return InstrFn; }


private:
  static TranslationFn* Create(InstrContext&, llvm::StringRef InstrFnName,
                               llvm::FunctionType *InstrType,
                               llvm::StringRef PrintfPrefix,
                               llvm::GlobalValue::LinkageTypes);

  /*!
   * Initialise an instrumentation function's preamble.
   *
   * For instance, we might like to insert a (conditional) printf that describes
   * the event being interpreted.
   */
  static llvm::BasicBlock* CreatePreamble(InstrContext&, llvm::Function*,
                                          llvm::Twine Prefix);

  /**
   * Low-level implementation of instrumentation block creation.
   *
   * @param  Label      A prefix used for @ref BasicBlock labels.
   * @param  Patterns   Patterns describing expected values, in the same order
   *                    as the instrumentation function's parameters.
   * @param  Indirect   Chase indirections (structure fields and dereferences).
   * @param  FreeMask   Mask of free variables to only-sort-of ignore
   */
  EventTranslator AddInstrumentation(llvm::StringRef Label,
                                     llvm::ArrayRef<Argument> Patterns,
                                     bool Indirect, uint32_t FreeMask = 0);
  /**
   * Check @a Val against @a Pattern, branching to @a Instr if it doesn't match.
   */
  llvm::BasicBlock* Match(llvm::Twine Label, llvm::BasicBlock *Instr,
                          const Argument& Pattern, llvm::Value *Val);

  TranslationFn(InstrContext& InstrCtx, llvm::Function *InstrFn,
                llvm::BasicBlock *End)
    : InstrCtx(InstrCtx), InstrFn(InstrFn), End(End)
  {
  }

  InstrContext& InstrCtx;

  llvm::Function *InstrFn;      //!< The instrumentation function.
  llvm::BasicBlock *End;        //!< End of the instrumentation chain.

  friend class InstrContext;
};

}

#endif	/* !TESLA_TRANSLATION_FN_H */
