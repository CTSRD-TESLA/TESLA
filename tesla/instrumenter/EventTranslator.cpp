//! @file EventTranslator.cpp  Definition of @ref EventTranslator.
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

#include "Automaton.h"
#include "EventTranslator.h"
#include "InstrContext.h"

using namespace llvm;
using namespace tesla;

using std::string;
using std::vector;


void EventTranslator::CallUpdateState(const Automaton& A, uint32_t Symbol) {
  std::vector<Value*> Args;
  Args.push_back(InstrCtx.TeslaContext(A.getAssertion().context()));
  Args.push_back(InstrCtx.ExternalDescription(A));
  Args.push_back(ConstantInt::get(InstrCtx.Int32Ty, Symbol));
  Args.push_back(Key);

  Builder.CreateCall(InstrCtx.UpdateStateFn(), Args);
}


#if 0
BasicBlock* tesla::EnterContext(AutomatonDescription::Context Context,
                                const Transition& T, ArrayRef<Value*> KeyArgs,
                                Module& M, Function *Fn, BasicBlock *Next) {

  static const string BlockName = "tesla_context_entry";
  BasicBlock *BB = FindBlock(BlockName, *Fn);
  if (BB)
    return BB;

  auto& Ctx(M.getContext());

  BB = BasicBlock::Create(Ctx, BlockName, Fn, Next);
  auto *Entry = FindBlock("entry", *Fn);
  BB->moveAfter(Entry);

  Next->replaceAllUsesWith(BB);

  IRBuilder<> Builder(BB);

  Type *Void = Type::getVoidTy(Ctx);
  Type *Int32 = Type::getInt32Ty(Ctx);
  Type *Event = PointerType::getUnqual(LifetimeEventType(M));
  Type *KeyStar = PointerType::getUnqual(KeyType(M));

  auto *Target = dyn_cast<Function>(M.getOrInsertFunction(
      "tesla_enter_context",
      Void,       // return type
      Int32,      // context (global vs per-thread)
      Event,      // static event description
      KeyStar,    // dynamic event information
      NULL
  ));

  auto *Key = ConstructKey(Builder, M, KeyArgs);

  std::vector<Value*> Args;
  Args.push_back(TeslaContext(Context, Ctx));
  Args.push_back(ConstructLifetimeEvent(T, M));
  Args.push_back(Key);

  assert(Args.size() == Target->arg_size());
  Builder.CreateCall(Target, Args);
  Builder.CreateBr(Next);

  return BB;
}


BasicBlock* tesla::ExitContext(AutomatonDescription::Context Context,
                                const Transition& T, ArrayRef<Value*> KeyArgs,
                                Module& M, Function *Fn, BasicBlock *Next) {

  static const string BlockName = "tesla_context_exit";
  BasicBlock *BB = FindBlock(BlockName, *Fn);
  if (BB)
    return BB;

  auto& Ctx(M.getContext());

  BB = BasicBlock::Create(Ctx, BlockName, Fn, Next);
  IRBuilder<> Builder(BB);

  Type *Void = Type::getVoidTy(Ctx);
  Type *Int32 = Type::getInt32Ty(Ctx);
  Type *Event = PointerType::getUnqual(LifetimeEventType(M));
  Type *KeyStar = PointerType::getUnqual(KeyType(M));

  auto *Target = dyn_cast<Function>(M.getOrInsertFunction(
      "tesla_exit_context",
      Void,       // return type
      Int32,      // context (global vs per-thread)
      Event,      // static event description
      KeyStar,    // dynamic event information
      NULL
  ));

  auto *Key = ConstructKey(Builder, M, KeyArgs);

  std::vector<Value*> Args;
  Args.push_back(TeslaContext(Context, Ctx));
  Args.push_back(ConstructLifetimeEvent(T, M));
  Args.push_back(Key);

  assert(Args.size() == Target->arg_size());
  Builder.CreateCall(Target, Args);
  Builder.CreateBr(Next);

  return BB;
}
#endif
