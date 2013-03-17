; ModuleID = '/Users/jon/Documents/TESLA/tesla/test/Integration/call.c'
; RUN: tesla instrument -S -tesla-manifest %p/Inputs/missing-now.tesla %s -o %t.instr.ll 2> %t.err || true
; RUN: FileCheck -input-file %t.err %s

; Ensure that we output a sensible error message:
; CHECK: TESLA: automaton '{{.*}}' contains no NOW event

%struct.__tesla_locality = type {}

@.str = private unnamed_addr constant [57 x i8] c"/Users/jon/Documents/TESLA/tesla/test/Integration/call.c\00", align 1

define i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval
  %call = call i32 (i32 (i32, i8**)*, ...)* bitcast (i32 (...)* @__tesla_call to i32 (i32 (i32, i8**)*, ...)*)(i32 (i32, i8**)* @main)
  %call1 = call i32 (i32 (i32, i8**)*, ...)* bitcast (i32 (...)* @__tesla_return to i32 (i32 (i32, i8**)*, ...)*)(i32 (i32, i8**)* @main)
  call void (i8*, i32, i32, %struct.__tesla_locality*, ...)* @__tesla_inline_assertion(i8* getelementptr inbounds ([57 x i8]* @.str, i32 0, i32 0), i32 62, i32 0, %struct.__tesla_locality* null, i32 %call, i32 %call1, i32 1)
  ret i32 0
}

declare void @__tesla_inline_assertion(i8*, i32, i32, %struct.__tesla_locality*, ...) #1

declare i32 @__tesla_call(...) #1

declare i32 @__tesla_return(...) #1

attributes #0 = { nounwind ssp uwtable "fp-contract-model"="standard" "no-frame-pointer-elim" "no-frame-pointer-elim-non-leaf" "realign-stack" "relocation-model"="pic" "ssp-buffers-size"="8" }
attributes #1 = { "fp-contract-model"="standard" "no-frame-pointer-elim" "no-frame-pointer-elim-non-leaf" "realign-stack" "relocation-model"="pic" "ssp-buffers-size"="8" }
