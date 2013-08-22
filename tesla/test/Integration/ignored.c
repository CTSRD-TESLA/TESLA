//! @file Integration/ignored.c  Tests ignoring of out-of-scope events.
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

void foo(void) {}
void bar(void)
{
	foo();

	TESLA_WITHIN(bar,
		TSEQUENCE(
			call(foo),
			TESLA_ASSERTION_SITE,
			call(foo)
		)
	);

	foo();
}

int
main(int argc, char *argv[])
{
	/*
	 * This call to foo(), which is out of bar()'s scope, should be ignored:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class: '[[NAME:/.*ignored.c:[0-9]+#[0-9]+]]'
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK-NOT: update
	 * CHECK: ignore '[[NAME]]'
	 * CHECK-NOT: update
	 * CHECK: ----
	 * CHECK: ====
	 */
	foo();

	return 0;
}

