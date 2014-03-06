//! @file caller.c  Tests caller-context function instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -suppress-debug-instrumentation -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: %filecheck -input-file %t.instr.ll %s
 */

#include <tesla-macros.h>

void	foo(void);

int
main(int argc, char *argv[])
{
	TESLA_WITHIN(main, eventually(call(foo)));
	return 0;
}


// CHECK: define void @__tesla_instrumentation_callee_enter_foo()
void
foo()
{
	/*
	 * We shouldn't generate any printfs:
	 *
	 * CHECK-NOT: printf
	 */
}
