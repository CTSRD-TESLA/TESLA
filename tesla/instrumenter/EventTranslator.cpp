//! @file EventTranslator.cpp  Definition of @ref tesla::EventTranslator.
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


void EventTranslator::CallSunrise(const Automaton::Lifetime& Lifetime) {

  std::vector<Value*> Args;
  Args.push_back(InstrCtx.TeslaContext(Lifetime.Context));
  Args.push_back(InstrCtx.BuildLifetime(Lifetime));

  Builder.CreateCall(InstrCtx.SunriseFn(), Args);
}


void EventTranslator::CallSunset(const Automaton::Lifetime& Lifetime) {
  std::vector<Value*> Args;
  Args.push_back(InstrCtx.TeslaContext(Lifetime.Context));
  Args.push_back(InstrCtx.BuildLifetime(Lifetime));

  Builder.CreateCall(InstrCtx.SunsetFn(), Args);
}


void EventTranslator::CallUpdateState(const Automaton& A, uint32_t Symbol) {
  std::vector<Value*> Args;
  Args.push_back(InstrCtx.TeslaContext(A.getAssertion().context()));
  Args.push_back(InstrCtx.ExternalDescription(A));
  Args.push_back(ConstantInt::get(InstrCtx.Int32Ty, Symbol));
  Args.push_back(Key);

  Builder.CreateCall(InstrCtx.UpdateStateFn(), Args);
}
