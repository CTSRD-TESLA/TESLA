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

// automata
bool ParseInlineAssertion(Automaton*, clang::CallExpr*, clang::ASTContext&);

bool ParseContext(Automaton*, clang::Expr*, clang::ASTContext&);

bool ParseLocation(Location*,
                   clang::Expr *Filename, clang::Expr *Line, clang::Expr *Count,
                   clang::ASTContext&);

// expressions
bool ParseExpression(Expression*, clang::Expr*, Location, clang::ASTContext&);

bool ParseBooleanExpr(BooleanExpr*, clang::BinaryOperator*, Location,
                      clang::ASTContext&);

bool ParseSequence(Sequence*, clang::CallExpr*, Location, clang::ASTContext&);


// events
bool ParseEvent(Event*, clang::Expr *E, Location AssertionLocation,
                clang::ASTContext& Ctx);

bool ParseRepetition(Repetition*, clang::CallExpr*, Location,
                     clang::ASTContext&);

bool ParseFunctionCall(FunctionEvent*, clang::CallExpr*, clang::ASTContext&);
bool ParseFunctionCall(FunctionEvent*, clang::BinaryOperator*,
                       clang::ASTContext&);
bool ParseFunctionEntry(FunctionEvent*, clang::CallExpr*, clang::ASTContext&);
bool ParseFunctionExit(FunctionEvent*, clang::CallExpr*, clang::ASTContext&);


// references
bool ParseFunctionRef(FunctionRef*, clang::FunctionDecl*, clang::ASTContext&);
bool ParseArgument(Argument*, clang::Expr*, clang::ASTContext&);


// helpers
//! Report a TESLA error.
clang::DiagnosticBuilder Report(llvm::StringRef Message, clang::SourceLocation,
    clang::ASTContext&,
    clang::DiagnosticsEngine::Level Level = clang::DiagnosticsEngine::Error);
std::string ParseStringLiteral(clang::Expr*, clang::ASTContext&);

llvm::APInt ParseIntegerLiteral(clang::Expr*, clang::ASTContext&);

}

