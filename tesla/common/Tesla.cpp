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

#include "Tesla.h"

#include <memory>
#include <sstream>

#include "llvm/ADT/Twine.h"

using namespace llvm;

using std::ostringstream;
using std::set;
using std::string;
using std::vector;

namespace tesla {

// ==== TeslaExpr implementation ===============================================
yaml::Node* TeslaExpr::Yaml() const {
  auto Map = new yaml::Map;
  auto& M = *Map;

  M.set("expr", yaml::Value::of(ExprType));

  auto *Sub = SubExpressions();
  if (Sub) M.set("subexprs", Sub);

  return Map;
}



// ==== BooleanExpr implementation =============================================
BooleanExpr::BooleanExpr(BooleanOp Operation, TeslaExpr *LHS, TeslaExpr *RHS)
  : TeslaExpr("bool"), Op(Operation), LHS(LHS), RHS(RHS)
{
  assert(LHS);
  assert(RHS);
}

yaml::Sequence* BooleanExpr::SubExpressions() const {
  auto S = new yaml::Sequence();
  auto &Seq = *S;

  switch (Op) {
    case BOp_And: Seq << "and";  break;
    case BOp_Or:  Seq << "or";   break;
    case BOp_Xor: Seq << "xor";  break;
    default:
      assert(false && "Unhandled boolean op");
  }

  Seq << LHS->Yaml() << RHS->Yaml();

  return S;
}



// ==== TeslaAssertion implementation ==========================================
TeslaAssertion::TeslaAssertion(
    Location Loc, const AutomatonContext *Context, TeslaExpr *Expr)
  : Loc(Loc), Context(Context), Expression(Expr)
{
  assert(Context);
  assert(Expression);
}

yaml::Node* TeslaAssertion::Yaml() const {
  auto Map = new yaml::Map();
  auto& M = *Map;

  M.set("location", Loc.Yaml());
  M.set("context", Context->Yaml());
  M.set("expression", Expression->Yaml());

  return Map;
}



// ==== Sequence implementation ================================================
Sequence::Sequence(MutableArrayRef<OwningPtr<TeslaEvent> > Events)
  : TeslaExpr("seq")
{
  for (auto& E : Events) this->Events.push_back(E.take());
}

Sequence::~Sequence() {
  for (auto& E : Events) delete E;
}

yaml::Sequence* Sequence::SubExpressions() const {
  auto Seq = new yaml::Sequence();
  auto& S = *Seq;

  for (auto& E : Events) S << E->Yaml();

  return Seq;
}

}

