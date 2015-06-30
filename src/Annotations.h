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

#ifndef TESLA_ANNOTATIONS_H
#define TESLA_ANNOTATIONS_H

#include <llvm/ADT/StringRef.h>
#include <llvm/IR/Instructions.h>

#include <string>

namespace llvm {
  class APInt;
  class User;
  class Value;
}

namespace tesla {

/** An annotation applied by LLVM to a pointer. */
class PtrAnnotation {
public:
  virtual ~PtrAnnotation() {}

  enum AnnotationKind { AK_RawAnnotation, AK_FieldAnnotation };
  virtual AnnotationKind getKind() const { return AK_RawAnnotation; }
  static bool classof(const PtrAnnotation *P) { return true; }

  static PtrAnnotation* Interpret(llvm::User*);
  llvm::StringRef getName() const { return Name; }
  const llvm::Value* getValue() const { return Call; }

protected:
  PtrAnnotation(llvm::CallInst *Call, const llvm::Value *PtrArg,
                llvm::StringRef Name, llvm::StringRef Filename,
                llvm::APInt& Line)
    : Call(Call), PtrArg(PtrArg), Name(Name), Filename(Filename), Line(Line)
  {
  }

  static llvm::StringRef ExtractStringConstant(const llvm::Value *V);

  llvm::CallInst *Call;
  const llvm::Value *PtrArg;
  const llvm::StringRef Name;
  const llvm::StringRef Filename;
  const llvm::APInt& Line;
};


/** An annotation applied by Clang/TESLA to a structure field access. */
class FieldAnnotation : public PtrAnnotation {
public:
  virtual AnnotationKind getKind() const { return AK_FieldAnnotation; }
  static bool classof(const PtrAnnotation *P) {
    return (P->getKind() == AK_FieldAnnotation);
  }

  llvm::StringRef getStructName() const { return StructName; }
  llvm::StringRef getFieldName() const { return FieldName; }
  std::string completeFieldName() const;

  llvm::Value::use_iterator begin() { return Call->use_begin(); }
  llvm::Value::use_iterator end() { return Call->use_end(); }

  FieldAnnotation(llvm::CallInst *Call, const llvm::Value *PtrArg,
                  llvm::StringRef StructName, llvm::StringRef FieldName,
                  llvm::StringRef Filename, llvm::APInt& Line)
    : PtrAnnotation(Call, PtrArg, (StructName + "." + FieldName).str(),
                    Filename, Line),
      StructName(StructName), FieldName(FieldName)
  {
  }

private:
  const llvm::StringRef StructName;
  const llvm::StringRef FieldName;
};

}

#endif  // !TESLA_ANNOTATIONS_H
