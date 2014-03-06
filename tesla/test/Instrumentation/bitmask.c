/**
 * @file bitmask.c
 * Check instrumentation of function calls with flags combined in a bitmask.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang %cflags -emit-llvm -S -o %t.ll %s
 * RUN: tesla instrument -S -tesla-manifest %t.tesla -o %t.instr.ll %t.ll
 * RUN: %filecheck -input-file=%t.instr.ll %s
 */

#include <tesla-macros.h>

int	foo(int);

#define	FOO	0x1
#define	BAR	0x2
#define	BAZ	0x4

void context() {
	foo(FOO | BAR | BAZ);
	foo(FOO);

	TESLA_WITHIN(context,
		previously(
			foo(flags(FOO | BAR)) == 0,
			foo(bitmask(FOO | BAZ)) == 0
		)

	);
}

/*
 * CHECK: define void @__tesla_instr{{.*}}_return_foo(i32, i32) {
 *
 * TODO: when we move to LLVM 3.4 we should use CHECK-DAG for the following,
 *       since the order of the two blocks isn't important.
 *
 * We need to check the first argument against PI:
 * CHECK:   "[[NAME:.*bitmask.c:[0-9]+#[0-9]+]]:match:0
 * CHECK:     [[AND:%[a-z0-9]+]] = and i32 %0, 3
 * CHECK:     [[COND:%[a-z0-9]+]] = icmp eq i32 [[AND]], 3
 * CHECK:     br i1 [[COND]], label %"[[NAME]]:match:1
 * CHECK:   "[[NAME]]:instr":
 *
 * CHECK:   "[[NAME:.*bitmask.c:[0-9]+#[0-9]+]]:match:0
 * CHECK:     [[AND:%[a-z0-9]+]] = and i32 %0, 5
 * CHECK:     [[COND:%[a-z0-9]+]] = icmp eq i32 [[AND]], %0
 * CHECK:     br i1 [[COND]], label %"[[NAME]]:match:1
 * CHECK:   "[[NAME]]:instr{{[0-9]+}}":
 *
 * CHECK: }
 */
int
foo(int x)
{
	return 0;
}
