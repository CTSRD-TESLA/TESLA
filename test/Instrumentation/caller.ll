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
; RUN: tesla instrument -S -tesla-manifest tesla.manifest %s | FileCheck %s

%struct.object = type { i32 }



; CHECK: define i32 @example_syscall
define i32 @example_syscall(i32 %op) #0 {
entry:
  %o = alloca %struct.object*, align 8
  %op.addr = alloca i32, align 4
  store i32 %op, i32* %op.addr, align 4

  %0 = load i32* %op.addr, align 4

  ; The 'some_helper' function should only be instrumented on exit.
  ; CHECK-NOT: call void @__tesla_instrumentation_caller_enter_some_helper
  %call5 = call i32 @some_helper(i32 %0)
  ; CHECK: call void @__tesla_instrumentation_caller_return_some_helper

  %1 = load %struct.object** %o, align 8

  ; The 'void_helper' function should only be instrumenter on entry.
  ; CHECK: call void @__tesla_instrumentation_caller_enter_void_helper
  call void @void_helper(%struct.object* %1)
  ; CHECK-NOT: call void @__tesla_instrumentation_caller_return_void_helper

  ret i32 0
}

; CHECK: declare i32 @some_helper
declare i32 @some_helper(i32) #1

; CHECK: declare void @void_helper
declare void @void_helper(%struct.object*) #1

