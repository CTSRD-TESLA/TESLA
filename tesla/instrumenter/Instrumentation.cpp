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

#include "llvm/DataLayout.h"
#include "llvm/IRBuilder.h"
#include "llvm/Module.h"

using namespace llvm;

using std::string;
using std::vector;

namespace tesla {

Type* RegisterType(Module& M) {
  return DataLayout(&M).getIntPtrType(M.getContext());
}

StructType* KeyType(Module& M) {
  const char Name[] = "tesla_key";
  StructType *T = M.getTypeByName(Name);

  if (T == NULL) {
    // A struct tesla_key is just a mask and a set of keys.
    vector<Type*> KeyElements(TESLA_KEY_SIZE + 1, RegisterType(M));
    T = StructType::create(KeyElements, Name);
  }

  return T;
}


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


Function* FindStateUpdateFn(Module& M, Type *IntType) {

  LLVMContext& Ctx = M.getContext();

  Type *Char = IntegerType::get(Ctx, 8);
  Type *CharStar = PointerType::getUnqual(Char);
  Type *RegType = RegisterType(M);
  Type *KeyStar = PointerType::getUnqual(KeyType(M));

  Constant *Fn = M.getOrInsertFunction("tesla_update_state",
      IntType,    // return type
      IntType,    // context
      IntType,    // class_id
      KeyStar,    // key
      CharStar,   // name
      CharStar,   // description
      RegType,    // expected_state
      RegType,    // new_state
      NULL
    );

  assert(isa<Function>(Fn));
  return cast<Function>(Fn);
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


Value* ConstructKey(IRBuilder<>& Builder, Module& M,
                    Function::ArgumentListType& InstrArgs,
                    FunctionEvent FnEvent) {

  Value *Key = Builder.CreateAlloca(KeyType(M), 0, "key");
  Type *RegType = RegisterType(M);

  // TODO: bzero()?
  static Constant *Null = ConstantInt::get(RegType, 0);
  for (int i = 0; i < TESLA_KEY_SIZE; ++i)
    Builder.CreateStore(Null, Builder.CreateStructGEP(Key, i + 1));

  bool HaveRetVal = FnEvent.has_expectedreturnvalue();

  const int TotalArgs = FnEvent.argument_size()
     + (HaveRetVal ? 1 : 0);

  if (InstrArgs.size() != TotalArgs)
    report_fatal_error(
      "Instrumentation takes " + Twine(InstrArgs.size())
      + " but description in manifest has " + Twine(FnEvent.argument_size())
      + " arguments" + (HaveRetVal ? " and a return value" : "")
    );

  int i = 0;
  int KeyMask = 0;

  for (auto& InstrArg : InstrArgs) {
    auto& Arg = (HaveRetVal && (i == 0))
      ? FnEvent.expectedreturnvalue()
      : FnEvent.argument(HaveRetVal ? (i - 1) : i);
    ++i;

    int Index = Arg.index();

    assert(Index < TESLA_KEY_SIZE);
    assert(&InstrArg != NULL);

    KeyMask |= (1 << Index);

    Value *K = Builder.CreateStructGEP(Key, Index);

    Type *ArgType = InstrArg.getType();
    if (!CastInst::isCastable(ArgType, RegType))
      report_fatal_error(
        "Instrumentation argument " + Twine(i - 1)
        + " in " + FnEvent.function().name()
        + " cannot be cast to register_t"
      );

    Value *Reg;

    if (isa<PointerType>(ArgType)) {
      Reg = Builder.CreatePointerCast(&InstrArg, RegType);
    } else if (isa<IntegerType>(ArgType)) {
      Reg = Builder.CreateIntCast(&InstrArg, RegType, false);
    } else {
      assert(false && "instr argument neither int nor pointer");
    }

    Reg->dump();

    Builder.CreateStore(Reg, K);
  }

  Value *Mask = Builder.CreateStructGEP(Key, 0);
  Builder.CreateStore(ConstantInt::get(RegType, KeyMask), Mask);

  return Key;
}

} /* namespace tesla */

