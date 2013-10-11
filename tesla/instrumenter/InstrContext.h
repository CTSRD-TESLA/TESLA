//! @file tesla::InstrContext.h  Declaration of @ref InstrContext.
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

#ifndef	TESLA_INSTR_CONTEXT_H
#define	TESLA_INSTR_CONTEXT_H

#include "Automaton.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <llvm/ADT/StringRef.h>

namespace llvm {
  class Constant;
  class Function;
  class FunctionType;
  class GlobalVariable;
  class IntegerType;
  class LLVMContext;
  class Module;
  class PointerType;
  class StructType;
  class Type;
  class Value;
}

namespace tesla {

class EventTranslator;
class TranslationFn;


/**
 * Per-module types and values commonly required by instrumentation.
 */
class InstrContext {
public:
  static InstrContext* Create(llvm::Module&, bool SuppressDebugPrintf = false);

  llvm::Constant* BuildAutomatonDescription(const Automaton*);
  llvm::Constant* BuildLifetime(const Automaton::Lifetime&);
  llvm::Constant* BuildLifetimeEvent(const Transition&);
  llvm::Constant* BuildTransition(const Transition&);
  llvm::Constant* BuildTransitions(const TEquivalenceClass&);

  llvm::Constant* ConstArrayPointer(llvm::Constant*);
  llvm::Constant* ConstPointer(llvm::Constant*, llvm::Type*,
                               llvm::StringRef Name = "");
  llvm::Constant* ConstStr(llvm::StringRef, llvm::StringRef Name = "");

  TranslationFn* CreateInstrFn(const Automaton&, llvm::ArrayRef<llvm::Value*>);
  TranslationFn* CreateInstrFn(const FunctionEvent&, llvm::FunctionType*);

  llvm::Constant* TeslaContext(AutomatonDescription::Context);
  llvm::Constant* ExternalDescription(const Automaton&);

  llvm::Constant* SunriseFn();
  llvm::Constant* SunsetFn();
  llvm::Constant* UpdateStateFn();

private:
  InstrContext(llvm::Module& M, llvm::LLVMContext& Ctx, llvm::Type* VoidTy,
               llvm::IntegerType* CharTy, llvm::PointerType* CharPtrTy,
               llvm::PointerType* CharPtrPtrTy,
               llvm::IntegerType* Int32Ty, llvm::IntegerType* IntPtrTy,
               llvm::StructType* AutomatonTy, llvm::PointerType* AutomatonPtrTy,
               llvm::StructType* KeyTy, llvm::PointerType* KeyPtrTy,
               llvm::StructType* LifetimeTy, llvm::PointerType *LifetimePtrTy,
               llvm::StructType* LifetimeEventTy,
               llvm::StructType* TransitionTy, llvm::PointerType* TransPtrTy,
               llvm::StructType* TransitionSetTy,
               llvm::PointerType* TransitionSetPtrTy,
               llvm::Constant* Debugging, llvm::Constant* Printf,
               bool SuppressDebugPrintf);

  llvm::Module& M;
  llvm::LLVMContext& Ctx;

  llvm::Type* VoidTy;

  llvm::IntegerType* CharTy;
  llvm::PointerType* CharPtrTy;
  llvm::PointerType* CharPtrPtrTy;

  llvm::IntegerType* Int32Ty;
  llvm::IntegerType* IntPtrTy;

  llvm::StructType* AutomatonTy;
  llvm::PointerType* AutomatonPtrTy;

  llvm::StructType* KeyTy;
  llvm::PointerType* KeyPtrTy;

  llvm::StructType* LifetimeTy;
  llvm::PointerType* LifetimePtrTy;
  llvm::StructType* LifetimeEventTy;

  llvm::StructType* TransitionTy;
  llvm::PointerType* TransPtrTy;

  llvm::StructType* TransitionSetTy;
  llvm::PointerType* TransitionSetPtrTy;

  const bool SuppressDebugPrintf;
  llvm::Constant* Debugging;
  llvm::Constant* Printf;

  friend class TranslationFn;
  friend class EventTranslator;
};

}

#endif	/* !TESLA_INSTR_CONTEXT_H */
