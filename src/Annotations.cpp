/*! @file Annotations.h   Declarations of LLVM annotation parsers. */
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

#include <llvm/ADT/APInt.h>
#include <llvm/IR/GlobalVariable.h>

using namespace llvm;
using std::string;

namespace tesla {

#if 0
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


string tesla::FieldAnnotation::completeFieldName() const {
  string Complete = (StructName + "." + FieldName).str();

  // Remove trailing NULL character.
  Complete.resize(strnlen(Complete.c_str(), Complete.length()));

  return Complete;
}
#endif

}
