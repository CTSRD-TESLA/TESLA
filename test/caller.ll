; @file callee.ll   Tests instrumentation of function calls (caller context).
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
; XFAIL: *

%struct.DES_ks = type { [16 x %union.anon] }
%union.anon = type { [2 x i32] }

; CHECK: define i32 @crypto_setup
define i32 @crypto_setup([8 x i8]* %key, %struct.DES_ks* %schedule) {
entry:
  %key.addr = alloca [8 x i8]*, align 8
  %schedule.addr = alloca %struct.DES_ks*, align 8
  store [8 x i8]* %key, [8 x i8]** %key.addr, align 8
  store %struct.DES_ks* %schedule, %struct.DES_ks** %schedule.addr, align 8
  %0 = load [8 x i8]** %key.addr, align 8
  %1 = load %struct.DES_ks** %schedule.addr, align 8

  ; The 'DES_set_key' function should only be instrumented on exit.
  ; CHECK-NOT: call void @__tesla_instrumentation_caller_enter_DES_set_key
  %call = call i32 @DES_set_key([8 x i8]* %0, %struct.DES_ks* %1)
  ; CHECK: call void @__tesla_instrumentation_caller_return_DES_set_key

  ret i32 0
}

; CHECK: declare i32 @DES_set_key
declare i32 @DES_set_key([8 x i8]*, %struct.DES_ks*) #1



; We should define the caller-side instrumentation for functions that we call
; in this module. This instrumentation should have private linkage.

; CHECK-NOT: define{{.*}} void @__tesla_instrumentation_caller_enter_DES_set_key
; CHECK: define private void @__tesla_instrumentation_caller_return_DES_set_key
; CHECK: call void @tesla_update_state
; CHECK-NOT: define{{.*}} void @__tesla_instrumentation_caller_enter_DES_set_key

