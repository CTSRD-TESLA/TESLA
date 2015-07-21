/*
 * Copyright (c) 2012-2013,2015 Jonathan Anderson
 * All rights reserved.
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
 * ("CTSRD"), as part of the DARPA CRASH research programme, as well as at
 * Memorial University under the NSERC Discovery program (RGPIN-2015-06048).
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

#ifndef  TESLA_CALL_INSTRUMENTER_PASS_H
#define  TESLA_CALL_INSTRUMENTER_PASS_H

#include "Instrumenter.hh"
#include "Instrumentation.hh"
#include "Policy.hh"

#include <llvm/Pass.h>

#include <memory>


namespace llvm
{
  class CallSite;
  class FunctionType;
}


namespace tesla {

/**
 * Instruments function calls at the call site (the caller context, rather than
 * the callee context).
 */
class CallInstrumentationPass : public Instrumenter, public llvm::ModulePass {
public:
  static char ID;
  CallInstrumentationPass();
  ~CallInstrumentationPass();

  const char* getPassName() const {
    return "TESLA function instrumenter (caller-side)";
  }

  virtual bool runOnModule(llvm::Module &) override;

private:
  const InstInstrumentation&
    InstrumentationFn(llvm::Function&, Policy::Direction);

  llvm::StringMap<std::unique_ptr<InstInstrumentation>> Instrumentation;
};

}

#endif  /* !TESLA_CALL_INSTRUMENTER_PASS_H */
