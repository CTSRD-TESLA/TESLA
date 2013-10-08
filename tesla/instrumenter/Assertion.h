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

#include "Instrumenter.h"
#include "Transition.h"

#include <llvm/IR/IRBuilder.h>
#include <llvm/Pass.h>

#include <set>


namespace llvm {
  class CallInst;
  class Instruction;
  class Value;
}

namespace tesla {

class AssertTransition;
class Automaton;
class InstrContext;
class Manifest;
class Location;

/// Converts calls to TESLA pseudo-assertions into instrumentation sites.
class AssertionSiteInstrumenter : public Instrumenter, public llvm::ModulePass {
public:
  static char ID;
  AssertionSiteInstrumenter(const Manifest& M, bool SuppressDI)
    : Instrumenter(M, SuppressDI), ModulePass(ID) {}
  virtual ~AssertionSiteInstrumenter();

  const char* getPassName() const {
    return "TESLA assertion site instrumenter";
  }

  virtual bool runOnModule(llvm::Module &M);

private:
  //! Convert assertion declarations into instrumentation calls.
  bool ConvertAssertions(std::set<llvm::CallInst*>&, llvm::Module&);

  //! Find the automaton defined by an assertion site.
  const Automaton* FindAutomaton(llvm::CallInst *Call);

  //! Find the @ref Automaton that is defined at an assertion site.
  TEquivalenceClass AssertTrans(const Automaton*);

  //! Gather up the arguments passed to an assertion.
  std::vector<llvm::Value*> CollectArgs(llvm::Instruction *Before,
                                        const Automaton&, llvm::Module&,
                                        llvm::IRBuilder<>&);

  /**
   * Parse a @ref Location out of a @ref CallInst to the TESLA assertion
   * pseudo-call.
   */
  static void ParseAssertionLocation(Location *Loc, llvm::CallInst*);

  llvm::OwningPtr<InstrContext> InstrCtx;

  //! The TESLA pseudo-function used to declare assertions.
  llvm::Function *AssertFn = NULL;
};

}
