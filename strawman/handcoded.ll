; This file provides some LLVM IR that we can instrument directly, without
; Clang ever getting involved.
;
; Writing raw IR like this allows us to construct pathological cases for
; testing purposes Clang doesn't always produce.

define i32 @some_helper(i32 %op) {
  %1 = icmp slt i32 %op, 10
  br i1 %1, label %2, label %3

; this is label %2
  ret i32 0

; this is label %3
  ret i32 1
}
