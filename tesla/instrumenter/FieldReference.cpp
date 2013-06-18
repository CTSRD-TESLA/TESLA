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

#include "Annotations.h"
#include "Debug.h"
#include "FieldReference.h"
#include "Instrumentation.h"
#include "Manifest.h"
#include "Names.h"
#include "Transition.h"

#include <llvm/ADT/StringMap.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/raw_ostream.h>  // TODO: tmp

#include <map>
#include <set>

using namespace llvm;
using std::map;
using std::set;
using std::string;


namespace tesla {

char FieldReferenceInstrumenter::ID = 0;
raw_ostream& debug = debugs("tesla.instrumentation.field_assign");


/** Instrumentation for a struct field assignment. */
class FieldInstrumentation {
public:
  void AppendInstrumentation(const Automaton&, const TEquivalenceClass&);

  std::string CompleteFieldName() const {
    return (StructTy->getName() + "." + FieldName).str();
  }

  Function* getTarget() const { return InstrFn; }

  FieldInstrumentation(Function *InstrFn, Module& M, const StructType *T,
                       const StringRef FieldName, size_t FieldIndex)
    : InstrFn(InstrFn), Exit(FindBlock("exit", *InstrFn)), M(M),
      StructTy(T), FieldName(FieldName)
  {
  }

private:
  BasicBlock* NextInstrBlock(const Automaton*);

  Function *InstrFn;
  BasicBlock *Exit;
  Module& M;
  const StructType *StructTy;
  const StringRef FieldName;

