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

(** Direct bindings to [libtesla] functions.
    Intended to be used from the [Tesla] module rather than directly.
*)

(** Exception that matches [tesla_err_t] error code *)
exception Tesla_error of int32

(** Check the return code is [TESLA_SUCCESS], and raise a
    {!Tesla_error} if it is non-zero. *)
val check : ('a -> int32) -> 'a -> unit

open Ctypes

(** A storage container for one or more {!Class.t} values.
    There may be one [tesla_store] for each thread (for storing 
    thread-local automata) plus a single global [tesla_store]. *)
module Store : sig
  type t
  val t : t typ

  (** Retrieve the [tesla_store] for a context (e.g., a thread).
      If the [tesla_store] does not exist yet, it will be created. *)
  val get : int -> Unsigned.uint32 -> Unsigned.uint32 -> t ptr -> int32

  (** Allocate a null pointer to a store, suitable for passing into
      a function that mutates the pointer to point to a store. *)
  val null : unit -> t ptr
end

(** A description of a TESLA automaton, which may be instantiated a
    number of times with different names and current states. *)
module Class : sig
  type t
  val t : t typ

  (** A client-generated handle (a small integer, used as an index
      into an array internally to libtesla. *)
  type id = Unsigned.uint32
  val id : id typ

  (** Retrieve (or create) a {!t} from a {!Store.t}.
      Once the caller is done with the [tesla_class], {!put}
      must be called to release the lock. *)
  val get : Store.t -> id -> t ptr -> string -> string -> int32

  (** Release the resources that were associated with the {!t}
      that was retrieved via {!get}. *)
  val put : t -> unit

  (** Allocate a null pointer to a {!t}, suitable for passing into
      a function that mutates the pointer to point to a class. *)
  val null : unit -> t ptr
end

(** A single allowable transition in a TESLA automaton. *)
module Transition : sig
  type t

  val t : t structure typ

  (** The state we are moving from. *)
  val t_from : (Class.id, t structure) field

  (** The mask of the state we're moving from. *)
  val t_from_mask : (Class.id, t structure) field

  (** The state we are moving to. *)
  val t_to : (Class.id, t structure) field

  (** A mask of the keys that the 'to' state should have set. *)
  val t_to_mask : (Class.id, t structure) field

  (** Things that may need to be done on this transition.
      See the {!mask_init} and {!mask_cleanup} values. *)
  val t_flags : (int, t structure) Ctypes.field

  (** May need to initialize the class *)
  val mask_init : int

  (** Clean up the class immediately *)
  val mask_cleanup : int
end

(** A set of permissible state transitions for an automata instance.
    An automaton must take exactly one of these transitions. *)
module Transitions : sig
  type t

  val t : t structure typ
  val t_length : (Class.id, t structure) field
  val t_ptr : (t structure ptr, t structure) field
end

(** A TESLA instance can be identified by a [tesla_class] and a
    [tesla_key]. This key represents the values of event parameters
    (e.g. a credential passed to a security check), some of which
    may not be specified.

    Clients can use [tesla_key] to look up sets of automata instances,
    using the bitmask to specify don't-care parameters.

    Keys can hold arbitrary integers/pointers. *)
module Key : sig
  type t
  type key = Unsigned.uint64
  val key : key typ

  (** The [key_size] is the same as the [TESLA_KEY_SIZE] define
      in [tesla.h] (currently 4) *)
  val key_size : int

  val t : t structure typ
  val t_keys : (key array, t structure) field
  val t_mask : (Class.id, t structure) field
end

(** Update all automata instances that match a given key to a
    new state. *)
val update_state :
  int ->
  Class.id ->
  Key.t structure ptr ->
  string -> string -> Transitions.t structure ptr -> unit

