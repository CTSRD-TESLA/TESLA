//! @file caller.c  Tests caller-context function instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: FileCheck -input-file %t.instr.ll %s
 */

#include "tesla-macros.h"

void	foo(void);
void	bar(void);

int
main(int argc, char *argv[])
{
	// CHECK: define [[INT:i[3264]+]] @main([[INT]] %argc, i8** %argv)
	// CHECK: call void @__tesla_instrumentation_callee_enter_main([[INT]] %argc, i8** %argv)

	// Make an assertion about calling foo() and returning from bar():
	TESLA_PERTHREAD(since(called(main),
		TSEQUENCE(
			caller(called(foo)),
			caller(returned(bar))
		)
	));

	// We should instrument foo's call but not the return:
	// CHECK: call void @__tesla_instrumentation_caller_enter_foo
	foo();
	// CHECK-NOT: call void @__tesla_instrumentation_caller_return_foo

	// We should instrument bar's return but not the call:
	// CHECK-NOT: call void @__tesla_instrumentation_caller_enter_bar
	bar();
	// CHECK: call void @__tesla_instrumentation_caller_return_bar

	return 0;
}


// CHECK: define void @foo()
void
foo()
{
	/*
	 * We shouldn't generate any callee-context instrumentation:
	 *
	 * CHECK-NOT: call void @__tesla_instrumentation_callee_enter_foo
	 * CHECK-NOT: call void @__tesla_instrumentation_callee_return_foo
	 */
}

// CHECK: define void @bar()
void
bar()
{
	/*
	 * We shouldn't generate any callee-context instrumentation:
	 *
	 * CHECK-NOT: call void @__tesla_instrumentation_callee_enter_bar
	 * CHECK-NOT: call void @__tesla_instrumentation_callee_return_bar
	 */
}

