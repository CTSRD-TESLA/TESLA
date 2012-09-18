; ModuleID = 'handcoded.ll'
;
; This file provides some LLVM IR that we can instrument directly, without
; Clang ever getting involved.
;
; Writing raw IR like this allows us to construct pathological cases that
; Clang doesn't always give us because it's so darn clever.

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

define i32 @some_helper(i32 %op) nounwind uwtable ssp {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 %op, i32* %2, align 4
  %3 = load i32* %2, align 4
  %4 = icmp slt i32 %3, 10
  br i1 %4, label %5, label %6

; <label>:5                                       ; preds = %0
  store i32 0, i32* %1
  ret i32 0

; <label>:6                                       ; preds = %0
  store i32 1, i32* %1
  ret i32 1
}
