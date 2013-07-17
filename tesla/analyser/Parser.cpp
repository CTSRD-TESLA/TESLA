/*! @file Parser.cpp  Definition of @ref tesla::Parser. */
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
#include <clang/AST/ExprObjC.h>
#include <clang/Basic/Diagnostic.h>
#include <clang/Lex/Lexer.h>

#include <llvm/ADT/StringSwitch.h>
#include <algorithm>

#include <tesla.pb.h>

using namespace clang;
using namespace tesla;


Parser* Parser::AssertionParser(CallExpr *Call, ASTContext& Ctx) {
  assert(Call->getDirectCallee()->getName().compare(INLINE_ASSERTION) == 0);

  OwningPtr<Parser> Bootstrap(new Parser(Ctx));

  if (Call->getNumArgs() != 7) {
    Bootstrap->ReportError(
      "expected seven arguments: "
      "filename, line, counter, context, start, end, expression",
      Call);
    return NULL;
  }

  Expr *Filename    = Call->getArg(0);
  Expr *Line        = Call->getArg(1);
  Expr *Counter     = Call->getArg(2);
  Expr *Context     = Call->getArg(3);
  Expr *Beginning   = Call->getArg(4);
  Expr *End         = Call->getArg(5);
  Expr *Expression  = Call->getArg(6);

  Identifier ID;
  if (!Bootstrap->Parse(ID.mutable_location(), Filename, Line, Counter))
    return NULL;

  AutomatonDescription::Context TeslaContext;
  if (!Bootstrap->Parse(&TeslaContext, Context))
    return NULL;

  Flags RootFlags;
  RootFlags.FnInstrContext = FunctionEvent::Callee;
  RootFlags.OrOperator = BooleanExpr::BE_Or;
  RootFlags.StrictMode = false;

  StringRef SourceCode(Bootstrap->FindOriginalSource(Call->getSourceRange()));

  return new Parser(Ctx, ID, TeslaContext, Beginning, End, Expression,
                    RootFlags, SourceCode);
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

  Flags RootFlags;
  RootFlags.FnInstrContext = FunctionEvent::Callee;
  RootFlags.OrOperator = BooleanExpr::BE_Xor;
  RootFlags.StrictMode = true;

  StringRef SourceCode(Bootstrap->FindOriginalSource(F->getSourceRange()));

  return new Parser(Ctx, ID, Context, NULL, NULL, F->getBody(), RootFlags,
                    SourceCode);
}


Parser* Parser::MappingParser(FunctionDecl *F, ASTContext& Ctx) {
  assert(F != NULL);
  assert(F->doesThisDeclarationHaveABody());

  OwningPtr<Parser> Bootstrap(new Parser(Ctx));

  auto Body = dyn_cast<CompoundStmt>(F->getBody());
  if (!Body) {
    Bootstrap->ReportError("expected a function body (compound statement)", F);
    return NULL;
  }

  if (Body->size() != 1) {
    Bootstrap->ReportError("expected a single statement", F->getBody());
    return NULL;
  }

  auto Ret = dyn_cast<ReturnStmt>(Body->body_back());
  if (!Ret) {
    Bootstrap->ReportError("expected a return statement", Body->body_back());
    return NULL;
  }

  auto Call = dyn_cast<CallExpr>(Ret->getRetValue());
  if (!Call || !Call->getDirectCallee()
      || (Call->getDirectCallee()->getName() != AUTOMATON_USES)) {
    Bootstrap->ReportError("expected call to " + AUTOMATON_USES, Ret);
    return NULL;
  }

  Expr* Args[4];
  const size_t ArgCount = sizeof(Args) / sizeof(Args[0]);

  if (Call->getNumArgs() != ArgCount) {
    Bootstrap->ReportError("expected automaton, locality, start, end", Call);
    return NULL;
  }

  for (size_t i = 0; i < ArgCount; i++)
    Args[i] = Call->getArg(i)->IgnoreImplicit();

  auto Automaton = Bootstrap->ParseStringLiteral(Call->getArg(0));
  if (Automaton.empty()) {
    Bootstrap->ReportError("expected automaton name", Call->getArg(0));
    return NULL;
  }

  auto Locality = dyn_cast<DeclRefExpr>(Call->getArg(1)->IgnoreImplicit());
  if (!Locality) {
    Bootstrap->ReportError("expected TESLA locality", Call->getArg(1));
    return NULL;
  }

  auto Beginning = Call->getArg(2);
  auto End = Call->getArg(3);

  Identifier ID;
  ID.set_name(Automaton);

  AutomatonDescription::Context Context;
  if (!Bootstrap->Parse(&Context, Locality))
    return NULL;

  Flags RootFlags;
  RootFlags.FnInstrContext = FunctionEvent::Callee;

  return new Parser(Ctx, ID, Context, Beginning, End, NULL, RootFlags);
}


