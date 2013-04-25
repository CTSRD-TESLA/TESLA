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

/** An annotation applied by LLVM to a pointer. */
class PtrAnnotation {
public:
  virtual ~PtrAnnotation() {}

  enum AnnotationKind { AK_RawAnnotation, AK_FieldAnnotation };
  virtual AnnotationKind getKind() const { return AK_RawAnnotation; }
  static bool classof(const PtrAnnotation *P) { return true; }

  static PtrAnnotation* Interpret(User*);
  StringRef getName() const { return Name; }
  const Value* getValue() const { return Call; }

protected:
  PtrAnnotation(CallInst *Call, const Value *PtrArg, StringRef Name,
                StringRef Filename, APInt Line)
    : Call(Call), PtrArg(PtrArg), Name(Name), Filename(Filename), Line(Line)
  {
  }

  static StringRef ExtractStringConstant(const Value *V);

  CallInst *Call;
  const Value *PtrArg;
  const StringRef Name;
  const StringRef Filename;
  const APInt Line;
};

/** An annotation applied by LLVM to a structure field access. */
class FieldAnnotation : public PtrAnnotation {
public:
  virtual AnnotationKind getKind() const { return AK_FieldAnnotation; }
  static bool classof(const PtrAnnotation *P) {
    return (P->getKind() == AK_FieldAnnotation);
  }

  StringRef getStructName() const { return StructName; }
  StringRef getFieldName() const { return FieldName; }
  string completeFieldName() const {
    return (StructName + "." + FieldName).str();
  }

  Value::use_iterator begin() { return Call->use_begin(); }
  Value::use_iterator end() { return Call->use_end(); }

  FieldAnnotation(CallInst *Call, const Value *PtrArg,
                  StringRef StructName, StringRef FieldName,
                  StringRef Filename, APInt Line)
    : PtrAnnotation(Call, PtrArg, (StructName + "." + FieldName).str(),
                    Filename, Line),
      StructName(StructName), FieldName(FieldName)
  {
  }

private:
  const StringRef StructName;
  const StringRef FieldName;
};


bool FieldReferenceInstrumenter::runOnModule(Module &Mod) {
  this->Mod = &Mod;

  //
  // First, find all struct fields that we want to instrument.
  //
  std::multimap<string,const FieldAssignTransition*,less_ignoring_null<string> >
    ToInstrument;

  for (auto *Root : M.RootAutomata()) {
    for (auto Transitions : *M.FindAutomaton(Root->identifier())) {
      const Transition *Head = *Transitions.begin();
      if (auto FieldAssign = dyn_cast<FieldAssignTransition>(Head)) {
        auto& Protobuf = FieldAssign->Assignment();
        auto StructName = Protobuf.type();
        auto FieldName = Protobuf.fieldname();

        string Key = StructName + "." + FieldName;
        ToInstrument.insert(std::make_pair(Key, FieldAssign));
      }
    }
  }

  //
  // Then, iterate through all uses of the LLVM pointer annotation and look
  // for structure accesses.
  //
  std::map<LoadInst*,std::pair<StringRef,StringRef> > Loads;
  std::map<StoreInst*,std::pair<StringRef,StringRef> > Stores;

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

      auto j = ToInstrument.find(Annotation->completeFieldName());
      if (j == ToInstrument.end())
        continue;

      auto FieldName = std::make_pair(Annotation->getStructName(),
                                      Annotation->getFieldName());

      for (User *U : *Annotation) {
        auto *Cast = dyn_cast<CastInst>(U);
        if (!Cast) {
          U->dump();
          report_fatal_error("TESLA: annotation user not a bitcast", false);
        }

        for (auto k = Cast->use_begin(); k != Cast->use_end(); k++) {
          if (auto *Load = dyn_cast<LoadInst>(*k))
            Loads.insert(std::make_pair(Load, FieldName));

          else if (auto *Store = dyn_cast<StoreInst>(*k))
            Stores.insert(std::make_pair(Store, FieldName));

          else {
            k->dump();
            report_fatal_error(
              "TESLA: expected load or store with annotated value", false);
          }
        }
      }
    }
  }

  for (auto i : Loads)
    InstrumentLoad(i.first, i.second.first, i.second.second);

  for (auto i : Stores)
    InstrumentStore(i.first, i.second.first, i.second.second);

  return true;
}


bool FieldReferenceInstrumenter::InstrumentLoad(
    LoadInst *Load, StringRef StructType, StringRef FieldName) {

  //
  // We don't actually instrument loads yet: we can't describe such references
  // in the C-based automaton description language.
  //

  return true;
}


bool FieldReferenceInstrumenter::InstrumentStore(
    StoreInst *Store, StringRef StructType, StringRef FieldName) {

  assert(Store->getNumOperands() > 1);
  Value *Val = Store->getOperand(0);
  Value *Ptr = Store->getOperand(1);

  Function *InstrFn = StructInstrumentation(
    *Mod, Val->getType(), Ptr->getType(), StructType, FieldName, true);
  assert(InstrFn);

  std::vector<Value*> Args;
  Args.push_back(Val);
  Args.push_back(Ptr);

  IRBuilder<> Builder(Store);
  Builder.CreateCall(InstrFn, Args);

  return true;
}


PtrAnnotation* PtrAnnotation::Interpret(User *U) {
  assert(U);

  auto *Call = dyn_cast<CallInst>(U);
  assert(Call);
  assert(Call->getNumArgOperands() == 4);

  Value *Ptr(Call->getArgOperand(0));
  StringRef Name(ExtractStringConstant(Call->getArgOperand(1)));
  StringRef Filename(ExtractStringConstant(Call->getArgOperand(2)));
  APInt Line = dyn_cast<ConstantInt>(Call->getArgOperand(3))->getValue();

  const string FIELD = "field:";

  if (!Name.startswith(FIELD))
    return new PtrAnnotation(Call, Ptr, Name, Filename, Line);

  size_t Dot(Name.find('.'));
  StringRef StructName(Name.slice(FIELD.length(), Dot));
  StringRef FieldName(Name.substr(Dot + 1));

  return new FieldAnnotation(Call, Ptr, StructName, FieldName, Filename, Line);
}

StringRef PtrAnnotation::ExtractStringConstant(const Value *V) {
  auto *Ptr = dyn_cast<ConstantExpr>(V);
  assert(Ptr && Ptr->isGEPWithNoNotionalOverIndexing());

  auto *Var = dyn_cast<GlobalVariable>(Ptr->getOperand(0));
  auto *Array = dyn_cast<ConstantDataArray>(Var->getInitializer());

  return Array->getAsString();
}

}
