/*! @file Parser.cppDefinition of @ref Parser. */
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
 *  notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include "Names.h"
#include "Parser.h"

#include <clang/AST/ASTContext.h>
#include <clang/AST/Expr.h>
#include <clang/AST/ExprCXX.h>
#include <clang/Basic/Diagnostic.h>
#include <clang/Lex/Lexer.h>

#include <llvm/ADT/StringSwitch.h>

#include <tesla.pb.h>

using namespace clang;
using namespace tesla;


Parser* Parser::AssertionParser(CallExpr *Call, ASTContext& Ctx) {
  assert(Call->getDirectCallee()->getName().compare(INLINE_ASSERTION) == 0);

  OwningPtr<Parser> Bootstrap(new Parser(Ctx));

  if (Call->getNumArgs() != 5) {
    Bootstrap->ReportError(
      "expected five arguments: filename, line, counter, context, expression",
      Call);
    return NULL;
  }

  Expr *Filename    = Call->getArg(0);
  Expr *Line        = Call->getArg(1);
  Expr *Counter     = Call->getArg(2);
  Expr *Context     = Call->getArg(3);
  Expr *Expression  = Call->getArg(4);

  Identifier ID;
  if (!Bootstrap->Parse(ID.mutable_location(), Filename, Line, Counter))
    return NULL;

  AutomatonDescription::Context TeslaContext;
  if (!Bootstrap->Parse(&TeslaContext, Context))
    return NULL;

  return new Parser(Ctx, ID, TeslaContext, Expression);
}


Parser* Parser::AutomatonParser(FunctionDecl *F, ASTContext& Ctx) {
  assert(F != NULL);
  assert(F->doesThisDeclarationHaveABody());

  Identifier ID;
  ID.set_name(F->getName());

  OwningPtr<Parser> Bootstrap(new Parser(Ctx));

  // We should reference one variable: the struct pointer.
  if (F->getNumParams() != 1) {
    Bootstrap->ReportError("expected one parameter: the struct", F);
    return NULL;
  }

  // TODO: programmer-specified context
  AutomatonDescription::Context Context = AutomatonDescription::Global;

  ValueDecl *StructRef = F->getParamDecl(0);

  const PointerType *StructPtrTy = dyn_cast<PointerType>(StructRef->getType());
  if (!StructPtrTy || !StructPtrTy->getPointeeType()->getAsStructureType()) {
    Bootstrap->ReportError("expected pointer to struct", StructRef);
    return NULL;
  }

  return new Parser(Ctx, ID, Context, F->getBody());
}


bool Parser::Parse(Expression *E, const CompoundStmt *C) {
  assert(E != NULL);
  assert(C != NULL);

  // A list of statements should be treated like a sequence.
  E->set_type(Expression::SEQUENCE);
  Sequence *Seq = E->mutable_sequence();

  for (auto i = C->body_begin(); i != C->body_end(); i++) {
    const Stmt *S = *i;

    if (auto *R = dyn_cast<ReturnStmt>(S)) {
      // This must be a 'done' statement.
      const Expr *RetVal = R->getRetValue();
      if (RetVal == NULL) {
        ReportError("automaton description returns nothing", R);
        return false;
      }

      auto *DoneCall = dyn_cast<CallExpr>(RetVal->IgnoreParenCasts());
      if (DoneCall == NULL) {
        ReportError("expected __tesla_automaton_done", RetVal);
        return false;
      }

    } else if (auto *E = dyn_cast<Expr>(S)) {
      // Otherwise, it's just a regular TESLA expression.
      if (!Parse(Seq->add_expression(), E))
        return false;

    } else {
      ReportError("unhandled C statement type", S);
      return false;
    }
  }

  return true;
}


bool Parser::Parse(Location *Loc, Expr *Filename, Expr *Line, Expr *Count) {
  *Loc->mutable_filename() = ParseStringLiteral(Filename);

  auto LineNumber = ParseIntegerLiteral(Line);
  if (LineNumber.getBitWidth() == 0) {
    ReportError("invalid line number", Line);
    return false;
  }
  Loc->set_line(LineNumber.getLimitedValue());

  auto Counter = ParseIntegerLiteral(Count);
  if (Counter.getBitWidth() == 0) {
    ReportError("invalid counter value", Count);
    return false;
  }
  Loc->set_counter(Counter.getLimitedValue());

  return true;
}


