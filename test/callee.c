//! @file callee.c  Tests callee-context function instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: %filecheck -input-file %t.instr.ll %s
 *
 * XFAIL: *
 */

#include <tesla-macros.h>

void	foo(void);
void	bar(void);

int
main(int argc, char *argv[])
{
	// CHECK: define [[INT:i[3264]+]] @main([[INT]] %argc, i8** %argv)
	// CHECK: call void @__tesla_instrumentation_callee_enter_main([[INT]] %argc, i8** %argv)

	// An assertion that refers to calling foo() and returning from bar():
	TESLA_PERTHREAD(call(main), returnfrom(main),
		TSEQUENCE(
			callee(call(foo)),
			callee(returnfrom(bar)),
			TESLA_ASSERTION_SITE
		)
	);

	// CHECK-NOT: call void @__tesla_instrumentation_caller_enter_foo
	foo();
	// CHECK-NOT: call void @__tesla_instrumentation_caller_return_foo

	// CHECK-NOT: call void @__tesla_instrumentation_caller_enter_bar
	bar();
	// CHECK-NOT: call void @__tesla_instrumentation_caller_return_bar

	return 0;
}


// CHECK: define void @foo()
void
foo()
{
	/*
	 * We ought to generate instrumentation for entry but not return:
	 *
	 * CHECK: call void @__tesla_instrumentation_callee_enter_foo
	 * CHECK-NOT: call void @__tesla_instrumentation_callee_return_foo
	 */
}

// CHECK: define void @bar()
void
bar()
{
	/*
	 * We ought to generate instrumentation for return but not entry:
	 *
	 * CHECK-NOT: call void @__tesla_instrumentation_callee_enter_bar
	 * CHECK: call void @__tesla_instrumentation_callee_return_bar
	 */
}

