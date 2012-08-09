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

#include "Instrumentation.h"

#include "llvm/Function.h"
#include "llvm/LLVMContext.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

#include <map>
#include <vector>

using namespace llvm;

using std::map;
using std::string;
using std::vector;

namespace tesla {

class TeslaInstrumenter : public FunctionPass {
public:
  static char ID;
  TeslaInstrumenter() : FunctionPass(ID) {}

  virtual bool doInitialization(Module &M) {
    Context = &getGlobalContext();

    // TODO: remove hardcoded function names
    vector<string> FnNames;
    FnNames.push_back("example_syscall");
    FnNames.push_back("some_helper");

    for (auto Name : FnNames)
      FunctionsToInstrument[Name] =
        CalleeInstrumentation::Build(*Context, M, Name, FE_Both);

    return false;
  }

  virtual bool runOnFunction(Function &F) {
    auto I = FunctionsToInstrument.find(F.getName());
    if (I == FunctionsToInstrument.end()) return false;

    auto *FnInstrumenter = I->second;
    assert(FnInstrumenter != NULL);

    FnInstrumenter->InstrumentEntry(F);
    FnInstrumenter->InstrumentReturn(F);

    return false;
  }

private:
  LLVMContext *Context;
  map<string,CalleeInstrumentation*> FunctionsToInstrument;
};

}

char tesla::TeslaInstrumenter::ID = 0;
static RegisterPass<tesla::TeslaInstrumenter> X("tesla", "TESLA instrumenter");

