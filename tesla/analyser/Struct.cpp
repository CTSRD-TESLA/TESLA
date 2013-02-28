/*! @file Struct.cpp  Parsers for struct-related TESLA events, expressions. */
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

#include "Parsers.h"

#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/StringSwitch.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/Basic/Diagnostic.h"

using namespace clang;
using std::vector;

namespace tesla {

bool ParseFieldAssign(Event *Ev, const BinaryOperator *O,
                      vector<const ValueDecl*>& References, ASTContext& Ctx) {

  Ev->set_type(Event::FIELD_ASSIGN);
  FieldAssignment *Assign = Ev->mutable_fieldassign();

  switch (O->getOpcode()) {
  default:
    Report("unhandled compound assignment type", O->getOperatorLoc(), Ctx)
      << O->getSourceRange();
    return false;

  case BO_Assign:
    Assign->set_operation(FieldAssignment::SimpleAssign);
    break;

  case BO_AddAssign:
    Assign->set_operation(FieldAssignment::PlusEqual);
    break;

  case BO_SubAssign:
    Assign->set_operation(FieldAssignment::MinusEqual);
    break;
  }

  auto *LHS = dyn_cast<MemberExpr>(O->getLHS());
  if (!LHS) {
    Report("LHS of assignment should be a struct member", O->getLocStart(), Ctx)
      << O->getLHS()->getSourceRange();
    return false;
  }

  auto *DRE = dyn_cast<DeclRefExpr>(LHS->getBase()->IgnoreImpCasts());
  auto *BasePtrType = dyn_cast<PointerType>(DRE->getDecl()->getType());
  auto *BaseType = BasePtrType->getPointeeType()->getAsStructureType();
  if (!BaseType) {
    Report("base of assignment LHS not a struct type", DRE->getLocStart(), Ctx)
      << DRE->getSourceRange();
    return false;
  }

  Assign->set_type(BaseType->getDecl()->getName());

  auto *Member = dyn_cast<FieldDecl>(LHS->getMemberDecl());
  if (!Member) {
    Report("struct member is not a FieldDecl", LHS->getMemberLoc(), Ctx)
      << LHS->getSourceRange();
    return false;
  }

  Assign->set_index(Member->getFieldIndex());
  Assign->set_name(Member->getName());

  return ParseArgument(Assign->mutable_value(), O->getRHS(), References, Ctx);
}

}