bool Parser::Parse(AutomatonDescription::Context *Context, Expr *E) {
  auto DRE = dyn_cast<DeclRefExpr>(E->IgnoreImplicit());
  if (!DRE) {
    ReportError("invalid locality specifier (must be per-thread or global)", E);
    return false;
  }

  StringRef Name = DRE->getDecl()->getName();

  if (Name == GLOBAL) *Context = AutomatonDescription::Global;
  else if (Name == PERTHREAD) *Context = AutomatonDescription::ThreadLocal;
  else {
    ReportError("invalid locality specifier (must be per-thread or global)", E);
    return false;
  }

  return true;
}


AutomatonDescription* Parser::Parse() {
  OwningPtr<AutomatonDescription> A(new AutomatonDescription);

  *A->mutable_identifier() = ID;
  A->set_context(TeslaContext);

  // Parse the root: a compound statement or an expression.
  bool Success = false;
  if (auto *C = dyn_cast<CompoundStmt>(Root))
    Success = Parse(A->mutable_expression(), C);

  else if (auto *E = dyn_cast<Expr>(Root))
    Success = Parse(A->mutable_expression(), E);

  else
    ReportError("expected expression or compound statement", Root);

  if (!Success)
    return NULL;

  // Keep track of the variables we referenced.
  for (const ValueDecl *D : References)
    if (!Parse(A->add_argument(), D, false))
      return NULL;

  return A.take();
}


bool Parser::Parse(Expression *Ex, const Expr *E) {
  E = E->IgnoreImplicit();

  if (auto Assign = dyn_cast<CompoundAssignOperator>(E))
    return ParseFieldAssign(Ex, Assign);

  if (auto Bop = dyn_cast<BinaryOperator>(E))
    return Parse(Ex, Bop);

  if (auto Call = dyn_cast<CallExpr>(E))
    return Parse(Ex, Call);

  if (auto DRE = dyn_cast<DeclRefExpr>(E))
    return Parse(Ex, DRE);

  ReportError("unsupported TESLA expression", E);
  return false;
}


bool Parser::Parse(Expression *E, const BinaryOperator *Bop) {

  BooleanExpr::Operation Op;

  switch (Bop->getOpcode()) {
    default:
      ReportError("unsupported boolean operation", Bop);
      return false;

    case BO_Assign:   return ParseFieldAssign(E, Bop);  // e.g. 'x->foo = bar'
    case BO_EQ:       return ParseFunctionCall(E, Bop); // e.g. 'foo(x) == y'

    case BO_LAnd:     Op = BooleanExpr::BE_And;   break;
    case BO_LOr:      Op = BooleanExpr::BE_Or;    break;
    case BO_Xor:      Op = BooleanExpr::BE_Xor;   break;
  }

  E->set_type(Expression::BOOLEAN_EXPR);

  auto *BE = E->mutable_booleanexpr();
  BE->set_operation(Op);

  return Parse(BE->add_expression(), Bop->getLHS())
      && Parse(BE->add_expression(), Bop->getRHS());
}


bool Parser::Parse(Expression *E, const CallExpr *Call) {

  const FunctionDecl *Fun = Call->getDirectCallee();
  if (!Fun) {
    ReportError("expected direct call to predicate or sub-automaton", Call);
    return false;
  }

  const Type *RetTy = Fun->getResultType().getTypePtr();
  auto *PtrTy = dyn_cast<PointerType>(RetTy);
  if (!PtrTy) {
     ReportError("expected predicate or sub-automaton", Call);
     return false;
  }

  auto *StructTy = PtrTy->getPointeeType()->getAsStructureType();
  if (!StructTy) {
     ReportError("expected pointer-to-struct return type", Call);
     return false;
  }

  RecordDecl *Struct = StructTy->getDecl();

  auto Parse = llvm::StringSwitch<CallParser>(Struct->getName())
     .Case("__tesla_automaton_description", &Parser::ParseSubAutomaton)
     .Case("__tesla_event", &Parser::ParsePredicate)
     .Default(NULL);

  if (Parse == NULL) {
     ReportError("unsupported function call", Call);
     return false;
  }

  return (this->*Parse)(E, Call);
}


