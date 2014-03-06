; ModuleID = 'missing-exit-instr.c'
;
; RUN: tesla instrument -S -tesla-manifest %p/Inputs/missing-exit.tesla %s -o %t.instr.ll
; RUN: %filecheck -input-file %t.instr.ll %s


define void @worker(i32 %index) {
entry:
  ; CHECK: call void @__tesla_instrumentation_callee_enter_worker(
  ; CHECK: call void @__tesla_instrumentation_callee_return_worker(
  ret void
}

