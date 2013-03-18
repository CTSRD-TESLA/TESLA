; ModuleID = 'missing-exit-instr.c'
;
; RUN: tesla instrument -S -tesla-manifest %p/Inputs/missing-exit.tesla %s -o %t.instr.ll
; RUN: FileCheck -input-file %t.instr.ll %s
; XFAIL: *

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"


define void @worker(i32 %index) {
entry:
  ; CHECK: call void @__tesla_instrumentation_callee_enter_worker(
  ; CHECK: call void @__tesla_instrumentation_callee_exit_worker(
  ret void
}