bool Parser::Parse(Expression *E, const CompoundStmt *C, Flags F) {
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
      if (!Parse(Seq->add_expression(), E, F))
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


bool Parser::Parse(OwningPtr<AutomatonDescription>& Description,
                   OwningPtr<Usage>& Use) {
  OwningPtr<AutomatonDescription> A(new AutomatonDescription);
  *A->mutable_identifier() = ID;
  A->set_context(TeslaContext);

  OwningPtr<Usage> U(new Usage);
  *U->mutable_identifier() = ID;

  if (!SourceCode.empty())
    A->set_source(SourceCode.str());

  // Parse the automaton's [beginning,end] bounds.
  if (Beginning && !Parse(U->mutable_beginning(), Beginning, RootFlags))
    return false;

  if (End && !Parse(U->mutable_end(), End, RootFlags))
    return false;

  // Parse the root: a compound statement or an expression.
  if (Root) {
    bool Success = false;
    if (auto *C = dyn_cast<CompoundStmt>(Root))
      Success = Parse(A->mutable_expression(), C, RootFlags);

    else if (auto *E = dyn_cast<Expr>(Root))
      Success = Parse(A->mutable_expression(), E, RootFlags);

    else
      ReportError("expected expression or compound statement", Root);

    if (!Success)
      return false;
  }

  // Keep track of the variables we referenced.
  for (const ValueDecl *D : References)
    if (!Parse(A->add_argument(), D, false, RootFlags))
      return false;

  if (A->has_expression())
    Description.swap(A);

  if (U->has_beginning() || U->has_end())
    Use.swap(U);

  return true;
}


bool Parser::Parse(Expression *Ex, const Expr *E, Flags F) {
  assert(Ex != NULL);
  assert(E != NULL);

  E = E->IgnoreImplicit();

  if (auto Assign = dyn_cast<CompoundAssignOperator>(E))
    return ParseFieldAssign(Ex, Assign, F);

  if (auto Bop = dyn_cast<BinaryOperator>(E))
    return Parse(Ex, Bop, F);

  if (auto Call = dyn_cast<CallExpr>(E))
    return Parse(Ex, Call, F);

  if (auto DRE = dyn_cast<DeclRefExpr>(E))
    return Parse(Ex, DRE, F);

  if (auto U = dyn_cast<UnaryOperator>(E))
    return Parse(Ex, U, F);

  ReportError("unsupported TESLA expression", E);
  return false;
}


bool Parser::Parse(Expression *E, const BinaryOperator *Bop, Flags F) {

  assert(BooleanExpr_Operation_IsValid(F.OrOperator));

  BooleanExpr::Operation Op;

  switch (Bop->getOpcode()) {
    default:
      ReportError("unsupported boolean operation", Bop);
      return false;

    case BO_Assign:   return ParseFieldAssign(E, Bop, F);   // 'x->foo = bar'
    case BO_EQ:       return ParseFunctionCall(E, Bop, F);  // 'foo(x) == y'

    case BO_LAnd:     Op = BooleanExpr::BE_And;   break;
    case BO_LOr:      Op = F.OrOperator;          break;
  }

  E->set_type(Expression::BOOLEAN_EXPR);

  auto *BE = E->mutable_booleanexpr();
  BE->set_operation(Op);

  return Parse(BE->add_expression(), Bop->getLHS(), F)
      && Parse(BE->add_expression(), Bop->getRHS(), F);
}


bool Parser::Parse(Expression *E, const CallExpr *Call, Flags F) {

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

  return (this->*Parse)(E, Call, F);
}


bool Parser::Parse(Expression *E, const DeclRefExpr *Ref, Flags F) {
  auto D = Ref->getDecl();
  assert(D != NULL);

  if (D->getName() == ASSERTION_SITE) {
    E->set_type(Expression::ASSERTION_SITE);
    *E->mutable_assertsite()->mutable_location() = ID.location();
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


bool Parser::Parse(Expression *E, const UnaryOperator *U, Flags F) {
  // We only support unary operators in struct field expressions (for now).
  E->set_type(Expression::FIELD_ASSIGN);
  FieldAssignment *A = E->mutable_fieldassign();
  A->set_strict(F.StrictMode);

  // Since we're parsing an expression, rather than an argument, we don't
  // care about pre- vs postfix.
  switch(U->getOpcode()) {
  case UO_PreInc:   // fall through
  case UO_PostInc:
    A->set_operation(FieldAssignment::PlusEqual);
    break;

  case UO_PreDec:   // fall through
  case UO_PostDec:
    A->set_operation(FieldAssignment::MinusEqual);
    break;

  default:
    ReportError("unsupported unary operator", U);
    return false;
  }

  auto *RHS = A->mutable_value();
  RHS->set_type(Argument::Constant);
  RHS->set_value(1);

  auto ME = dyn_cast<MemberExpr>(U->getSubExpr());
  if (!ME) {
    ReportError("expected struct member", U->getSubExpr());
    return false;
  }

  return CheckAssignmentKind(ME->getMemberDecl(), U)
      && ParseStructField(A->mutable_field(), ME, F);
}


bool Parser::ParseSequence(Expression *E, const CallExpr *Call, Flags F) {

  E->set_type(Expression::SEQUENCE);
  Sequence *Seq = E->mutable_sequence();

  for (auto Arg = Call->arg_begin(); Arg != Call->arg_end(); ++Arg)
    if (!Parse(Seq->add_expression(), *Arg, F))
      return false;

  return true;
}


bool Parser::ParseSubAutomaton(Expression *E, const CallExpr *Call, Flags F) {
  E->set_type(Expression::SUB_AUTOMATON);
  E->mutable_subautomaton()->set_name(Call->getDirectCallee()->getName());
  return true;
}


bool Parser::ParsePredicate(Expression *E, const CallExpr *Call, Flags F) {
  const FunctionDecl *Fun = Call->getDirectCallee();
  assert(Fun != NULL);

  auto Parse = llvm::StringSwitch<CallParser>(Fun->getName())
    .Case("__tesla_call",         &Parser::ParseFunctionCall)
    .Case("__tesla_return",       &Parser::ParseFunctionReturn)
    .Case("__tesla_callee",       &Parser::ParseCallee)
    .Case("__tesla_caller",       &Parser::ParseCaller)
    .Case("__tesla_strict",       &Parser::ParseStrictMode)
    .Case("__tesla_conditional",  &Parser::ParseConditional)
    .Case("__tesla_sequence",     &Parser::ParseSequence)
    .Case("__tesla_optional",     &Parser::ParseOptional)
    .Default(NULL);

  if (Parse == NULL) {
    ReportError("unsupported predicate", Call);
    return false;
  }

  return (this->*Parse)(E, Call, F);
}


bool Parser::ParseOptional(Expression *E, const CallExpr *Call, Flags F) {

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
  B->set_operation(BooleanExpr::BE_Xor);

  B->add_expression()->set_type(Expression::NULL_EXPR);
  return Parse(B->add_expression(), Call->getArg(1), F);
}


bool Parser::ParseFunctionCall(Expression *E, const BinaryOperator *Bop,
                               Flags F) {

  E->set_type(Expression::FUNCTION);

  FunctionEvent *FnEvent = E->mutable_function();
  FnEvent->set_context(F.FnInstrContext);
  FnEvent->set_strict(F.StrictMode);

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
  if (!Parse(FnEvent->mutable_expectedreturnvalue(), RetVal, F))
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

  if (!Parse(FnEvent->mutable_function(), Fn, F))
    return false;

  for (auto I = FnCallExpr->arg_begin(); I != FnCallExpr->arg_end(); ++I) {
    if (!Parse(FnEvent->add_argument(), I->IgnoreImplicit(), F))
      return false;
  }

  return true;
}


bool Parser::ParseFunctionCall(Expression *E, const CallExpr *Call, Flags F) {

  E->set_type(Expression::FUNCTION);

  FunctionEvent *FnEvent = E->mutable_function();
  FnEvent->set_direction(FunctionEvent::Entry);
  FnEvent->set_strict(F.StrictMode);

  return ParseFunctionPredicate(FnEvent, Call, false, F);
}


bool Parser::ParseFunctionReturn(Expression *E, const CallExpr *Call, Flags F) {

  E->set_type(Expression::FUNCTION);

  FunctionEvent *FnEvent = E->mutable_function();
  FnEvent->set_direction(FunctionEvent::Exit);
  FnEvent->set_strict(F.StrictMode);

  return ParseFunctionPredicate(FnEvent, Call, true, F);
}


bool Parser::ParseCallee(Expression *E, const clang::CallExpr *Call, Flags F) {

  F.FnInstrContext = FunctionEvent::Callee;

  if (Call->getNumArgs() != 2) {
    ReportError("expected two arguments: __tesla_ignore, expression", Call);
    return false;
  }

  return CheckIgnore(Call->getArg(0))
         && Parse(E, Call->getArg(1), F);
}


bool Parser::ParseCaller(Expression *E, const clang::CallExpr *Call, Flags F) {

  F.FnInstrContext = FunctionEvent::Caller;

  if (Call->getNumArgs() != 2) {
    ReportError("expected two arguments: __tesla_ignore, expression", Call);
    return false;
  }

  return CheckIgnore(Call->getArg(0))
         && Parse(E, Call->getArg(1), F);
}


bool Parser::ParseStrictMode(Expression *E, const clang::CallExpr *Call,
                             Flags F) {

  if (Call->getNumArgs() != 2) {
    ReportError("expected two arguments: __tesla_ignore, expression", Call);
    return false;
  }

  F.StrictMode = true;
  return CheckIgnore(Call->getArg(0))
         && Parse(E, Call->getArg(1), F);
}


bool Parser::ParseConditional(Expression *E, const clang::CallExpr *Call,
                              Flags F) {

  if (Call->getNumArgs() != 2) {
    ReportError("expected two arguments: __tesla_ignore, expression", Call);
    return false;
  }

  F.StrictMode = false;
  return CheckIgnore(Call->getArg(0))
         && Parse(E, Call->getArg(1), F);
}


bool Parser::ParseFunctionPredicate(FunctionEvent *Event, const CallExpr *Call,
                                    bool ParseRetVal, Flags F) {

  Event->set_context(F.FnInstrContext);

  // The arguments to __tesla_call/return are the function itself and then,
  // optionally, the arguments (any of which may be __tesla_any()).
  if (Call->getNumArgs() < 1) {
    ReportError("missing function argument", Call);
    return false;
  }

  auto Arg = Call->getArg(0)->IgnoreParenCasts();
  auto FnRef = dyn_cast<DeclRefExpr>(Arg);
  // For C function calls
  const FunctionDecl *Fn = 0;
  // For Objective-C message sends
  const ObjCMethodDecl *Meth = 0;

  const Expr *const*Args;
  SmallVector<const Expr*, 8> ArgsVector;
  int ArgCount = 0;

  if (FnRef) {
    Args = Call->getArgs() + 1;
    ArgCount = Call->getNumArgs() - 1;
  } else
      if (const BinaryOperator *BinOp = dyn_cast<BinaryOperator>(Arg))
        if (BinOp->getOpcode() == BO_Comma) {
          Arg = BinOp->getLHS()->IgnoreParenCasts();
          // IF this is just a function name (undecorated) then use it),
          // otherwise get the call expression and look at it.
          if (isa<BinaryOperator>(Arg))
            while (const BinaryOperator *BO = dyn_cast<BinaryOperator>(Arg)) {
              ArgsVector.push_back(BO->getRHS()->IgnoreParenCasts());
              Arg = BO->getLHS()->IgnoreParenCasts();
            }
          if ((FnRef = dyn_cast<DeclRefExpr>(Arg))) {
            std::reverse(ArgsVector.begin(), ArgsVector.end());
            ArgCount = ArgsVector.size();
            Args = ArgsVector.data();
          } else if (const CallExpr *CE = dyn_cast<CallExpr>(Arg)) {
            // If there isn't a direct callee, then we'll fall through to the
            // error block.  We probably should have a better error report
            // here.
            Fn = CE->getDirectCallee();
            // Use this call as the call expression so that we can look at
            // its arguments, and don't skip the first argument.
            Args = CE->getArgs();
            ArgCount = CE->getNumArgs();
          } else if (const ObjCMessageExpr *OME = dyn_cast<ObjCMessageExpr>(Arg)) {
            Meth = OME->getMethodDecl();
            if (!Meth) {
              ReportError("types of Objective-C method to be instrumented must be known", OME);
              return false;
            }
            FunctionEvent::CallKind kind;
            switch (OME->getReceiverKind()) {
              default: assert(0); break;
              case ObjCMessageExpr::Class:
                Event->mutable_receiver()->set_name(OME->getReceiverInterface()->getName());
                kind = FunctionEvent::ObjCClassMessage;
                break;
              case ObjCMessageExpr::Instance:
                Parse(Event->mutable_receiver(), OME->getInstanceReceiver(), F);
                kind = FunctionEvent::ObjCInstanceMessage;
                break;
              case ObjCMessageExpr::SuperClass:
              case ObjCMessageExpr::SuperInstance:
                kind = FunctionEvent::ObjCSuperMessage;
                break;
            }
            Event->set_kind(kind);
            Event->mutable_function()->set_name(Meth->getNameAsString());
            Args = OME->getArgs();
            ArgCount = OME->getNumArgs();
          } else {
            Call->dump();
            assert(0);
          }
          // TODO: This is where ObjC / C++ method call expressions would be
          // inspected.
        }

  if (FnRef)
    Fn = dyn_cast<FunctionDecl>(FnRef->getDecl());

  if (!(Fn || Meth)) {
    ReportError("called() must refer to a function or method call", Call);
    return false;
  }

  bool HaveRetVal = ParseRetVal && 
    (Fn ? !Fn->getResultType()->isVoidType()
        : Meth->getResultType()->isVoidType()) ;

  // Parse the arguments to the event: either specified by the programmer in
  // the assertion or else the definition of the function.

  if (ArgCount > 0) {
    const size_t ExpectedSize = (Fn ? Fn->param_size() : Meth->param_size())
      + (HaveRetVal ? 1 : 0);

    // If an assertion specifies any arguments, it must specify all of them.
    if (ArgCount != ExpectedSize) {
      ReportError("specify all args (possibly __tesla_any()) or none", Call);
      return false;
    }

    for (size_t i = 0; i < ArgCount; i++) {
      if (!Parse(Event->add_argument(), Args[i], F))
        return false;
    }

    if (HaveRetVal)
    { assert(0);
      if (!Parse(Event->mutable_expectedreturnvalue(),
                 Args[ArgCount-1], F))
        return false;
    }

  } else {
    // The assertion doesn't specify any arguments; include information about
    // arguments from the function definition, just for information.
    if (Fn)
      for (auto I = Fn->param_begin(); I != Fn->param_end(); ++I) {
        if (!Parse(Event->add_argument(), *I, true, F))
          return false;
      }
    else
      for (auto I = Meth->param_begin(); I != Meth->param_end(); ++I) {
        if (!Parse(Event->add_argument(), *I, true, F))
          return false;
      }


    if (HaveRetVal)
      Event->mutable_expectedreturnvalue()->set_type(Argument::Any);
  }

  return Fn ? Parse(Event->mutable_function(), Fn, F) : true;
}


bool Parser::ParseFieldAssign(Expression *E, const clang::BinaryOperator *O,
                              Flags F) {

  E->set_type(Expression::FIELD_ASSIGN);
  FieldAssignment *A = E->mutable_fieldassign();
  A->set_strict(F.StrictMode);

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

  return CheckAssignmentKind(LHS->getMemberDecl(), O)
      && ParseStructField(A->mutable_field(), LHS, F)
      && Parse(A->mutable_value(), O->getRHS(), F);
}


bool Parser::ParseStructField(StructField *Field, const MemberExpr *ME,
                              Flags F) {
  auto *Base =
    dyn_cast<DeclRefExpr>(ME->getBase()->IgnoreImpCasts())->getDecl();

  auto BaseType = Base->getType();

  if (auto *BasePtrType = dyn_cast<PointerType>(BaseType))
    BaseType = BasePtrType->getPointeeType();

  if (BaseType.isNull()) {
    ReportError("base of assignment ME not a struct type", Base);
    return false;
  }

  Field->set_type(BaseType->getAsStructureType()->getDecl()->getName());

  auto *Member = dyn_cast<FieldDecl>(ME->getMemberDecl());
  if (!Member) {
    ReportError("struct member is not a FieldDecl", ME);
    return false;
  }

  Field->set_index(Member->getFieldIndex());
  Field->set_name(Member->getName());

  return Parse(Field->mutable_base(), Base, false, F);
}


bool Parser::Parse(Argument *Arg, const Expr *E, Flags F) {
  assert(Arg != NULL);
  assert(E != NULL);

  auto P = E->IgnoreParenCasts();
  llvm::APSInt ConstValue;

  // Each variable references must be one of:
  //  - a call to a TESLA pseudo-function:
  //    - __tesla_flags(),
  //    - __tesla_mask(),
  //    - __tesla_any*(),
  //  - a reference to a named declaration or
  //  - an integer constant expression.
  if (auto Call = dyn_cast<CallExpr>(P)) {
    auto Fn = Call->getDirectCallee();
    if (!Fn) {
      ReportError("expected TESLA predicate", P);
      return false;
    }

    StringRef Name = Fn->getName();

    if ((Name == FLAGS) || (Name == MASK)) {
      if (Call->getNumArgs() != 1) {
        ReportError("expected one argument", Call);
        return false;
      }

      Arg->set_constantmatch(
        (Name == FLAGS) ? Argument::Flags : Argument::Mask);
      P = Call->getArg(0);

    } else if (Name.slice(0, ANY.length()) == ANY) {
      Arg->set_type(Argument::Any);
      return true;

    } else {
      ReportError("expected __tesla_{flags,mask,any}", P);
      return false;
    }

  }

  if (auto DRE = dyn_cast<DeclRefExpr>(P)) {
    Arg->set_type(Argument::Variable);
    const ValueDecl *D = DRE->getDecl();

    *Arg->mutable_name() = DRE->getDecl()->getName();
    Arg->set_index(ReferenceIndex(D));
    return true;
  }

  if (P->isIntegerConstantExpr(ConstValue, Ctx)) {
    Arg->set_type(Argument::Constant);
    Arg->set_value(ConstValue.getSExtValue());

    // Find an appropriate string representation for the value.
    SourceLocation Loc = P->getLocStart();
    if (Loc.isMacroID()) {
      //
      // The constant's SourceLocation is within a macro; check if the macro
      // represents the value itself (e.g. #define FOO 1) or if a literal
      // happens to be written within a macro (e.g. TSEQUENCE(foo(12))).
      //
      // TODO(JA): understand and/or fix this:
      // For reasons I don't understand, the most straightforward tests like
      // SM.isAtStartOfImmediateMacroExpansion(Loc) or (Loc == SpellingLoc)
      // don't tell us what we want to know: is the IntegerLiteral's value
      // written in the same place as its spelling (within the code)?
      //
      // These two SouceLocation objects always seem to have different opaque
      // internal values, but in the case we care about (where the value is
      // actually given as a #defined macro), they point to the same raw
      // character data from the relevant source file.
      //
      auto& SM = Ctx.getSourceManager();

      const char *RawCharData = SM.getCharacterData(Loc);
      const char *SpellingCharData = SM.getCharacterData(
        SM.getSLocEntry(SM.getFileID(Loc))
          .getExpansion()
          .getSpellingLoc());

      if (RawCharData == SpellingCharData)
        *Arg->mutable_name() =
          Lexer::getImmediateMacroName(Loc, SM, Ctx.getLangOpts());
    }

    return true;
  }

  // We also allow a very limited number of simple expressions:
  //  * multiple-return-via-pointer: foo(&x) => foo() returned x via pointer
  if (auto *UO = dyn_cast<UnaryOperator>(P)) {
    if (UO->getOpcode() == UO_AddrOf) {
      Arg->set_type(Argument::Indirect);
      return Parse(Arg->mutable_indirection(), UO->getSubExpr(), F);
    }
  }

  //  * structure field access: bar(s->x) => called bar() with s->x (TODO)
  if (auto *ME = dyn_cast<MemberExpr>(P)) {
    Arg->set_type(Argument::Field);
    return ParseStructField(Arg->mutable_field(), ME, F);
  }

  P->dump();
  ReportError("Invalid argument to function within TESLA assertion", P);
  return false;
}

bool Parser::Parse(FunctionRef *FnRef, const FunctionDecl *Fn, Flags F) {
  FnRef->set_name(Fn->getName());
  if (FnRef->name().empty()) {
    ReportError("Function must have a name", Fn);
    return false;
  }

  return true;
}


bool Parser::Parse(Argument *Arg, const ValueDecl *D, bool AllowAny, Flags F) {
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


bool Parser::CheckIgnore(const Expr *E) {
  auto *IgnoreRef = dyn_cast<DeclRefExpr>(E->IgnoreParenCasts());
  if (!IgnoreRef || IgnoreRef->getDecl()->getName() != IGNORE) {
    ReportError("expected " + IGNORE, E);
    E->dump();
    return false;
  }

  return true;
}


static inline bool SimpleAssignment(const Expr *E) {
  auto *BO = dyn_cast<BinaryOperator>(E);
  return (BO != NULL) && (BO->getOpcode() == BO_Assign);
}

bool Parser::CheckAssignmentKind(const ValueDecl *Field, const Expr *E) {
  auto i = FieldAssignments.find(Field);
  if (i == FieldAssignments.end()) {
    FieldAssignments[Field] = E;
    return true;
  }

  auto *Old = i->second;

  if (SimpleAssignment(E) == SimpleAssignment(Old))
    return true;

  static DiagnosticsEngine& Diag = Ctx.getDiagnostics();
  static int Warn = Diag.getCustomDiagID(DiagnosticsEngine::Warning,
    "TESLA: mixing instrumentation of simple and compound assignments");

  static int Note = Diag.getCustomDiagID(DiagnosticsEngine::Note,
    "TESLA: previous assignment here");

  Diag.Report(E->getLocStart(), Warn) << E->getSourceRange();
  Diag.Report(Old->getLocStart(), Note) << Old->getSourceRange();

  return false;
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


llvm::StringRef Parser::FindOriginalSource(const SourceRange& Range)
{
  auto& SM = Ctx.getSourceManager();
  auto *Begin = SM.getCharacterData(SM.getExpansionLoc(Range.getBegin()));

  // TODO: Correctly find the end of the range, in the original source file,
  //       robust against macro expansion, etc.
  //
  //       Note that the API that looks like it ought to do it,
  //       SourceManager::getExpansion____(), doesn't do what you'd expect.
  StringRef Raw(Begin, 1000);
  auto End = Raw.find(';');
  if (End != std::string::npos) End += 1;

  return Raw.substr(0, End);
}
