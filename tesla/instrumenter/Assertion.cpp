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
using std::vector;


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
  //Type *IntPtrTy = IntPtrType(Mod);

  // Convert each assertion into appropriate instrumentation.
  for (auto *AssertCall : AssertCalls) {
    IRBuilder<> Builder(AssertCall);
    Mod.print(llvm::outs(), NULL);

    auto *Automaton(FindAutomaton(AssertCall));
    auto AssertTransitions(this->AssertTrans(Automaton));

    auto Args(CollectArgs(AssertCall, *Automaton, Mod, Builder));

    llvm::errs() << "\n\n====\n" << Args.size() << " arg(s):\n";
    for (auto *A : Args)
      A->dump();
    llvm::errs() << "\n====\n\n\n";

    Function *InstrFn = CreateInstrumentation(*Automaton, AssertTransitions,
                                              Args, Mod);

    if (!InstrFn)
      panic("error instrumenting ASSERT_SITE event");

    Builder.CreateCall(InstrFn, Args);

    // Delete the call to the assertion pseudo-function.
    AssertCall->removeFromParent();
    delete AssertCall;

    Mod.print(llvm::outs(), NULL);
  }

  AssertFn->removeFromParent();
  delete AssertFn;

  return true;
}


const Automaton* AssertionSiteInstrumenter::FindAutomaton(CallInst *Call) {
  Location Loc;
  ParseAssertionLocation(&Loc, Call);

  return M.FindAutomaton(Loc);
}


TEquivalenceClass AssertionSiteInstrumenter::AssertTrans(const Automaton *A) {
  for (auto EquivClass : *A)
    if (isa<AssertTransition>(*EquivClass.begin()))
      return EquivClass;

  panic("automaton '" + A->Name() + "' has no assertion site event");
}


vector<Value*> AssertionSiteInstrumenter::CollectArgs(
    Instruction *Before, const Automaton& A,
    Module& Mod, IRBuilder<>& Builder) {

  // Find named values to be passed to instrumentation.
  std::map<string,Value*> ValuesInScope;
  for (auto G = Mod.global_begin(); G != Mod.global_end(); G++)
    ValuesInScope[G->getName()] = G;

  auto *Fn = Before->getParent()->getParent();
  for (auto& Arg : Fn->getArgumentList())
    ValuesInScope[Arg.getName()] = &Arg;

  auto& EntryBlock(*Fn->begin());
  for (auto& I : EntryBlock) {
    auto *Inst = dyn_cast<AllocaInst>(&I);
    if (!Inst)
      continue;

    ValuesInScope[Inst->getName()] = Builder.CreateLoad(Inst);
  }

  int ArgSize = 0;
  for (auto& Arg : A.getAssertion().argument())
    ArgSize = std::max(ArgSize + 1, Arg.index());

  vector<Value*> Args(ArgSize, NULL);

  for (auto& Arg : A.getAssertion().argument()) {
    string Name(BaseName(Arg));

    if (ValuesInScope.find(Name) == ValuesInScope.end()) {
      string s;
      raw_string_ostream Out(s);

      for (auto Name : ValuesInScope) {
        Out << "  '" << Name.first << "': ";
        Name.second->print(Out);
        Out << "\n";
      }

      panic("assertion references non-existent variable '" + BaseName(Arg)
         + "'; was it defined under '#ifdef TESLA'?\n\n"
           "Variables in scope are:\n" + Out.str());
    }

    Args[Arg.index()] = ValuesInScope[Name];
  }

#ifndef NDEBUG
    llvm::outs() << "\n\nargs:\n";
    for (auto *Arg : Args) {
      assert(Arg != NULL);

      Arg->print(llvm::outs());
      llvm::outs() << "\n";
    }
#endif

  return Args;
}


Function* AssertionSiteInstrumenter::CreateInstrumentation(
    const Automaton& A, TEquivalenceClass& TEq,
    ArrayRef<Value*> AssertArgs, Module& M) {

  auto& Assertion(A.getAssertion());
  LLVMContext& Ctx = M.getContext();
  Type *Void = Type::getVoidTy(Ctx);
  Type *Int32 = Type::getInt32Ty(Ctx);

  vector<Type*> ArgTypes;
  for (auto *Arg : AssertArgs)
    ArgTypes.push_back(Arg->getType());

  FunctionType *FnType = FunctionType::get(Void, ArgTypes, false);

  string Name = (ASSERTION_REACHED + "_" + Twine(A.ID())).str();
  Function *InstrFn = dyn_cast<Function>(M.getOrInsertFunction(Name, FnType));
  assert(InstrFn != NULL && "instrumentation function not a Function!");

  string Message = ("[ASRT] automaton " + Twine(A.ID())).str();
  BasicBlock *Instr = CreateInstrPreamble(M, InstrFn, Message,
                                          SuppressDebugInstr);

  IRBuilder<> Builder(Instr);

  std::vector<Value*> InstrArgs;
  size_t i = 0;
  for (auto& Arg : InstrFn->getArgumentList()) {
    Value *V = &Arg;
    const Argument& A(Assertion.argument(i++));

    // assertion sites are special: we can ignore indirection because we
    // have just been passed the value we want.
    if (A.type() != Argument::Indirect)
      V = GetArgumentValue(V, A, Builder);

    InstrArgs.push_back(V);
  }

  std::vector<Value*> Args;
  Args.push_back(TeslaContext(Assertion.context(), Ctx));
  Args.push_back(ConstantInt::get(Int32, A.ID()));
  Args.push_back(ConstructKey(Builder, M, InstrArgs));
  Args.push_back(Builder.CreateGlobalStringPtr(A.Name()));
  Args.push_back(Builder.CreateGlobalStringPtr(A.String()));
  Args.push_back(ConstructTransitions(Builder, M, TEq));

  Function *UpdateStateFn = FindStateUpdateFn(M, Int32);
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
