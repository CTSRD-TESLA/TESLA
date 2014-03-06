; @file callee.ll   Tests instrumentation of function calls (callee context).
;
; Copyright (c) 2013 Jonathan Anderson
; All rights reserved.
;
; This software was developed by SRI International and the University of
; Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
; ("CTSRD"), as part of the DARPA CRASH research programme.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions
; are met:
; 1. Redistributions of source code must retain the above copyright
;    notice, this list of conditions and the following disclaimer.
; 2. Redistributions in binary form must reproduce the above copyright
;    notice, this list of conditions and the following disclaimer in the
;    documentation and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
; SUCH DAMAGE.
;
; Commands for llvm-lit:
; RUN: tesla instrument -S -tesla-manifest %p/tesla.manifest %s -o %t
; RUN: %filecheck -input-file=%t %s


; The 'example_syscall' function is supposed to be instrumented in the
; callee context, on both entry and exit.
; CHECK: define i32 @example_syscall
define i32 @example_syscall(i32* %cred, i32 %index, i32 %op) {
entry:
  ; CHECK: call void @__tesla_instrumentation_callee_enter_example_syscall
  ; CHECK: call void @__tesla_instrumentation_callee_return_example_syscall
  ret i32 0
}


; This function should only be instrumented on entry.
; CHECK: define void @void_helper
define void @void_helper(i32 %foo) {
entry:
  ; CHECK: call void @__tesla_instrumentation_callee_enter_void_helper
  ; CHECK-NOT: call void @__tesla_instrumentation_callee_return_void_helper
  ret void
}


; This function should only be instrumented on exit.
; CHECK: define void @void_helper
define void @void_helper2(i32 %foo) {
entry:
  ; CHECK-NOT: call void @__tesla_instrumentation_callee_enter_void_helper2
  ; CHECK: call void @__tesla_instrumentation_callee_return_void_helper2
  ret void

  ; Make sure we instrument *every* return.
  ; CHECK: call void @__tesla_instrumentation_callee_return_void_helper2
  ret void
}


; This one should only be instrumented on exit.
; CHECK: define i32 @some_helper
define i32 @some_helper(i32 %foo) {
entry:
  ; CHECK-NOT: call void @__tesla_instrumentation_callee_enter_some_helper
  ; CHECK: call void @__tesla_instrumentation_callee_return_some_helper
  ret i32 0
}


; This function isn't mentioned at all in the manifest, so TESLA shouldn't
; instrument its entry or exit.
; CHECK: define i32 @some_other_function
define i32 @some_other_function() {
entry:
  ; CHECK-NOT: call void @__tesla_instrumentation
  ret i32 0
}



; Callee instrumentation should be defined in this file:

; i32 some_helper(): return only
; CHECK-NOT: define void @__tesla_instrumentation_callee_enter_some_helper(i32

; CHECK: define void @__tesla_instrumentation_callee_return_some_helper(i32
; there should be at least one call to tesla_update_state():
; CHECK: call void @tesla_update_state

; CHECK-NOT: define void @__tesla_instrumentation_callee_enter_some_helper(i32


; void void_helper(): entry only
; CHECK-NOT: define void @__tesla_instrumentation_callee_return_void_helper(

; CHECK: define void @__tesla_instrumentation_callee_enter_void_helper(
; there should be at least one call to tesla_update_state():
; CHECK: call void @tesla_update_state

; CHECK-NOT: define void @__tesla_instrumentation_callee_return_void_helper(

