(*-
 * Copyright (c) 2013 Anil Madhavapeddy <anil@recoil.org>
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
 *
*)

(** High-level bindings to [libtesla] that expose a more OCaml-like
    interface to constructing automata. *)

(** Error codes from [libtesla] *)
type err =
  | ENOENT  (** Entry not found. *)
  | ENOMEM  (** Insufficient memory. *)
  | EINVAL  (** Invalid parameters. *)
  | UNKNOWN (** An unknown (e.g. platform) error. *)

(** Exception raised by functions in this module *)
exception Error of err

(** Provide a human-readable version of TESLA errors. *)
val err_to_string : err -> string

(** A context where TESLA data is stored.
  
    TESLA data can be stored in a number of places that imply different
    synchronisation requirements. For instance, thread-local storage does not
    require synchronisation on access, whereas global storage does.
    On the other hand, thread-local storage cannot be used to track events
    across multiple threads. 
*)
type ctx =
  | Global   (** The single global context *)
  | Thread   (** A per-thread context *)

(** A storage container for one or more {!Class.t} values.
    There may be one {!Store.t} for each thread (for storing 
    thread-local automata) plus a single global {!Store.t} that
    is retrieved using [Global]. *)
module Store : sig
  type t

  (** Retrieve the {!t} for a context (e.g., a thread).
      If the {!t} does not exist yet, it will be created. *)
  val get : ctx:ctx -> size:int -> instances:int -> t 

  (** Retrieve the maximum size that this {!t} was created with. *)
  val size : t -> int

  (** Retrieve the maximum number of instances that this {!t} was
      initialized to support. *)
  val instances : t -> int
end

(** A description of a TESLA automaton, which may be instantiated a
    number of times with different names and current states. *)
module Class : sig

  type t

  (** A client-generated handle (a small integer, used as an index
      into an array internal to libtesla. *)
  type id = int

  (** Retrieve (or create) a {!t} from a {!Store.t}.
      Once the caller is done with the {!Class.t}, {!put}
      must be called to release the lock.
      See {!with_class} for a wrapper that enforces this protocol. *)
  val get : store:Store.t -> id:id -> name:string -> descr:string -> t
  
  (** Release the resources that were associated with the {!t}
      that was retrieved via {!get}. *)
  val put : t -> unit
end

(** Retrieve a {!Class.t} with the given [id] and apply [f] on it.
    The class will always be released when [f] terminates, even if
    [f] raises an exception. However, [f] should not attempt to
    retrieve the same class name in the same thread or global context,
    or the function will deadlock. *)
val with_class :
   store:Store.t -> id:Class.id -> name:string -> descr:string ->
   f:(Class.t -> 'a) -> 'a

