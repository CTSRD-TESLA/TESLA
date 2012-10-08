/*! @file Manifest.h  Contains the declaration of @ref Manifest. */
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

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/OwningPtr.h"
#include "llvm/ADT/StringRef.h"

#include <vector>

namespace llvm {
  class raw_ostream;
}

namespace tesla {

class Automaton;
class Event;
class FunctionEvent;

/// A description of TESLA instrumentation to perform.
class Manifest {
public:
  //! Returns a copy of all function events named in this manifest.
  std::vector<FunctionEvent> FunctionsToInstrument();

  //! Load a @ref Manifest from a named file.
  static Manifest* load(llvm::raw_ostream& Err,
                        llvm::StringRef Path = defaultLocation());

  /*!
   * The default location to look for a TESLA manifest.
   *
   * This could be specified by a command-line option.
   */
  static llvm::StringRef defaultLocation();

private:
  Manifest(llvm::ArrayRef<Automaton*> Automata);

  //! Returns a copy of all events named in this manifest.
  std::vector<Event> Events();

  static const std::string SEP;   //!< Delineates automata in a TESLA file.

  //! Memory to store automata in.
  llvm::OwningArrayPtr<Automaton*> Storage;

  //! Convenience wrapper that provides useful methods.
  llvm::ArrayRef<Automaton*> Automata;
};

}

