/*! @file Protocol.cpp
 * Definition of protocol buffer helper functions.
 */
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

#include "Debug.h"
#include "Protocol.h"

#include <google/protobuf/descriptor.h>
#include <llvm/Support/ErrorHandling.h>

using google::protobuf::FieldDescriptor;
using google::protobuf::Message;
using google::protobuf::Reflection;

namespace tesla {
static bool FieldEq(const Message&, const Message&, const Reflection&,
                    const FieldDescriptor*, int index = -1);
}

bool tesla::operator == (const Message& x, const Message& y) {
  if (x.GetTypeName() != y.GetTypeName())
    return false;

  auto* r = x.GetReflection();

  std::vector<const FieldDescriptor*> xFields, yFields;
  r->ListFields(x, &xFields);
  r->ListFields(y, &yFields);

  if (xFields.size() != yFields.size())
    return false;

  for (auto f : xFields) {
    assert(f->type() <= FieldDescriptor::MAX_TYPE);

    if (f->is_repeated()) {
      const size_t Size = r->FieldSize(x, f);

      if (r->FieldSize(y, f) != Size)
        return false;

      for (size_t i = 0; i < Size; i++)
        if (!FieldEq(x, y, *r, f, i))
          return false;

    } else {
      if (!r->HasField(y, f))
        return false;

      if (!FieldEq(x, y, *r, f))
        return false;
    }
  }

  return true;
}

bool tesla::FieldEq(const Message& x, const Message& y, const Reflection& r,
                    const FieldDescriptor *field, int i) {

  const bool Repeated = (i >= 0);

  if (Repeated)
    assert((r.FieldSize(x, field) > i) && (r.FieldSize(y, field) > i));
  else
    assert(r.HasField(x, field) && r.HasField(y, field));

  #define GET(message, type, i) \
    (Repeated \
      ? r.GetRepeated##type(message, field, i) \
      : r.Get##type(message, field))

  switch (field->type()) {
  case FieldDescriptor::TYPE_BOOL:
    return (GET(x, Bool, i) == GET(y, Bool, i));

  case FieldDescriptor::TYPE_INT32:
    return (GET(x, Int32, i) == GET(y, Int32, i));

  case FieldDescriptor::TYPE_UINT32:
    return (GET(x, UInt32, i) == GET(y, UInt32, i));

  case FieldDescriptor::TYPE_INT64:
    return (GET(x, Int64, i) == GET(y, Int64, i));

  case FieldDescriptor::TYPE_UINT64:
    return (GET(x, UInt64, i) == GET(y, UInt64, i));

  case FieldDescriptor::TYPE_FLOAT:
    return (GET(x, Float, i) == GET(y, Float, i));

  case FieldDescriptor::TYPE_DOUBLE:
    return (GET(x, Double, i) == GET(y, Double, i));

  case FieldDescriptor::TYPE_STRING:
    return (GET(x, String, i) == GET(y, String, i));

  case FieldDescriptor::TYPE_ENUM: {
    auto *xe = GET(x, Enum, i), *ye = GET(y, Enum, i);
    return ((xe->full_name() == ye->full_name())
            && (xe->number() == ye->number()));
  }

  case FieldDescriptor::TYPE_MESSAGE: {
    const Message &xm = GET(x, Message, i), &ym = GET(y, Message, i);
    return (xm == ym);
  }

  case FieldDescriptor::TYPE_FIXED32:
  case FieldDescriptor::TYPE_FIXED64:
  case FieldDescriptor::TYPE_SFIXED32:
  case FieldDescriptor::TYPE_SFIXED64:
    panic("unhandled fixed-point protobuf field");

  case FieldDescriptor::TYPE_GROUP:
    panic("unhandled (deprecated) 'group' protobuf field");

  case FieldDescriptor::TYPE_BYTES:
    panic("unhandled 'bytes' protobuf field");

  case FieldDescriptor::TYPE_SINT32:
  case FieldDescriptor::TYPE_SINT64:
    panic("unhandled SInt(32)|(64) protobuf field");
   }

  llvm_unreachable("unhandled protobuf::Message f type");
}

int tesla::ArgIndex(const Argument& A) {
  switch (A.type()) {
  case Argument::Any:
  case Argument::Constant:
    return -1;

  case Argument::Variable:
  case Argument::Field:
  case Argument::Indirect:
    return A.index();
  }
}

std::string tesla::BaseName(const Argument& A) {
  switch (A.type()) {
  case Argument::Any:
  case Argument::Constant:
    assert(false && "called BaseName() on a non-variable Argument");

  case Argument::Variable:
    return A.name();

  case Argument::Indirect:
    return BaseName(A.indirection());

  case Argument::Field:
    return BaseName(A.field().base());
  }
}
