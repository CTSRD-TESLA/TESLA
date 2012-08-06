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

#include "llvm/ADT/APFloat.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"

using namespace clang;
using namespace llvm;

using std::set;
using std::string;
using std::vector;

namespace tesla {

// Some STL helpers.
template<class T>
set<T>& operator += (set<T>& lhs, const set<T>& rhs) {
  lhs.insert(rhs.begin(), rhs.end());
  return lhs;
}

template<class T>
set<T> operator + (const set<T>& lhs, const set<T>& rhs) {
  set<T> total;
  total += lhs;
  total += rhs;
  return total;
}


set<FunctionDecl*> Desc::FunctionsToInstrument() {
  return set<FunctionDecl*>();
}

Reference::Reference(NamedDecl *D) : Decl(D), Literal(NULL) {}
Reference::Reference(Expr *E) : Decl(NULL), Literal(E) {}

string Reference::Description() const {
  if (Decl) return Decl->getName();

  if (auto Char = dyn_cast<CharacterLiteral>(Literal)) {
    string type;
    switch (Char->getKind()) {
      case CharacterLiteral::Ascii:  type = "Ascii"; break;
      case CharacterLiteral::Wide:   type = "wide";  break;
      case CharacterLiteral::UTF16:  type = "UTF16"; break;
      case CharacterLiteral::UTF32:  type = "UTF32"; break;
    }

    return "char(" + type
      + APInt(sizeof(unsigned), Char->getValue()).toString(10, false)
      + ")";

  }

  if (auto Float = dyn_cast<FloatingLiteral>(Literal)) {
    SmallString<10> Str;
    Float->getValue().toString(Str);
    return Str.str();
  }

  if (auto Int = dyn_cast<IntegerLiteral>(Literal))
    return Int->getValue().toString(10, true);    // TODO: is signed????

  if (auto String = dyn_cast<StringLiteral>(Literal))
    return String->getString();

  if (auto Bool = dyn_cast<CXXBoolLiteralExpr>(Literal))
    return Bool->getValue() ? "true" : "false";

  if (isa<CXXNullPtrLiteralExpr>(Literal))
    return "NULL";

  assert(false);   // unhandled ICE!?
}

bool Reference::operator < (const Reference& other) const {
  return get() < other.get();
}

const void* Reference::get() const {
  if (Decl) return Decl;
  else return Literal;
}


const AutomatonContext PerThreadContext("per-thread");
const AutomatonContext GlobalContext("global");
const AutomatonContext InvalidContext("invalid!");

AutomatonContext::AutomatonContext(StringRef Name)
  : Descrip(("Context(" + Name + ")").str()) {}

const AutomatonContext*
AutomatonContext::Parse(Expr *E, ASTContext& Ctx) {
  auto DRE = dyn_cast<DeclRefExpr>(E->IgnoreImplicit());
  if (!DRE) {
    Report("Invalid locality specifier (must be per-thread or global)",
        E->getExprLoc(), Ctx)
      << E->getSourceRange();
    return &InvalidContext;
  }

  return StringSwitch<const AutomatonContext*>(DRE->getDecl()->getName())
    .Case("__tesla_global", &GlobalContext)
    .Case("__tesla_perthread", &PerThreadContext)
    .Default(&InvalidContext);
}


Location::Location(StringRef Filename, APInt Line, APInt Counter)
  : Filename(Filename), Line(Line), Counter(Counter),
    Descrip(
      (Filename
        + ":" + Line.toString(10, false)
        + "#" + Counter.toString(10, false)).str()
    )
{}



TeslaEvent* TeslaEvent::Parse(Expr *E, Location AssertionLocation,
    ASTContext& Ctx) {
  E = E->IgnoreImplicit();

  // Is this a "now" event?
  if (auto Ref = dyn_cast<DeclRefExpr>(E)) {
    auto D = Ref->getDecl();
    if (!D) {
      Report("Reference to nothing", Ref->getLocStart(), Ctx)
        << Ref->getSourceRange();

      return NULL;
    }

    if (D->getName() == "__tesla_now") return new Now(AssertionLocation);
  }

  // Is it a call-and-return like "foo(x) == y"?
  if (auto Bop = dyn_cast<BinaryOperator>(E))
    return FunctionCall::Parse(Bop, Ctx);

  // Otherwise, we expect a call to a TESLA "function" like __tesla_predicate().
  auto Call = dyn_cast<CallExpr>(E);
  if (!Call) {
    Report("Event should look like a function call", E->getLocStart(), Ctx)
      << E->getSourceRange();
    return NULL;
  }

  auto Callee = Call->getDirectCallee();
  if (!Callee) {
    Report("TESLA event referenced indirectly", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return NULL;
  }

  // We can't use StringSwitch for this because it evaluates all of the
  // possible cases (e.g. FunctionCall::Parse(x,y)) before switching.
  if (Callee->getName() == "__tesla_repeat")
    return Repetition::Parse(Call, AssertionLocation, Ctx);

  if (Callee->getName() == "__tesla_entered")
    return new FunctionEntry(Callee);

  if (Callee->getName() == "__tesla_leaving")
    return new FunctionExit(Callee);

  if (Callee->getName() == "__tesla_call")
    return FunctionCall::Parse(Call, Ctx);

  Report("Unknown TESLA event", E->getLocStart(), Ctx) << E->getSourceRange();
  return NULL;
}




Repetition::Repetition(OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
    APInt Min)
  : Len(Len), Min(Min), HasMax(false)
{
  Init(Events);
}

Repetition::Repetition(OwningArrayPtr<TeslaEvent*>& Events, unsigned Len,
    APInt Min, APInt Max)
  : Len(Len), Min(Min), HasMax(true), Max(Max)
{
  Init(Events);
}

void Repetition::Init(OwningArrayPtr<TeslaEvent*>& Events) {
  SmallString<8> Range;
  string MinStr = Min.toString(10, false);
  string MaxStr = Max.toString(10, false);

  if (HasMin) Range = "[" + MinStr + "," + (HasMax ? (MaxStr + "]") : ")");
  else Range = "(" + (HasMax ? ("," + MaxStr + "]") : "ANY)");

  Descrip = ("repeat(" + Range + ": ").str();
  for (unsigned I = 0; I < Len; I++) {
    assert(Events[I] != NULL);
    Descrip += (Events[I]->Description() + " ").str();
  }
  Descrip += ")";

  this->Events.reset(Events.take());
}

void Repetition::References(set<Reference>& References) const {
  for (size_t I = 0; I < Len; I++) Events[I]->References(References);
}

Repetition* Repetition::Parse(CallExpr *Call, Location AssertLoc,
    ASTContext& Ctx) {

  unsigned Args = Call->getNumArgs();
  if (Args < 3) {
    Report("Repetition must have at least three arguments (min, max, events)",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return NULL;
  }

  APInt Min = ParseIntegerLiteral(Call->getArg(0), Ctx);
  APInt Max = ParseIntegerLiteral(Call->getArg(1), Ctx);

  unsigned EventCount = Args - 2;
  OwningArrayPtr<TeslaEvent*> Events(new TeslaEvent*[EventCount]);
  for (unsigned I = 0; I < EventCount; I++) {
    auto Event = Call->getArg(I + 2);
    TeslaEvent *ToRepeat = TeslaEvent::Parse(Event, AssertLoc, Ctx);
    Events[I] = ToRepeat;

    if (!ToRepeat) {
      Report("Failed to parse repeated event", Event->getLocStart(), Ctx)
        << Event->getSourceRange();
      return NULL;
    }
  }

  if (Max.isNegative()) return new Repetition(Events, EventCount, Min);
  else return new Repetition(Events, EventCount, Min, Max);
}


Now::Now(Location Loc)
  : ID(Loc), Descrip(("AssertionPoint(" + Loc.Description() + ")").str()) {}


set<FunctionDecl*> FunctionEvent::FunctionsToInstrument() {
  set<FunctionDecl*> Fns;
  if (Function) Fns.insert(Function);
  return Fns;
}


FunctionCall::FunctionCall(
    FunctionDecl *Fn, vector<Reference>& Params, Reference& RetVal)
  : FunctionEvent(Fn), Params(Params), RetVal(RetVal)
{
  SmallString<50> D;
  D += "call(";
  D += Fn->getName();
  D += ")";

  Descrip = D.str();
}

void FunctionCall::References(set<Reference>& References) const {
  for (auto E : Params) References.insert(E);
  References.insert(RetVal);
}

FunctionCall* FunctionCall::Parse(CallExpr *Call, ASTContext& Ctx) {
  auto Event = Call->getDirectCallee();

  // Preconditions
  assert(Event != NULL);
  assert(Event->getName() == "__tesla_call");

  if (Call->getNumArgs() != 1) {
    Report("TESLA predicate should have one (boolean) argument",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return NULL;
  }

  auto Bop = dyn_cast<BinaryOperator>(Call->getArg(0)->IgnoreImplicit());
  if (!Bop || (Bop->getOpcode() != BO_EQ)) {
    Report("A TESLA predicate should be of the form foo(x) == y",
        Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return NULL;
  }

  return Parse(Bop, Ctx);
}

FunctionCall* FunctionCall::Parse(BinaryOperator *Bop, ASTContext& Ctx) {
  Expr *LHS = Bop->getLHS();
  bool LHSisICE = LHS->isIntegerConstantExpr(Ctx);

  Expr *RHS = Bop->getRHS();

  if (!(LHSisICE ^ RHS->isIntegerConstantExpr(Ctx))) {
    Report("One of {LHS,RHS} must be ICE", Bop->getLocStart(), Ctx)
      << Bop->getSourceRange();
    return NULL;
  }

  Reference RetVal(LHSisICE ? LHS : RHS);
  Expr *FnCall = LHSisICE ? RHS : LHS;

  auto FnCallExpr = dyn_cast<CallExpr>(FnCall);
  if (!FnCallExpr) {
    Report("Not a function call", FnCall->getLocStart(), Ctx)
      << FnCall->getSourceRange();
    return NULL;
  }

  auto Fn = FnCallExpr->getDirectCallee();
  if (!Fn) {
    Report("Not a direct function call", FnCallExpr->getLocStart(), Ctx)
      << FnCallExpr->getSourceRange();
    return NULL;
  }

  vector<Reference> Params;
  for (auto I = FnCallExpr->arg_begin(); I != FnCallExpr->arg_end(); ++I) {
    auto P = I->IgnoreImplicit();

    // Each parameter must be one of:
    //  - a call to a TESLA pseudo-function,
    //  - a reference to a named declaration or
    //  - an integer constant expression.
    if (auto Call = dyn_cast<CallExpr>(P)) {
      auto Fn = Call->getDirectCallee();
      if (!Fn) {
        Report("Should only call TESLA pseudo-functions here",
            P->getLocStart(), Ctx) << P->getSourceRange();
        return NULL;
      }

      Params.push_back(Fn);
    } else if (auto DRE = dyn_cast<DeclRefExpr>(P)) {
      Params.push_back(DRE->getDecl());
    } else if (P->isIntegerConstantExpr(Ctx)) {
      Params.push_back(P);
    } else {
      P->dump();

      Report("Invalid argument to function within TESLA assertion",
          P->getLocStart(), Ctx) << P->getSourceRange();
      return NULL;
    }
  }

  return new FunctionCall(Fn, Params, RetVal);
}



FunctionEntry::FunctionEntry(clang::FunctionDecl *Function)
  : FunctionEvent(Function),
    Descrip(("entered(" + Function->getName() + ")").str()) {}


FunctionExit::FunctionExit(clang::FunctionDecl *Function)
  : FunctionEvent(Function),
    Descrip(("exited(" + Function->getName() + ")").str()) {}


BooleanExpr::BooleanExpr(BooleanOp Operation, TeslaExpr *LHS, TeslaExpr *RHS)
  : Op(Operation), LHS(LHS), RHS(RHS)
{
  StringRef L = (LHS ? LHS->Description() : "<null>");
  StringRef R = (RHS ? RHS->Description() : "<null>");

  StringRef O;
  switch (Op) {
    case BOp_And: O = "and";  break;
    case BOp_Or:  O = "or";   break;
    case BOp_Xor: O = "xor";  break;
  }

  Descrip = ("(" + L + " " + O + " " + R + ")").str();
}

set<FunctionDecl*> BooleanExpr::FunctionsToInstrument() {
  return LHS->FunctionsToInstrument() + RHS->FunctionsToInstrument();
  set<FunctionDecl*> Fns;
  Fns += LHS->FunctionsToInstrument();
  Fns += RHS->FunctionsToInstrument();

  return Fns;
}

void BooleanExpr::References(set<Reference>& References) const {
  LHS->References(References);
  RHS->References(References);
}

BooleanExpr* BooleanExpr::Parse(BinaryOperator *Bop, Location AssertionLocation,
    ASTContext& Ctx) {
  BooleanOp Op;
  switch (Bop->getOpcode()) {
    case BO_LAnd: Op = BOp_And; break;
    case BO_LOr:  Op = BOp_Or;  break;
    // TODO: think about whether or not we want to support XOR
//  case BO_Xor:  Op = BOp_Xor; break;
    default:
      Report("Invalid boolean operation on TESLA expressions",
          Bop->getOperatorLoc(), Ctx)
        << Bop->getSourceRange();
      return NULL;
  }

  TeslaExpr *LHS = TeslaExpr::Parse(Bop->getLHS(), AssertionLocation, Ctx);
  TeslaExpr *RHS = TeslaExpr::Parse(Bop->getRHS(), AssertionLocation, Ctx);

  return new BooleanExpr(Op, LHS, RHS);
}



TeslaAssertion::TeslaAssertion(
    Location Loc, const AutomatonContext *Context, TeslaExpr *Expr)
  : Loc(Loc), Context(Context), Expression(Expr)
{
}

set<FunctionDecl*> TeslaAssertion::FunctionsToInstrument() {
  return Expression->FunctionsToInstrument();
}

void TeslaAssertion::References(set<Reference>& References) const {
  Expression->References(References);
}

set<Reference> TeslaAssertion::References() const {
  set<Reference> Refs;
  References(Refs);
  return Refs;
}

StringRef TeslaAssertion::Description() const {
  StringRef C = (Context ? Context->Description() : "<null>");
  StringRef E = (Expression ? Expression->Description() : "<null>");

  return (Twine() + "InlineAssertion { '" + Loc.Description()
      + "', " + C + ": " + E + " }"
    ).str();
}


TeslaAssertion* TeslaAssertion::Parse(CallExpr *E, ASTContext& Ctx) {
    FunctionDecl *F = E->getDirectCallee();
    if (!F) return NULL;
    if (!F->getName().startswith("__tesla_inline_assertion")) return NULL;

    if (E->getNumArgs() != 5) {
      Report("Wrong number of arguments to TESLA inline assertion",
          E->getLocStart(), Ctx)
        << E->getSourceRange();
      return NULL;
    }

    StringRef Filename = ParseStringLiteral(E->getArg(0), Ctx);
    APInt Line = ParseIntegerLiteral(E->getArg(1), Ctx);
    APInt Counter = ParseIntegerLiteral(E->getArg(2), Ctx);
    Location Loc(Filename, Line, Counter);

    const AutomatonContext* Context =
      AutomatonContext::Parse(E->getArg(3), Ctx);

    TeslaExpr *Expression = TeslaExpr::Parse(E->getArg(4), Loc, Ctx);

    return new TeslaAssertion(Loc, Context, Expression);
}


TeslaExpr* TeslaExpr::Parse(Expr *E, Location AssertionLocation,
    ASTContext& Ctx) {
  E = E->IgnoreImplicit();

  if (auto Call = dyn_cast<CallExpr>(E))
    return Sequence::Parse(Call, AssertionLocation, Ctx);

  else if (auto Bop = dyn_cast<BinaryOperator>(E))
    return BooleanExpr::Parse(Bop, AssertionLocation, Ctx);

  return NULL;
}



Sequence::Sequence(MutableArrayRef<OwningPtr<TeslaEvent> > Events) {
  Descrip = "Seq[";
  for (auto& E : Events) {
    Descrip += E->Description();
    Descrip += " ";
  }
  Descrip += "]";

  // Only take these references *after* building the description string!
  for (auto& E : Events) this->Events.push_back(E.take());
}

set<FunctionDecl*> Sequence::FunctionsToInstrument() {
  set<FunctionDecl*> Fns;
  for (auto E : Events) Fns += E->FunctionsToInstrument();

  return Fns;
}

void Sequence::References(set<Reference>& References) const {
  for (auto E : Events) E->References(References);
}

Sequence* Sequence::Parse(CallExpr *Call, Location AssertionLocation,
    ASTContext& Ctx) {

  // Base case of the recursion: we have reached a sequence that specifies
  // an ordered list of events.
  FunctionDecl *Fun = Call->getDirectCallee();
  if (!Fun) {
    Report("Expected direct call to TESLA sequence", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return NULL;
  }

  if (Fun->getName().compare("__tesla_sequence") != 0) {
    Report("Expected call to TESLA sequence", Call->getLocStart(), Ctx)
      << Call->getSourceRange();
    return NULL;
  }


  // Construct an owned-and-will-be-properly-deleted array of
  // similarly-owned pointers to parsed TeslaEvents (sequence arguments).
  unsigned Args = Call->getNumArgs();
  OwningArrayPtr<OwningPtr<TeslaEvent> >
    Events(new OwningPtr<TeslaEvent>[Args]);

  for (unsigned i = 0; i < Args; i++) {
    Expr *Arg = Call->getArg(i);

    Events[i].reset(TeslaEvent::Parse(Arg, AssertionLocation, Ctx));
    if (!Events[i]) {
      Report("Failed to parse TESLA event", Arg->getLocStart(), Ctx)
        << Arg->getSourceRange();
      return NULL;
    }
  }

  MutableArrayRef<OwningPtr<TeslaEvent> > EventsRef(Events.get(), Args);
  return new Sequence(EventsRef);
}


// Helper functions.
DiagnosticBuilder tesla::Report(StringRef Message, SourceLocation Loc,
    ASTContext& Ctx, DiagnosticsEngine::Level Level) {

  DiagnosticsEngine& Diag = Ctx.getDiagnostics();
  int DiagID = Diag.getCustomDiagID(Level, Message);
  return Diag.Report(Loc, DiagID);
}

StringRef tesla::ParseStringLiteral(Expr* E, ASTContext& Ctx) {
  auto Literal = dyn_cast<StringLiteral>(E->IgnoreImplicit());
  if (!Literal) {
    Report("Not a valid TESLA string literal", E->getExprLoc(), Ctx);
    return "";
  }

  return Literal->getString();
}

APInt tesla::ParseIntegerLiteral(Expr* E, ASTContext& Ctx) {
  auto Literal = dyn_cast<IntegerLiteral>(E->IgnoreImplicit());
  if (!Literal) {
    Report("Not a valid TESLA integer literal", E->getExprLoc(), Ctx);
    return APInt();
  }

  return Literal->getValue();
}

}

