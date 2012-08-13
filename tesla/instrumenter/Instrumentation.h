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

#ifndef	TESLA_INSTRUMENTATION_H
#define	TESLA_INSTRUMENTATION_H

#include "llvm/ADT/StringRef.h"

#include <vector>

namespace llvm {
  class Function;
  class LLVMContext;
  class Module;
  class Value;
}

namespace tesla {

/// Function instrumentation points.
enum FnEvent {
  FE_None   = 0,
  FE_Entry  = 1,
  FE_Return = 2,
  FE_Both   = 3
};


/// Function instrumentation (callee context).
class CalleeInstrumentation {
public:
  /// Construct an object that can instrument a given function.
  static CalleeInstrumentation* Build(llvm::LLVMContext &Context,
                                      llvm::Module &M,
                                      llvm::StringRef FnName,
                                      FnEvent Where
                                     );

  /// Create instrumentation for function entry.
  /// @returns whether or not any changes were actually made
  bool InstrumentEntry(llvm::Function &Fn);

  /// Create instrumentation for function return.
  /// @returns whether or not any changes were actually made
  bool InstrumentReturn(llvm::Function&);

private:
  /// Private constructor: clients should use CalleeInstrumention::Build().
  CalleeInstrumentation(llvm::Function *Fn,
                        llvm::Function *Entry,
                        llvm::Function *Return
                       );

  llvm::Function *Fn;             ///< The function to instrument.
  llvm::Function *EntryEvent;     ///< Call when entering instrumented function.
  llvm::Function *ReturnEvent;    ///< Call when leaving instrumented function.
  std::vector<llvm::Value*> Args; ///< Translation of arguments for IRBuilder.
};

}

#endif	/* !TESLA_INSTRUMENTATION_H */