bool Parser::Parse(Expression *E, const DeclRefExpr *Ref) {
  auto D = Ref->getDecl();
  assert(D != NULL);

  if (D->getName() == NOW) {
    E->set_type(Expression::NOW);
    *E->mutable_now()->mutable_location() = ID.location();
    return true;
  }

  else if (D->getName() == IGNORE) {
    // The __tesla_ignore "event" helps TESLA assertions look like ISO C.
    E->set_type(Expression::NULL_EXPR);
    return true;
  }

  ReportError("unsupported reference", Ref);
  return false;
}


bool Parser::ParseSequence(Expression *E, const CallExpr *Call) {

  E->set_type(Expression::SEQUENCE);
  Sequence *Seq = E->mutable_sequence();

  for (auto Arg = Call->arg_begin(); Arg != Call->arg_end(); ++Arg)
    if (!Parse(Seq->add_expression(), *Arg))
      return false;

  return true;
}


bool Parser::ParseSubAutomaton(Expression *E, const CallExpr *Call) {
  E->set_type(Expression::SUB_AUTOMATON);
  E->mutable_subautomaton()->set_name(Call->getDirectCallee()->getName());
  return true;
}


bool Parser::ParsePredicate(Expression *E, const CallExpr *Call) {
  const FunctionDecl *Fun = Call->getDirectCallee();
  assert(Fun != NULL);

  auto Parse = llvm::StringSwitch<CallParser>(Fun->getName())
    .Case("__tesla_call",     &Parser::ParseFunctionCall)
    .Case("__tesla_return",   &Parser::ParseFunctionReturn)
    .Case("__tesla_sequence", &Parser::ParseSequence)
    .Case("__tesla_optional", &Parser::ParseOptional)
    .Default(NULL);

  if (Parse == NULL) {
    ReportError("unsupported predicate", Call);
    return false;
  }

  return (this->*Parse)(E, Call);
}


bool Parser::ParseOptional(Expression *E, const CallExpr *Call) {

  // The 'optional' predicate actually takes two arguments ('ignore' and
  // a programmer-supplied argument); only talk about the user argument in
  // the error message.
  if (Call->getNumArgs() != 2) {
    ReportError("'optional' predicate takes exactly one user argument", Call);
    return false;
  }

  // Implemented as (null || optional_expression).
  E->set_type(Expression::BOOLEAN_EXPR);
  BooleanExpr *B = E->mutable_booleanexpr();
  B->set_operation(BooleanExpr::BE_Or);

  B->add_expression()->set_type(Expression::NULL_EXPR);
  return Parse(B->add_expression(), Call->getArg(1));
}


bool Parser::ParseFunctionCall(Expression *E, const BinaryOperator *Bop) {
  E->set_type(Expression::FUNCTION);
  FunctionEvent *FnEvent = E->mutable_function();

  // TODO: better distinguishing between callee and/or caller
  FnEvent->set_context(FunctionEvent::Callee);

  // Since we might care about the return value, we must instrument exiting
  // the function rather than entering it.
  FnEvent->set_direction(FunctionEvent::Exit);

  Expr *LHS = Bop->getLHS();
  bool LHSisICE = LHS->isIntegerConstantExpr(Ctx);

  Expr *RHS = Bop->getRHS();

  if (!(LHSisICE ^ RHS->isIntegerConstantExpr(Ctx))) {
    ReportError("one of {LHS,RHS} must be a constant", Bop);
    return false;
  }

  Expr *RetVal = (LHSisICE ? LHS : RHS);
  Expr *FnCall = (LHSisICE ? RHS : LHS);
  if (!Parse(FnEvent->mutable_expectedreturnvalue(), RetVal))
    return false;

  auto FnCallExpr = dyn_cast<CallExpr>(FnCall);
  if (!FnCallExpr) {
    ReportError("not a function call", FnCall);
    return false;
  }

  auto Fn = FnCallExpr->getDirectCallee();
  if (!Fn) {
    ReportError("not a direct function call", FnCallExpr);
    return false;
  }

  if (!Parse(FnEvent->mutable_function(), Fn))
    return false;

  for (auto I = FnCallExpr->arg_begin(); I != FnCallExpr->arg_end(); ++I) {
    if (!Parse(FnEvent->add_argument(), I->IgnoreImplicit()))
      return false;
  }

  return true;
}


