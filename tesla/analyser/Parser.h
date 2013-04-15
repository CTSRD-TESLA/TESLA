/*! @file Parser.h  Declaration of @ref Parser. */
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

#ifndef PARSER_H
#define PARSER_H

#include <tesla.pb.h>

#include <llvm/ADT/APInt.h>
#include <llvm/ADT/OwningPtr.h>

#include <string>
#include <vector>

namespace clang {
  class ASTContext;
  class BinaryOperator;
  class CallExpr;
  class CompoundStmt;
  class Decl;
  class DeclRefExpr;
  class Expr;
  class FunctionDecl;
  class SourceLocation;
  class SourceRange;
  class Stmt;
  class ValueDecl;
}

namespace llvm {
  class APSInt;
}


namespace tesla {

//! A parser for TESLA automata descriptions.
class Parser {
public:
  //! Variables referenced by an automaton.
  typedef std::vector<const clang::ValueDecl*> RefVector;

  //! Create a Parser for an inline assertion.
  static Parser* AssertionParser(clang::CallExpr*, clang::ASTContext&);

  //! Create a Parser for an automaton description.
  static Parser* AutomatonParser(clang::FunctionDecl*, clang::ASTContext&);

  /**
   * Parse the automaton and its usage.
   *
   * @param[out]  Descrip    the automaton description will be stored here
   * @param[out]  Usage      the usage of the automaton will be stored here
   *
   * @return true on success, false on failure
   */
  bool Parse(llvm::OwningPtr<AutomatonDescription>& Descrip,
             llvm::OwningPtr<Usage>& Usage);


private:
  class Flags {
  public:
    //! Default to callee-context instrumentation.
    FunctionEvent::CallContext FnInstrContext;

    //! Default to inclusive-or.
    BooleanExpr::Operation OrOperator;
  };

  Parser(clang::ASTContext& Ctx, Identifier ID = Identifier(),
         AutomatonDescription::Context C = AutomatonDescription::Global,
         clang::Expr* Begin = NULL, clang::Expr* End = NULL,
         clang::Stmt *Root = NULL, Flags InitialFlags = Flags())
    : Ctx(Ctx), ID(ID), TeslaContext(C), Beginning(Begin), End(End),
      Root(Root), RootFlags(InitialFlags)
  {
  }

  bool Parse(Location*, clang::Expr*, clang::Expr*, clang::Expr*);
  bool Parse(AutomatonDescription::Context*, clang::Expr*);

  bool Parse(Expression*, const clang::CompoundStmt*, Flags);
  bool Parse(Expression*, const clang::Expr*, Flags);
  bool Parse(Expression*, const clang::BinaryOperator*, Flags);
  bool Parse(Expression*, const clang::CallExpr*, Flags);
  bool Parse(Expression*, const clang::DeclRefExpr*, Flags);

  bool Parse(FunctionRef*, const clang::FunctionDecl*, Flags);
  bool Parse(Argument*, const clang::Expr*, Flags);
  bool Parse(Argument*, const clang::ValueDecl*, bool AllowAny, Flags);

  bool ParseSubAutomaton(Expression*, const clang::CallExpr*, Flags);
  bool ParsePredicate(Expression*, const clang::CallExpr*, Flags);

  // TESLA predicates:
  //! A method that parses @ref clang::CallExpr (predicate, sub-automaton...).
  typedef bool (Parser::*CallParser)(Expression*, const clang::CallExpr*,
                                     Flags);

  bool ParseFunctionCall(Expression*, const clang::CallExpr*, Flags);
  bool ParseFunctionReturn(Expression*, const clang::CallExpr*, Flags);
  bool ParseCallee(Expression*, const clang::CallExpr*, Flags);
  bool ParseCaller(Expression*, const clang::CallExpr*, Flags);
  bool ParseOptional(Expression*, const clang::CallExpr*, Flags);
  bool ParseSequence(Expression*, const clang::CallExpr*, Flags);

  //! Helper for @ref ParseFunctionCall and @ref ParseFunctionReturn.
  bool ParseFunctionPredicate(FunctionEvent*, const clang::CallExpr*,
                              bool ParseRetVal, Flags);

  //! Parse 'foo(x) == y'.
  bool ParseFunctionCall(Expression*, const clang::BinaryOperator*, Flags);

  //! Parse 'x->foo = bar'.
  bool ParseFieldAssign(Expression*, const clang::BinaryOperator*, Flags);


  //! Check that an @ref Expression is '__tesla_ignore'.
  bool CheckIgnore(const clang::Expr*);


  //! Parse a literal C string embedded in code.
  std::string ParseStringLiteral(const clang::Expr*);

  //! Parse an Integer Constant Expression (ICE).
  llvm::APInt ParseIntegerLiteral(const clang::Expr*);


  //! The index of a variable in our set of unique variable references.
  size_t ReferenceIndex(const clang::ValueDecl*);


  //! Report a TESLA error.
  void ReportError(llvm::StringRef Message, const clang::Decl*);
  void ReportError(llvm::StringRef Message, const clang::Stmt*);
  void ReportError(llvm::StringRef Message, const clang::SourceLocation&,
                   const clang::SourceRange&);



  clang::ASTContext& Ctx;

  const Identifier ID;
  const AutomatonDescription::Context TeslaContext;
  const clang::Expr *Beginning;     //!< Starting point (bound) for automaton.
  const clang::Expr *End;           //!< End bound for automaton.
  const clang::Stmt *Root;          //!< Expression describing the automaton.
  const Flags RootFlags;

  RefVector References;
};

}

#endif  // PARSERS_H

