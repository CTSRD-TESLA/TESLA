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
open Foreign

(* TODO: link tesla.cmxa to avoid this *)
let from = Dl.dlopen ~filename:"libtesla.so" ~flags:[]

let define m name fn =
  let n = string_of_fn ~name fn in
  Printf.eprintf "X %s <- %s;\n%!" m n;
  foreign ~from name fn

exception Tesla_error of int32
let check fn a =
  match fn a with
  | 0l -> ()
  | err -> raise (Tesla_error err)

module Store = struct
  type t = unit ptr option
  let t : t typ = ptr_opt void

  let get =
    define "Store" "tesla_store_get" 
      (int @-> uint32_t @-> uint32_t @-> ptr t @-> (returning int32_t))

  let null () = allocate t None
end

module Class = struct
  type t = unit ptr option
  let t : t typ = ptr_opt void

  let null () = allocate t None

  (** a client-generated handle (a small integer, used as an index into an array) *)
  type id = Unsigned.uint32
  let id = uint32_t

  let get = define "Class" "tesla_class_get" 
      (Store.t @-> uint32_t @-> ptr t @-> 
         string @-> string @-> (returning int32_t))

  let put = define "Class" "tesla_class_put"
      (t @-> (returning void))
end

module Transition = struct
  type t
  let t : t structure typ = structure "tesla_transition"
  let t_from      = t *:* uint32_t
  let t_from_mask = t *:* uint32_t
  let t_to        = t *:* uint32_t
  let t_to_mask   = t *:* uint32_t
  let t_flags     = t *:* int
  let () = seal t

  (* Masks for transitions *)
  let mask_init = 0x02
  let mask_cleanup = 0x04
end

module Transitions = struct
  type t
  let t : t structure typ = structure "tesla_transitions"
  let t_length = t *:* uint32_t
  let t_ptr = t *:* ptr t (* TODO array not ptr *)
  let () = seal t
end

module Key = struct
  type t
  type key = Unsigned.UInt64.t (* High-level needs to parameterise this *)
  let key : key typ = uint64_t

  (* #define TESLA_KEY_SIZE 4 *)
  let key_size = 4

  let t : t structure typ = structure "tesla_key"
  let t_keys = t *:* (array key_size key)
  let t_mask = t *:* uint32_t
  let () = seal t
end

let update_state =
  define "State" "tesla_update_state" 
    (int @-> uint32_t @-> ptr Key.t @-> string @-> string @->
       ptr Transitions.t @-> returning void )
