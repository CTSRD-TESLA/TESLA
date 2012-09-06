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

#ifndef _TESLA_YAML_H_
#define _TESLA_YAML_H_

#include <list>
#include <map>
#include <string>
#include <vector>

#include <llvm/ADT/OwningPtr.h>

namespace tesla {

//! Code for emitting YAML (LLVM only handles parsing).
namespace yaml {


//! Base YAML type.
class Node {
public:
  virtual ~Node() {}

  //! An empty node is different from e.g., a node containing an empty string.
  virtual bool empty() const = 0;

  //! This node has no children.
  virtual bool isParent() const = 0;

  //! This node is at least a grandparent.
  virtual bool isGrandparent() const = 0;

  //! Produce "proper" YAML.
  virtual std::string str(unsigned IndentLevel = 0) const = 0;

  //! Produce the JSON subset of YAML. This is easy to emit and hard to read.
  virtual std::string json() const = 0;
};


//! Something that can describe itself in YAML.
class HasYaml {
public:
  virtual ~HasYaml() {}
  virtual Node* Yaml() const = 0;
};


//! A raw value (can be string, integer, etc.).
class Value : public Node {
public:
  bool empty() const { return false; }
  bool isParent() const { return false; }
  bool isGrandparent() const { return false; }
  std::string str(unsigned) const;
  std::string json() const;

  static Value* of(const std::string&);
  static Value* of(int);
  static Value* of(float);

private:
  Value(std::string rawRepresentation, bool needsQuotes)
    : raw(rawRepresentation), quote(needsQuotes) {}

  std::string raw;
  bool quote;
};


//! An ordered list of YAML nodes.
class Sequence : public Node {
public:
  Sequence() {}
  ~Sequence();

  Sequence& operator << (Node*);
  Sequence& operator << (std::string);
  Sequence& operator << (int);

  bool empty() const;
  bool isParent() const { return !empty(); }
  bool isGrandparent() const;
  std::string str(unsigned) const;
  std::string json() const;

private:
  std::vector<Node*> Children;
};


//! A mapping of names to YAML nodes.
class Map : public Node {
public:
  Map() {}
  ~Map();

  void set(const std::string& key, Node *value);
  void set(const std::string& key, const std::string& value);
  void set(const std::string& key, int value);

  bool empty() const;
  bool isParent() const { return !empty(); }
  bool isGrandparent() const;
  std::string str(unsigned) const;
  std::string json() const;

private:
  typedef std::map<std::string, Node*> NodeMap;
  NodeMap Mapping;
};

}
}

#endif /* !_TESLA_YAML_H_ */

