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

(** Run tests using the low-level {!Tesla_internal} module. *)

open Printf
open Ctypes
open Foreign
open Tesla_internal

let make_store ?(sizes=10) ?(instances=10) () =
  let store_ptr = Store.null () in
  (* printf "store_ptr=  %s\n%!" (string_of (ptr Store.t) store_ptr);
  printf "*store_ptr= %s\n%!" (string_of Store.t (!@ store_ptr)); *)
  let sizes = Unsigned.UInt32.of_int sizes in
  let instances = Unsigned.UInt32.of_int instances in
  check (Store.get 0 sizes instances) store_ptr;
  (* printf "*store_ptr= %s\n%!" (string_of Store.t (!@ store_ptr)); *)
  !@ store_ptr

let make_class () =
  let store = make_store () in
  let class_ptr = Class.null () in
  let id = Unsigned.UInt32.of_int 1 in
  check (Class.get store id class_ptr "cname") "cdesc";
  let cl = !@ class_ptr in
  Class.put cl

let repeat name fn =
  printf "%s: %!" name;
  for i = 0 to 5 do 
    printf ".%!";
    fn ();
    printf "-%!";
    Gc.compact ()
  done;
  printf "\n%!"

let () = repeat "make_store" make_store
let () = repeat "make_class" make_class