bool Parser::ParseFunctionCall(Expression *Expression, const CallExpr *Call) {

  Expression->set_type(Expression::FUNCTION);
  FunctionEvent *FnEvent = Expression->mutable_function();

  // TODO: better distinguishing between callee and/or caller
  FnEvent->set_context(FunctionEvent::Callee);
  FnEvent->set_direction(FunctionEvent::Entry);

  return ParseFunctionPredicate(FnEvent, Call, false);
}


bool Parser::ParseFunctionReturn(Expression *Expression, const CallExpr *Call) {

  Expression->set_type(Expression::FUNCTION);
  FunctionEvent *FnEvent = Expression->mutable_function();

  // TODO: better distinguishing between callee and/or caller
  FnEvent->set_context(FunctionEvent::Callee);
  FnEvent->set_direction(FunctionEvent::Exit);

  return ParseFunctionPredicate(FnEvent, Call, true);
}


bool Parser::ParseFunctionPredicate(FunctionEvent *Event, const CallExpr *Call,
                                    bool ParseRetVal) {

  // The arguments to __tesla_call/return are the function itself and then,
  // optionally, the arguments (any of which may be __tesla_any()).
  if (Call->getNumArgs() < 1) {
    ReportError("missing function argument", Call);
    return false;
  }

  auto FnRef = dyn_cast<DeclRefExpr>(Call->getArg(0)->IgnoreImplicit());
  if (!FnRef) {
    ReportError("not a function", Call);
    return false;
  }

  auto Fn = dyn_cast<FunctionDecl>(FnRef->getDecl());
  assert(Fn != NULL);
  bool HaveRetVal = ParseRetVal && !Fn->getResultType()->isVoidType();

  // Parse the arguments to the event: either specified by the programmer in
  // the assertion or else the definition of the function.
  size_t ArgCount = Call->getNumArgs() - 1;  // first arg is the function

  if (ArgCount > 0) {
    const size_t ExpectedSize = Fn->param_size() + (HaveRetVal ? 1 : 0);

    // If an assertion specifies any arguments, it must specify all of them.
    if (ArgCount != ExpectedSize) {
      ReportError("specify all args (possibly __tesla_any()) or none", Call);
      return false;
    }

    for (size_t i = 0; i < ArgCount; i++) {
      if (!Parse(Event->add_argument(), Call->getArg(i + 1)))
        return false;
    }

    if (HaveRetVal)
      if (!Parse(Event->mutable_expectedreturnvalue(), Call->getArg(ArgCount)))
        return false;

  } else {
    // The assertion doesn't specify any arguments; include information about
    // arguments from the function definition, just for information.
    for (auto I = Fn->param_begin(); I != Fn->param_end(); ++I) {
      if (!Parse(Event->add_argument(), *I, true))
        return false;
    }

    if (HaveRetVal)
      Event->mutable_expectedreturnvalue()->set_type(Argument::Any);
  }

  return Parse(Event->mutable_function(), Fn);
}


bool Parser::ParseFieldAssign(Expression *E, const clang::BinaryOperator *O) {

  E->set_type(Expression::FIELD_ASSIGN);
  FieldAssignment *A = E->mutable_fieldassign();

  switch (O->getOpcode()) {
  default:
    ReportError("unhandled compound assignment type", O);
    return false;

  case BO_Assign:     A->set_operation(FieldAssignment::SimpleAssign);  break;
  case BO_AddAssign:  A->set_operation(FieldAssignment::PlusEqual);     break;
  case BO_SubAssign:  A->set_operation(FieldAssignment::MinusEqual);    break;
  }

  auto *LHS = dyn_cast<MemberExpr>(O->getLHS());
  if (!LHS) {
    ReportError("expected struct member", O);
    return false;
  }

  auto *Base =
    dyn_cast<DeclRefExpr>(LHS->getBase()->IgnoreImpCasts())->getDecl();

  auto *BasePtrType = dyn_cast<PointerType>(Base->getType());

  auto *BaseType = BasePtrType->getPointeeType()->getAsStructureType();
  if (!BaseType) {
    ReportError("base of assignment LHS not a struct type", Base);
    return false;
  }

  A->set_type(BaseType->getDecl()->getName());

  auto *Member = dyn_cast<FieldDecl>(LHS->getMemberDecl());
  if (!Member) {
    ReportError("struct member is not a FieldDecl", LHS);
    return false;
  }

  A->set_index(Member->getFieldIndex());
  A->set_fieldname(Member->getName());

  return Parse(A->mutable_base(), Base, false)
      && Parse(A->mutable_value(), O->getRHS());
}


