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

#include "Assertion.h"
#include "Instrumentation.h"
#include "Names.h"

#include "tesla.pb.h"

#include "llvm/Function.h"
#include "llvm/Instructions.h"
#include "llvm/Module.h"

#include <set>

using namespace llvm;

using std::set;
using std::string;


namespace tesla {

char tesla::TeslaAssertionSiteInstrumenter::ID = 0;

TeslaAssertionSiteInstrumenter::~TeslaAssertionSiteInstrumenter() {
  ::google::protobuf::ShutdownProtobufLibrary();
}

bool TeslaAssertionSiteInstrumenter::runOnModule(Module &M) {
  Function *Fn = M.getFunction("__tesla_inline_assertion");
  if (!Fn) return false;

  // We need to forward the first three arguments to instrumentation.
  assert(Fn->arg_size() > 3);
  TypeVector ArgTypes;
  for (auto &Arg : Fn->getArgumentList()) {
    ArgTypes.push_back(Arg.getType());
    if (ArgTypes.size() == 3) break;
  }

  FunctionType *InstrType =
    FunctionType::get(Type::getVoidTy(M.getContext()), ArgTypes, false);

  Constant *Instr = M.getOrInsertFunction(ASSERTION_REACHED, InstrType);

  // Find all calls to TESLA assertion pseudo-function.
  set<CallInst*> Calls;
  for (auto I = Fn->use_begin(); I != Fn->use_end(); ++I)
    Calls.insert(cast<CallInst>(*I));

  // Translate these pseudo-calls into instrumentation calls.
  for (auto *Call : Calls) {
    assert(Call->getNumArgOperands() >= ArgTypes.size());
    ArgVector Args(Call->op_begin(), Call->op_begin() + ArgTypes.size());

    CallInst::Create(Instr, Args, "", Call);

    // Delete the call to the pseudo-function.
    Call->removeFromParent();
    delete Call;
  }

  Fn->removeFromParent();
  delete Fn;

  return true;
}

}

static RegisterPass<tesla::TeslaAssertionSiteInstrumenter> Assertions(
  "tesla-asserts", "TESLA: convert assertion sites");