  map<const Automaton*,BasicBlock*> NextInstr;
};


FieldReferenceInstrumenter::~FieldReferenceInstrumenter() {
  for (auto& i : Instrumentation)
    delete i.second;
}


bool FieldReferenceInstrumenter::runOnModule(Module &Mod) {
  debug
    << "===================================================================\n"
    << __PRETTY_FUNCTION__ << "\n"
    << "-------------------------------------------------------------------\n"
    << "module:                    " << Mod.getModuleIdentifier() << "\n";

  this->Mod = &Mod;

  //
  // First, find all struct fields that we want to instrument.
  //
  for (auto *Root : M.RootAutomata())
    BuildInstrumentation(*M.FindAutomaton(Root->identifier()));

  debug << "instrumentation:\n";
  for (auto& i : Instrumentation) {
    debug << "  " << i.getKey() << " -> ";
    i.getValue()->getTarget()->getType()->print(debug);
    debug << "\n";
  }

  debug
    << "-------------------------------------------------------------------\n"
    << "looking for field references...\n"
    ;

  //
  // Then, iterate through all uses of the LLVM pointer annotation and look
  // for structure accesses.
  //
  std::map<LoadInst*,FieldInstrumentation*> Loads;
  std::map<StoreInst*,FieldInstrumentation*> Stores;

  //
  // Look through all of the functions that start with llvm.ptr.annotation.
  //
  for (Function& Fn : Mod.getFunctionList()) {
    if (!Fn.getName().startswith(LLVM_PTR_ANNOTATION))
      continue;

    for (auto i = Fn.use_begin(); i != Fn.use_end(); i++) {
      // We should be able to do some parsing of all annotations.
      OwningPtr<PtrAnnotation> A(PtrAnnotation::Interpret(*i));
      assert(A);

      // We only care about struct field annotations; ignore everything else.
      auto *Annotation = dyn_cast<FieldAnnotation>(A.get());
      if (!Annotation)
        continue;

      // Not every struct field will have instrumentation defined for it.
      auto Name = Annotation->completeFieldName();
      auto *Instr = Instrumentation[Name];
      if (Instr == NULL)
        continue;

      for (User *U : *Annotation) {
        auto *Cast = dyn_cast<CastInst>(U);
        if (!Cast) {
          U->dump();
          panic("annotation user not a bitcast", false);
        }

        for (auto k = Cast->use_begin(); k != Cast->use_end(); k++) {
          if (auto *Load = dyn_cast<LoadInst>(*k))
            Loads.insert(std::make_pair(Load, Instr));

          else if (auto *Store = dyn_cast<StoreInst>(*k))
            Stores.insert(std::make_pair(Store, Instr));

          else {
            k->dump();
            panic("expected load or store with annotated value", false);
          }
        }
      }
    }
  }

  for (auto i : Loads)
    InstrumentLoad(i.first, i.second);

  for (auto i : Stores)
    InstrumentStore(i.first, i.second);

  return true;
}


void FieldReferenceInstrumenter::BuildInstrumentation(const Automaton& A) {
  for (auto& Transitions : A)
    GetInstr(A, Transitions);
}


FieldInstrumentation* FieldReferenceInstrumenter::GetInstr(
    const Automaton& A, const TEquivalenceClass& Trans) {

  auto *Head = dyn_cast<FieldAssignTransition>(*Trans.begin());
  if (!Head)      // ignore other kinds of transitions
    return NULL;

  debug << Head->String() << "\n";
  auto& Protobuf = Head->Assignment();
  auto StructName = Protobuf.type();
  auto FieldName = Protobuf.fieldname();
  string FullName = StructName + "." + FieldName;

  FieldInstrumentation *Instr;

  auto Existing = Instrumentation.find(FullName);
  if (Existing != Instrumentation.end())
    Instr = Existing->second;

  else {
    StructType *T = Mod->getTypeByName("struct." + StructName);
    if (!T)         // ignore structs that aren't used by this module
      return NULL;

    Function *InstrFn =
      StructInstrumentation(*Mod, T, FieldName, Protobuf.index(), true,
                            SuppressDebugInstr);

    Instr = new FieldInstrumentation(InstrFn, *Mod, T,
                                     FieldName, Protobuf.index());

    Instrumentation[FullName] = Instr;
  }

  Instr->AppendInstrumentation(A, Trans);

  return Instr;
}


bool FieldReferenceInstrumenter::InstrumentLoad(
    LoadInst*, FieldInstrumentation*) {

  //
  // We don't actually instrument loads yet: we can't describe such references
  // in the C-based automaton description language.
  //

  return true;
}


bool FieldReferenceInstrumenter::InstrumentStore(
    StoreInst *Store, FieldInstrumentation *Instr) {

  assert(Store != NULL);
  assert(Instr != NULL);

  debug << "instrumenting: ";
  Store->print(debug);
  debug << "\n";

  assert(Store->getNumOperands() > 1);
  Value *Val = Store->getOperand(0);
  Value *Ptr = Store->getOperand(1);

  // Find the struct pointer this field was derived from.
  Value *V = Ptr;
  Value *StructPtr = NULL;

  do {
    User *U = dyn_cast<User>(V);
    if (!U) {
      V->print(debug);
      debug << " is not a User!\n";
      panic("expected a User");
    }

    assert(U->getNumOperands() > 0);
    V = U->getOperand(0);

    auto *PointerTy = dyn_cast<PointerType>(V->getType());
    if (PointerTy && PointerTy->getElementType()->isStructTy())
      StructPtr = V;

  } while (StructPtr == NULL);

  std::vector<Value*> Args;
  Args.push_back(StructPtr);
  Args.push_back(Val);
  Args.push_back(Ptr);

  IRBuilder<> Builder(Store);
  Builder.CreateCall(Instr->getTarget(), Args);

  return true;
}


void FieldInstrumentation::AppendInstrumentation(
    const Automaton& A, const TEquivalenceClass& Trans) {

  debug << "AppendInstrumentation\n";

  LLVMContext& Ctx = InstrFn->getContext();
  auto *Head = dyn_cast<FieldAssignTransition>(*Trans.begin());
  assert(Head);
  auto& Protobuf = Head->Assignment();

  // The instrumentation function should be passed three parameters:
  // the struct, the new value and a pointer to the field.
  auto& Params = InstrFn->getArgumentList();
  assert(Params.size() == 3);

  auto i = Params.begin();
  llvm::Argument *Struct = &*i++;
  llvm::Argument *NewValue = &*i++;
  llvm::Argument *FieldPtr = &*i++;

  // We will definitely pass the structure's address to tesla_update_state().
  // We may also pass the new value, if it's e.g. a pointer: see below.
  SmallVector<Value*,2> KeyValues;
  KeyValues.push_back(Struct);

  // Insert new instrumention before the current "end" block for the automaton.
  auto *End = NextInstrBlock(&A);
  auto *Instr = BasicBlock::Create(Ctx, Head->ShortLabel(), InstrFn, End);
  End->replaceAllUsesWith(Instr);
  IRBuilder<> Builder(Instr);

  // Are we assigning a constant value (in which case we should try to match
  // it against a protobuf-supplied pattern) or a variable (in which case we
  // should add it to the struct tesla_key)?
  auto& ExpectedAssignment = Protobuf.value();

  switch (ExpectedAssignment.type()) {
  case Argument::Constant: {
    // Match the new value against the expected value or else ignore it.
    IntegerType *ValueType = dyn_cast<IntegerType>(NewValue->getType());
    if (!ValueType)
      panic("NewValue not an integer type");

    auto *Match = BasicBlock::Create(Ctx, "match: " + Head->ShortLabel(),
                                     InstrFn, Instr);
    Instr->replaceAllUsesWith(Match);
    IRBuilder<> Matcher(Match);

    auto *Const = ConstantInt::getSigned(ValueType, ExpectedAssignment.value());
    Const->dump();
    Value *Expected;

    switch (Protobuf.operation()) {
    case FieldAssignment::SimpleAssign:
      Expected = Const;
      break;

    case FieldAssignment::PlusEqual:
      Expected = Matcher.CreateAdd(Matcher.CreateLoad(FieldPtr), Const);
      break;

    case FieldAssignment::MinusEqual:
      Expected = Matcher.CreateSub(Matcher.CreateLoad(FieldPtr), Const);
      break;
    }

    Matcher.CreateCondBr(Matcher.CreateICmpNE(NewValue, Expected), End, Instr);
    break;
  }

  case Argument::Variable:
    KeyValues.push_back(NewValue);
    break;

  case Argument::Any:
    panic("'ANY' value should never be passed to struct field instrumentation");
  }

  Type* IntType = Type::getInt32Ty(Ctx);

  std::vector<Value*> Args;
  Args.push_back(TeslaContext(A.getAssertion().context(), Ctx));
  Args.push_back(ConstantInt::get(IntType, A.ID()));
  Args.push_back(ConstructKey(Builder, M, KeyValues));
  Args.push_back(Builder.CreateGlobalStringPtr(A.Name()));
  Args.push_back(Builder.CreateGlobalStringPtr(A.String()));
  Args.push_back(ConstructTransitions(Builder, M, Trans));

  Function *UpdateStateFn = FindStateUpdateFn(M, IntType);
  assert(Args.size() == UpdateStateFn->arg_size());
  Builder.CreateCall(UpdateStateFn, Args);
  Builder.CreateBr(Exit);
}

BasicBlock* FieldInstrumentation::NextInstrBlock(const Automaton *A) {
  auto Existing = NextInstr.find(A);
  if (Existing != NextInstr.end())
    return Existing->second;

  auto& Ctx = M.getContext();
  auto *Start = BasicBlock::Create(Ctx, A->Name(), InstrFn, Exit);
  auto *End = BasicBlock::Create(Ctx, A->Name() + ":end", InstrFn, Exit);

  Exit->replaceAllUsesWith(End);

  IRBuilder<>(Start).CreateBr(End);
  IRBuilder<>(End).CreateBr(Exit);

  NextInstr[A] = End;
  return End;
}

}
