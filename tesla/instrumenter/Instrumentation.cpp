/*! @file Instrumentation.cpp  Miscellaneous instrumentation helpers. */
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

#include <tesla/libtesla.h>

#include "Instrumentation.h"
#include "Names.h"

#include "llvm/IRBuilder.h"
#include "llvm/Module.h"

using namespace llvm;

using std::string;

namespace tesla {

/// Find (or create) printf() declaration.
Function* Printf(Module& Mod) {
  auto& Ctx = Mod.getContext();

  FunctionType *PrintfType = FunctionType::get(
    IntegerType::get(Ctx, 32),                         // return: int32
    PointerType::getUnqual(IntegerType::get(Ctx, 8)),  // format string: char*
    true);                                             // use varargs

  Function* Printf = cast<Function>(
    Mod.getOrInsertFunction("printf", PrintfType));

  return Printf;
}

const char* Format(Type *T) {
    if (T->isPointerTy()) return " 0x%llx";
    if (T->isIntegerTy()) return " %d";
    if (T->isFloatTy()) return " %f";
    if (T->isDoubleTy()) return " %f";

    assert(false && "Unhandled arg type");
    abort();
}

BasicBlock* CallPrintf(Module& Mod, const Twine& Prefix, Function *F,
                       BasicBlock *InsertBefore) {
  string FormatStr(Prefix.str());
  for (auto& Arg : F->getArgumentList()) FormatStr += Format(Arg.getType());
  FormatStr += "\n";

  auto *Block = BasicBlock::Create(Mod.getContext(), "entry", F, InsertBefore);
  IRBuilder<> Builder(Block);

  ArgVector PrintfArgs(1, Builder.CreateGlobalStringPtr(FormatStr));
  for (auto& Arg : F->getArgumentList()) PrintfArgs.push_back(&Arg);

  Builder.CreateCall(Printf(Mod), PrintfArgs);

  return Block;
}

Function *FindInstrumentationFn(Module& M, StringRef Name,
                                FunctionEvent::Direction Dir,
                                FunctionEvent::CallContext Ctx) {

  StringRef Prefix;
  switch (Ctx) {
  default:
    // We don't accept e.g. (Entry | Exit); we're looking for one function.
    assert(false && "Bad CallContext passed to FindInstrumentationFn");
    break;

  case FunctionEvent::Callee:
    switch (Dir) {
      default: assert(false && "Unhandled FunctionEvent::Direction");
      case FunctionEvent::Entry:  Prefix = CALLEE_ENTER; break;
      case FunctionEvent::Exit:   Prefix = CALLEE_LEAVE; break;
    }
    break;

  case FunctionEvent::Caller:
    switch (Dir) {
      default: assert(false && "Unhandled FunctionEvent::Direction");
      case FunctionEvent::Entry:  Prefix = CALLER_ENTER; break;
      case FunctionEvent::Exit:   Prefix = CALLER_LEAVE; break;
    }
    break;
  }

  return M.getFunction((Prefix + Name).str());
}

Constant* TeslaContext(Automaton::Context Context, LLVMContext& Ctx) {
  static Type *IntType = IntegerType::get(Ctx, 64);

  static auto *Global = ConstantInt::get(IntType, TESLA_SCOPE_GLOBAL);
  static auto *PerThread = ConstantInt::get(IntType, TESLA_SCOPE_PERTHREAD);

  switch (Context) {
  default:
    // does not return
    report_fatal_error(__FILE__ ":" + Twine(__LINE__) + ": no handler for "
                        + "Automaton::" + Automaton::Context_Name(Context));

  case Automaton::Global: return Global;
  case Automaton::ThreadLocal: return PerThread;
  }
}

} /* namespace tesla */

