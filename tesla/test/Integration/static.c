//! @file Integration/static.c  Tests instrumentation of static functions.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
 * RUN: FileCheck -input-file %t.out %s
 */

#include <tesla-macros.h>

static void foo(void) {}
static void bar(void) {}

int
main(int argc, char *argv[])
{
	/*
	 * We should update state on entering main():
	 * CHECK: new    [[ID:[0-9]+]]: [[INIT:[0-9]+:0x0]]
	 */


	/*
	 * Update state again on calling foo():
	 * CHECK: update [[ID]]: [[INIT]]->[[FOO:[0-9]+:0x0]]
	 */
	foo();


	/*
	 * Again on calling bar():
	 * CHECK: update [[ID]]: [[FOO]]->[[BAR:[0-9]+:0x0]]
	 */
	bar();


	/*
	 * The NOW event:
	 * CHECK: update [[ID]]: [[BAR]]->[[NOW:[0-9]+:0x0]]
	 */
	TESLA_WITHIN(main,
		TSEQUENCE(
			caller(call(foo)),
			callee(call(bar)),
			TESLA_ASSERTION_SITE
		)
	);

	/*
	 * And finally, on exit:
	 * CHECK: update [[ID]]: [[NOW]]->[[DONE:[0-9]+]]
	 * CHECK: pass '[[NAME:.*]]': [[ID]]
	 * CHECK: tesla_class_reset [[NAME]]
	 */

	return 0;
}

