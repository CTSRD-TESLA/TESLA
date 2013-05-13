/*! @file static.c    Tests instrumentation of static functions. */
/*
 * Commands for llvm-lit:
 * RUN: mkdir -p %t
 * RUN: clang -S -emit-llvm %cflags %s -o %t/main.ll
 * RUN: tesla analyse %s -o %t/tesla -- %cflags
 * RUN: tesla instrument -S -tesla-manifest %t/tesla %t/main.ll -o %t/instr.ll
 * RUN: FileCheck -input-file %t/instr.ll %s
 */

#include "tesla-macros.h"

static void
foo()
{
	/*
	 * CHECK: define internal void @foo()
	 * CHECK: call void @__tesla_instrumentation_callee_enter_foo
	 */
}


int
main(int argc, char *argv[])
{
	TESLA_WITHIN(main, eventually(called(foo)));

	foo();

	return 0;
}