bool Parser::Parse(Argument *Arg, const Expr *E) {
  assert(Arg != NULL);
  assert(E != NULL);

  auto P = E->IgnoreImplicit();
  llvm::APSInt ConstValue;

  // Each variable references must be one of:
  //  - __tesla_any(),
  //  - a reference to a named declaration or
  //  - an integer constant expression.
  if (auto Call = dyn_cast<CallExpr>(P)) {
    auto Fn = Call->getDirectCallee();
    if (!Fn) {
      ReportError("expected TESLA predicate", P);
      return false;
    }

    if (Fn->getName().slice(0, ANY.length()) != ANY) {
      ReportError("expected " + ANY + "*()", P);
      return false;
    }

    Arg->set_type(Argument::Any);

  } else if (auto DRE = dyn_cast<DeclRefExpr>(P)) {
    Arg->set_type(Argument::Variable);
    const ValueDecl *D = DRE->getDecl();

    *Arg->mutable_name() = DRE->getDecl()->getName();
    Arg->set_index(ReferenceIndex(D));

  } else if (P->isIntegerConstantExpr(ConstValue, Ctx)) {
    Arg->set_type(Argument::Constant);
    Arg->set_int_value(ConstValue.getSExtValue());

    SourceLocation Loc = P->getLocStart();
    if (Loc.isMacroID())
      *Arg->mutable_name() =
        Lexer::getImmediateMacroName(Loc, Ctx.getSourceManager(),
                                     Ctx.getLangOpts());

    else
      *Arg->mutable_name() = ("0x" + ConstValue.toString(16));

  } else {
    ReportError("Invalid argument to function within TESLA assertion", P);
    return false;
  }

  return true;
}


bool Parser::Parse(FunctionRef *FnRef, const FunctionDecl *Fn) {
  FnRef->set_name(Fn->getName());
  if (FnRef->name().empty()) {
    ReportError("Function must have a name", Fn);
    return false;
  }

  return true;
}


bool Parser::Parse(Argument *Arg, const ValueDecl *D, bool AllowAny) {
  assert(Arg != NULL);
  assert(D != NULL);

  *Arg->mutable_name() = D->getName();

  if (AllowAny)
    Arg->set_type(Argument::Any);
  else {
    Arg->set_type(Argument::Variable);
    Arg->set_index(ReferenceIndex(D));
  }

  return true;
}


size_t Parser::ReferenceIndex(const ValueDecl* D) {
  size_t Pos = 0;

  for (auto I = References.begin(); I != References.end(); I++)
    if (*I == D)
      return Pos;
    else
      ++Pos;

  References.push_back(D);

  return Pos;
}


void Parser::ReportError(StringRef Message, const Decl *D) {
  ReportError(Message, D->getLocStart(), D->getSourceRange());
}


void Parser::ReportError(StringRef Message, const Stmt *S) {
  ReportError(Message, S->getLocStart(), S->getSourceRange());
}


void Parser::ReportError(StringRef Message, const SourceLocation& Start,
                         const SourceRange& Range) {

  static const DiagnosticsEngine::Level Level = DiagnosticsEngine::Error;

  DiagnosticsEngine& Diag = Ctx.getDiagnostics();
  int DiagID = Diag.getCustomDiagID(Level, ("TESLA: " + Message).str());

  Diag.Report(Start, DiagID) << Range;
}


std::string Parser::ParseStringLiteral(const Expr* E) {
  auto LiteralValue = dyn_cast<StringLiteral>(E->IgnoreImplicit());
  if (!LiteralValue) {
    ReportError("expected string literal", E);
    return "";
  }

  return LiteralValue->getString();
}


llvm::APInt Parser::ParseIntegerLiteral(const Expr* E) {
  auto LiteralValue = dyn_cast<IntegerLiteral>(E->IgnoreImplicit());
  if (!LiteralValue) {
    ReportError("expected integer literal", E);
    return llvm::APInt();
  }

  return LiteralValue->getValue();
}

