/*! @file Assertion.cpp  Code for instrumenting TESLA assertion sites. */
/*
 * Copyright (c) 2012-2013 Jonathan Anderson
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
#include "Automaton.h"
#include "Debug.h"
#include "Instrumentation.h"
#include "Manifest.h"
#include "Names.h"
#include "State.h"
#include "Transition.h"

#include "tesla.pb.h"

#include <libtesla.h>

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"

#include <set>

using namespace llvm;

using std::set;
using std::string;


namespace tesla {

char AssertionSiteInstrumenter::ID = 0;

AssertionSiteInstrumenter::~AssertionSiteInstrumenter() {
  ::google::protobuf::ShutdownProtobufLibrary();
}

bool AssertionSiteInstrumenter::runOnModule(Module &M) {
  // If this module doesn't declare any assertions, just carry on.
  AssertFn = M.getFunction(INLINE_ASSERTION);
  if (!AssertFn)
    return false;

  // Find all calls to TESLA assertion pseudo-function (before we modify IR).
  set<CallInst*> AssertCalls;
  for (auto I = AssertFn->use_begin(); I != AssertFn->use_end(); ++I)
    AssertCalls.insert(cast<CallInst>(*I));

  return ConvertAssertions(AssertCalls, M);
}


bool AssertionSiteInstrumenter::ConvertAssertions(
    set<CallInst*>& AssertCalls, Module& Mod) {

  // Things we'll need later, common to all assertions.
  Type *IntPtrTy = IntPtrType(Mod);

  // Convert each assertion into appropriate instrumentation.
  for (auto *Assert : AssertCalls) {
    // Prepare to insert new code in place of the assertion.
    IRBuilder<> Builder(Assert);

    Location Loc;
    ParseAssertionLocation(&Loc, Assert);

    auto *A = M.FindAutomaton(Loc);
    assert(A);

    // Implement the assertion instrumentation.
    const NowTransition *NowTrans = NULL;
    Function *InstrFn;

    for (auto EquivClass : *A) {
      auto *Head = *EquivClass.begin();
      NowTrans = dyn_cast<NowTransition>(Head);
      if (!NowTrans)
        continue;

      if (NowTrans->Location() != Loc)
        panic("automaton '" + ShortName(Loc)
          + "' contains NOW event with location '"
          + ShortName(NowTrans->Location()) + "'");

      if (!(InstrFn = CreateInstrumentation(*A, EquivClass, Mod)))
        panic("error instrumenting NOW event");

      break;
    }

    if (!NowTrans)
      panic("automaton '" + ShortName(Loc) + "' contains no NOW event");

    // Record named values that might be passed to instrumentation, such as
    // function parameters and StoreInst results in the current BasicBlock.
    std::map<string,Value*> ValuesInScope;
    BasicBlock *Block = Assert->getParent();
    Function *Fn = Block->getParent();

    for (llvm::Argument& A : Fn->getArgumentList())
      ValuesInScope[A.getName()] = &A;

    for (auto& B : *Fn)
      for (Instruction& I : B) {
        if (&I == Assert)
          break;

        if (StoreInst *Store = dyn_cast<StoreInst>(&I)) {
          Value *V = Store->getPointerOperand();
          if (V->hasName())
            ValuesInScope[V->getName()] = V;
        }
      }

    // Find the arguments to the relevant 'now' instrumentation function.
    const AutomatonDescription& Descrip = A->getAssertion();
    size_t ArgCount = Descrip.argument_size();
    assert(ArgCount == InstrFn->getArgumentList().size());

    std::vector<Value*> Args(ArgCount, NULL);
    for (const Argument& Arg : Descrip.argument()) {
      Value *V = ValuesInScope[Arg.name()];
      if (V == NULL)
        panic("assertion references non-existent variable '" + Arg.name()
           + "'; was it defined under '#ifdef TESLA'?");

      // Find the pointer to the variable we care about, which is either a
      // stack-allocated store target or else, if there is no address-taking,
      // the variable we already have must be the pointer.
      Value *Ptr;
      for (auto i = V->use_begin(); i != V->use_end(); i++) {
        auto *Store = dyn_cast<StoreInst>(*i);
        if (!Store)
          continue;

        Ptr = Store->getPointerOperand();

        if (V == Store->getValueOperand())
          assert(isa<AllocaInst>(Ptr));
      }

      // If LLVM hasn't taken the address of our variable, it's because the
      // variable *is* an address.
      if (!Ptr)
        Ptr = V;

      Value *Val = Builder.CreateLoad(Ptr, "intrumentation_" + Arg.name());
      Args[Arg.index()] = Cast(Val, Arg.name(), IntPtrTy, Builder);
    }

    Builder.CreateCall(InstrFn, Args);

    // Delete the call to the assertion pseudo-function.
    Assert->removeFromParent();
    delete Assert;

  }

  AssertFn->removeFromParent();
  delete AssertFn;

  return true;
}


Function* AssertionSiteInstrumenter::CreateInstrumentation(
    const Automaton& A, const TEquivalenceClass& Eq, Module& M) {

  const AutomatonDescription& Descrip = A.getAssertion();
  LLVMContext& Ctx = M.getContext();

  const size_t ArgCount = Descrip.argument_size();

  Type *Void = Type::getVoidTy(Ctx);
  Type *IntPtrTy = IntPtrType(M);

  // NOW events only take arguments of type intptr_t.
  std::vector<Type*> ArgTypes(ArgCount, IntPtrTy);
  FunctionType *FnType = FunctionType::get(Void, ArgTypes, false);
  string Name = (ASSERTION_REACHED + "_" + Twine(A.ID())).str();

  Function *InstrFn = dyn_cast<Function>(M.getOrInsertFunction(Name, FnType));
  assert(InstrFn != NULL && "instrumentation function not a Function!");

  string Message = ("[NOW]  automaton " + Twine(A.ID())).str();

  BasicBlock *Instr = CreateInstrPreamble(M, InstrFn, Message,
                                          SuppressDebugInstr);
  IRBuilder<> Builder(Instr);

  Type *IntType = Type::getInt32Ty(Ctx);

  // The arguments to the function should be passed straight through to
  // libtesla via a tesla_key: they are already in the right order.
  std::vector<Value*> InstrArgs;
  for (Value& Arg : InstrFn->getArgumentList()) InstrArgs.push_back(&Arg);

  std::vector<Value*> Args;
  Args.push_back(TeslaContext(A.getAssertion().context(), Ctx));
  Args.push_back(ConstantInt::get(IntType, A.ID()));
  Args.push_back(ConstructKey(Builder, M, InstrArgs));
  Args.push_back(Builder.CreateGlobalStringPtr(A.Name()));
  Args.push_back(Builder.CreateGlobalStringPtr(A.String()));
  Args.push_back(ConstructTransitions(Builder, M, Eq));

  Function *UpdateStateFn = FindStateUpdateFn(M, IntType);
  assert(Args.size() == UpdateStateFn->arg_size());
  Builder.CreateCall(UpdateStateFn, Args);

  auto Exit = BasicBlock::Create(Ctx, "exit", InstrFn);
  IRBuilder<>(Exit).CreateRetVoid();

  Builder.CreateBr(Exit);

  return InstrFn;
}


void AssertionSiteInstrumenter::ParseAssertionLocation(
  Location *Loc, CallInst *Call) {

  assert(Call->getCalledFunction()->getName() == INLINE_ASSERTION);

  if (Call->getNumArgOperands() < 3)
    panic("TESLA assertion must have at least 3 arguments");

  // The filename should be a global variable.
  GlobalVariable *NameVar =
    dyn_cast<GlobalVariable>(Call->getOperand(0)->stripPointerCasts());

  ConstantDataArray *A;
  if (!NameVar ||
      !(A = dyn_cast_or_null<ConstantDataArray>(NameVar->getInitializer()))) {
    Call->dump();
    panic("unable to parse filename from TESLA assertion");
  }

  *Loc->mutable_filename() = A->getAsString();


  // The line and counter values should be constant integers.
  ConstantInt *Line = dyn_cast<ConstantInt>(Call->getOperand(1));
  if (!Line) {
    Call->getOperand(1)->dump();
    panic("assertion line must be a constant int");
  }

  Loc->set_line(Line->getLimitedValue(INT_MAX));

  ConstantInt *Count = dyn_cast<ConstantInt>(Call->getOperand(2));
  if (!Count) {
    Call->getOperand(2)->dump();
    panic("assertion count must be a constant int");
  }

  Loc->set_counter(Count->getLimitedValue(INT_MAX));
}

}

