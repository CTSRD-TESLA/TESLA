/*! @file Parse.h  Code to parse Clang ASTs into TESLA descriptions. */
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

#include "tesla.pb.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/Basic/Diagnostic.h"

namespace tesla {

//! Parse a TESLA assertion embedded in C code.
bool ParseInlineAssertion(Assertion*, clang::CallExpr*, clang::ASTContext&);

//! Parse the context (global or per-thread) for an automaton.
bool ParseContext(Assertion*, clang::Expr*, clang::ASTContext&);

//! Parse the location where an automaton is defined.
bool ParseLocation(Location*,
                   clang::Expr *Filename, clang::Expr *Line, clang::Expr *Count,
                   clang::ASTContext&);


//! Parse a (polymorphic-ish) TESLA expression.
bool ParseExpression(Expression*, clang::Expr*, Assertion*,
                     std::vector<clang::ValueDecl*>& References,
                     clang::ASTContext&);

//! Parse a boolean expression over TESLA expressions.
bool ParseBooleanExpr(BooleanExpr*, clang::BinaryOperator*, Assertion*,
                      std::vector<clang::ValueDecl*>& References,
                      clang::ASTContext&);

//! Parse a sequence of TESLA events.
bool ParseSequence(Sequence*, clang::CallExpr*, Assertion*,
                   std::vector<clang::ValueDecl*>& References,
                   clang::ASTContext&);


//! Parse a (polymorphic-ish) TESLA event.
bool ParseEvent(Event*, clang::Expr *E, Assertion *A,
                std::vector<clang::ValueDecl*>& References,
                clang::ASTContext& Ctx);

//! Parse a sequence of repeated events (a la "aba"+).
bool ParseRepetition(Repetition*, clang::CallExpr*, Assertion *A,
                     std::vector<clang::ValueDecl*>& References,
                     clang::ASTContext&);

//! Parse a TESLA-wrapped function call: '__tesla_call(f(x) == y)'.
bool ParseFunctionCall(FunctionEvent*, clang::CallExpr*,
                       std::vector<clang::ValueDecl*>& References,
                       clang::ASTContext&);

//! Parse an unwrapped function call: 'f(x) == y'.
bool ParseFunctionCall(FunctionEvent*, clang::BinaryOperator*,
                       std::vector<clang::ValueDecl*>& References,
                       clang::ASTContext&);

//! Parse a __tesla_entered() predicate.
bool ParseFunctionEntry(FunctionEvent*, clang::CallExpr*,
                        std::vector<clang::ValueDecl*>& References,
                        clang::ASTContext&);

//! Parse a __tesla_leaving() predicate.
bool ParseFunctionExit(FunctionEvent*, clang::CallExpr*,
                       std::vector<clang::ValueDecl*>& References,
                       clang::ASTContext&);


//! Parse a reference to a function that requires instrumentation.
bool ParseFunctionRef(FunctionRef*, clang::FunctionDecl*, clang::ASTContext&);

//! Parse a parameter to a function that requires instrumentation.
bool ParseArgument(Argument*, clang::ValueDecl*,
                   std::vector<clang::ValueDecl*>& References,
                   clang::ASTContext&,
                   bool AllowAny = false);

//! Parse an argument to a function that requires instrumentation.
bool ParseArgument(Argument*, clang::Expr*,
                   std::vector<clang::ValueDecl*>& References,
                   clang::ASTContext&);


// Some useful helpers:
//! Report a TESLA error.
clang::DiagnosticBuilder Report(llvm::StringRef Message, clang::SourceLocation,
    clang::ASTContext&,
    clang::DiagnosticsEngine::Level Level = clang::DiagnosticsEngine::Error);

//! Parse a literal C string embedded in code.
std::string ParseStringLiteral(clang::Expr*, clang::ASTContext&);

//! Parse an Integer Constant Expression (ICE).
llvm::APInt ParseIntegerLiteral(clang::Expr*, clang::ASTContext&);

}

