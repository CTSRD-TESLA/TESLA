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

#include <tesla-macros.h>

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
	 * CHECK: [CALE] main
	 * CHECK: new    [[INST0:[0-9]+]]: [[INIT:1:0x0]]
	 * CHECK:   ('[[NAME:.*]]')
	 */

	int i = 4;
	int *ip = &i;

	struct something s;
	s.i = i;

	struct something *sp = &s;


	/*
	 * Then we call foo():
	 *
	 * CHECK: [RETE] foo
	 * CHECK: clone  [[INST0]]:[[INIT]] -> [[INST1:[0-9]+]]:[[FOO:[0-9]+:0x7]]
	 */

	assert(foo(i, ip, sp) == 0);

	/*
	 * Then we hit the NOW event:
	 *
	 * CHECK: [ASRT]
	 * CHECK: update [[INST1]]: [[FOO]]->[[NOW:[0-9]+:0x7]]
	 */
	TESLA_WITHIN(main, previously(foo(i, ip, sp) == 0));

	/*
	 * And finally we leave main():
	 *
	 * CHECK: [RETE] main
	 *
	 * CHECK: update [[INST0]]: [[INIT]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[NAME]]': [[INST0]]
	 *
	 * CHECK: update [[INST1]]: [[NOW]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[NAME]]': [[INST1]]
	 *
	 * CHECK: tesla_class_reset [[NAME]]
	 */

	return 0;
}

