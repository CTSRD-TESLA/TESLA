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

open Ctypes
open PosixTypes
open Foreign
module I = Tesla_internal

type err =
  | ENOENT
  | ENOMEM
  | EINVAL
  | UNKNOWN

exception Error of err

let ret_to_int32 =
  function
  | ENOENT  -> 1l
  | ENOMEM  -> 2l
  | EINVAL  -> 3l
  | UNKNOWN -> 4l

let ret_of_int32 =
  function
  | 0l -> None
  | 1l -> Some ENOENT
  | 2l -> Some ENOMEM
  | 3l -> Some EINVAL
  | _  -> Some UNKNOWN

let err_to_string =
  function
  | ENOENT  -> "ENOENT(1)"
  | ENOMEM  -> "ENOMEM(2)"
  | EINVAL  -> "EINVAL(3)"
  | UNKNOWN -> "UNKNOWN(4)"

type ctx =
  | Global
  | Thread

let ctx_to_string =
  function
  | Global -> "Global"
  | Thread -> "Thread"

let ctx_to_int =
  function
  | Global -> 0
  | Thread -> 1

let ctx_of_int =
  function
  | 0 -> Some Global
  | 1 -> Some Thread
  | _ -> None
  type t

let check ret =
  match ret_of_int32 ret with
  | None -> ()
  | Some err -> raise (Error err)

module Store = struct 

  type t = {
    store: I.Store.t;
    size: int;
    instances: int;
  }

  let get ~ctx ~size ~instances =
    let ctx = ctx_to_int ctx in
    let store_ptr = I.Store.null () in
    let size' = Unsigned.UInt32.of_int size in
    let instances' = Unsigned.UInt32.of_int instances in
    let ret = I.Store.get ctx size' instances' store_ptr in
    check ret;
    let store = !@ store_ptr in
    { store; size; instances }

  let size t = t.size
  let instances t = t.instances

end

module Class = struct

  type t = I.Class.t

  (** a client-generated handle (a small integer, used as an index into an array) *)
  type id = int

  let get ~store ~id ~name ~descr =
    let cl = I.Class.null () in
    let id = Unsigned.UInt32.of_int id in
    let ret = I.Class.get store.Store.store id cl name descr in
    check ret;
    !@ cl

  let put t = I.Class.put t
end

let with_class ~store ~id ~name ~descr ~f =
  let cl = Class.get ~store ~id ~name ~descr in
  try
    let r = f cl in
    Class.put cl;
    r
  with exn ->
    Class.put cl;
    raise exn
    
let update_state ~ctx ~id ~key ~name ~descr transitions =
  I.update_state (ctx_to_int ctx) id key name descr transitions
