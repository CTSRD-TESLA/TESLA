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

#include "yaml.h"

#include <sstream>


using std::ostringstream;
using std::pair;
using std::string;


namespace tesla {
namespace yaml {

string Indent(unsigned IndentLevel) {
  return string(IndentLevel, ' ');
}

// ==== Value implementation ===================================================
Value* Value::of(const string& str) { return new Value(str, true); }
Value* Value::of(int i) {
  ostringstream out;
  out << std::iostream::dec << i;

  return new Value(out.str(), false);
}

string Value::str(unsigned IndentLevel) const { return json(); }
string Value::json() const {
  // TODO: more sophisticated quoting (including escaping)
  if (quote) return '"' + raw + '"';
  else return raw;
}



// ==== Sequence implementation ================================================
Sequence::~Sequence() {
  for (auto *Child : Children) delete Child;
}

Sequence& Sequence::operator << (Node *N) {
  Children.push_back(N);
  return *this;
}

Sequence& Sequence::operator << (string S) {
  return (*this << Value::of(S));
}

Sequence& Sequence::operator << (int I) {
  return (*this << Value::of(I));
}

bool Sequence::empty() const {
  return Children.empty();
}

bool Sequence::isGrandparent() const {
  for (const Node* Child : Children)
    if (Child->isParent()) return true;

  return false;
}

string Sequence::str(unsigned IndentLevel) const {
  ostringstream out;

  if (isGrandparent()) {
    // This is the general case for formatting, with indents, etc.
    out << "\n";
    for (const Node* Child : Children) {
      assert(Child);
      out
        << Indent(IndentLevel) << "-" << Indent(1)
        << Child->str(IndentLevel + 2) << "\n";
    }
  } else {
    // Optimisation for simple cases: output "[ a, b, c, ]".
    out << "[ ";
    for (const Node* Child : Children) {
      assert(Child);
      out << Child->str() << ", ";
    }
    out << "]";
  }

  return out.str();
}

string Sequence::json() const {
  ostringstream out;

  out << "[ ";
  for (const Node* Child : Children) {
    assert(Child);
    out << Child->json() << ", ";
  }
  out << "]";

  return out.str();
}



// ==== Map implementation =====================================================
Map::~Map() {
  for (const pair<string,Node*>& Entry : Mapping) delete Entry.second;
}

void Map::set(const string& Key, Node *Value) {
  Mapping[Key] = Value;
}

void Map::set(const string& Key, const string& Value) {
  set(Key, Value::of(Value));
}

void Map::set(const string& Key, int Value) {
  set(Key, Value::of(Value));
}

bool Map::empty() const {
  return Mapping.empty();
}

bool Map::isGrandparent() const {
  for (const pair<string,Node*>& Entry : Mapping) {
    Node* Value = Entry.second;
    assert(Value);

    if (Value->isParent()) return true;
  }

  return false;
}

string Map::str(unsigned IndentLevel) const {
  const string I = Indent(IndentLevel);
  ostringstream out;

  /**
   * For now, don't use the abbreviated map syntax, as LLVM's YAML parser will
   * sometimes choke on it (specifically, if there is an inline "flow syntax"
   * map within a "block syntax" map).
   *
   * @see http://llvm.org/bugs/show_bug.cgi?id=13834
   */
  //if (isGrandparent()) {
    // General-case formatting.
    out << "\n";

    for (const pair<string,Node*>& Entry : Mapping) {
      const string& Key = Entry.first;
      Node* Value = Entry.second;

      assert(Value);

      out << I << Key << ": " << Value->str(IndentLevel + 1) << "\n";
    }
#if 0
  } else {
    // Optimisation for simple cases.
    out << "{ ";

    for (const pair<string,Node*>& Entry : Mapping) {
      const string& Key = Entry.first;
      Node* Value = Entry.second;

      assert(Value);

      out << Key << ": " << Value->str() << ", ";
    }

    out << " }";
  }
#endif

  return out.str();
}

string Map::json() const {
  ostringstream out;

  out << "{ ";

  for (const pair<string,Node*>& Entry : Mapping) {
    const string& Key = Entry.first;
    Node* Value = Entry.second;

    assert(Value);

    out << '"' << Key << "\": " << Value->json() << ", ";
  }

  out << "}";

  return out.str();
}


} // namespace yaml
} // namespace tesla

