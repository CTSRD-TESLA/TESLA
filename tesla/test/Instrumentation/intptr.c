//! @file intptr.c  Tests int-to-pointer conversion for instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %cflags %ldflags %t.instr.ll -o %t
 * RUN: %t > %t.out
 * RUN: FileCheck -input-file %t.out %s
 */

#include "tesla-macros.h"

#include <assert.h>

struct something
{
	int i;
};

static int
foo(int x, int *xp, struct something *sp)
{
	assert(*xp == x);
	assert(sp->i == x);
	return 0;
}

int
main(int argc, char *argv[])
{
	/*
	 * First we enter main():
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK: transitions:  [ (0:0x0 -> 1 <init>) ]
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ====
	 */

	int i = 4;
	int *ip = &i;

	struct something s;
	s.i = i;

	struct something *sp = &s;


	/*
	 * Then we call foo():
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK: transitions:  [ (1:0x0 -> 2) ]
	 * CHECK: key:          0x7 [ 4 [[IP:[0-9a-f]+]] [[SP:[0-9a-f]+]] X ]
	 * CHECK: ====
	 */

	assert(foo(i, ip, sp) == 0);

	/*
	 * Then we hit the NOW event:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK: transitions:  [ (2:0x7 -> 3) ]
	 * CHECK: key:          0x7 [ 4 [[IP]] [[SP]] X ]
	 * CHECK: ====
	 */
	TESLA_WITHIN(main, previously(foo(i, ip, sp) == 0));

	/*
	 * And finally we leave main():
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK: transitions:  [ (3:0x7 -> 4 <clean>) ]
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ====
	 */

	return 0;
}

