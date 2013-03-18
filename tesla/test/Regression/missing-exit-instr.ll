; ModuleID = 'missing-exit-instr.c'
;
; RUN: tesla instrument -S -tesla-manifest %p/Inputs/missing-exit.tesla %s -o %t.instr.ll
; RUN: FileCheck -input-file %t.instr.ll %s
; XFAIL: *


define void @worker(i32 %index) {
entry:
  ; CHECK: call void @__tesla_instrumentation_callee_enter_worker(
  ; CHECK: call void @__tesla_instrumentation_callee_exit_worker(
  ret void
}

