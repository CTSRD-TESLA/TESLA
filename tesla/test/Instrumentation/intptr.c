//! @file intptr.c  Tests int-to-pointer conversion for instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
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
	 * CHECK: context:      per-thread
	 * CHECK: class:        0 ('[[NAME:.*]]')
	 * CHECK: transitions:  [ (0:0x0 -> [[INIT:[0-9]+]] <init>) ]
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ----
	 * CHECK: new [[AUTOMATON_ID:[0-9]]]: [[INIT]]
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
	 * CHECK: ([[INIT]]:0x0 -> [[FOO:[0-9]+]])
	 * CHECK: key:          0x7 [ 4 [[IP:[0-9a-f]+]] [[SP:[0-9a-f]+]] X ]
	 * CHECK: ----
	 * CHECK: clone [[AUTOMATON_ID]]:[[INIT]] -> [[CLONE:[0-9]+]]
	 * CHECK: ====
	 */

	assert(foo(i, ip, sp) == 0);

	/*
	 * Then we hit the NOW event:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK: ([[FOO]]:0x7 -> [[NOW:[0-9]+]])
	 * CHECK: key:          0x7 [ 4 [[IP]] [[SP]] X ]
	 * CHECK: ----
	 * TODO: make a clone output the new automaton's ID
	 * CHECK: update {{[0-9]+}}: [[FOO]]->[[NOW]]
	 * CHECK: ====
	 */
	TESLA_WITHIN(main, previously(foo(i, ip, sp) == 0));

	/*
	 * And finally we leave main():
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state()
	 * CHECK: transitions:  [ ([[NOW]]:0x7 -> [[FINAL:[0-9]+]] <clean>) ]
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ----
	 * TODO: look for 'update'; currently we do 'clone'!
	 * CHECKx: update {{[0-9]+}}: [[NOW]]->[[FINAL]]
	 * CHECK: pass '[[NAME]]': 1
	 * CHECK: tesla_class_reset
	 * CHECK: ====
	 */

	return 0;
}

