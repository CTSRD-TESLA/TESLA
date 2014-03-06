/**
 * @file constant-arg.c
 * Ensure constant arguments to instrumented functions are properly checked.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang %cflags -emit-llvm -S -o %t.ll %s
 * RUN: tesla instrument -S -tesla-manifest %t.tesla -o %t.instr.ll %t.ll
 * RUN: %filecheck -input-file=%t.instr.ll %s
 */

#include <tesla-macros.h>

int	foo(int);

#define	PI	3
#define	ANSWER	42

void context() {
	foo(0);
	TESLA_WITHIN(context, previously(foo(PI) == ANSWER));
}

/*
 * CHECK: define void @__tesla_instr{{.*}}_return_foo(i32, i32) {
 *
 * TODO: when we move to LLVM 3.4 we should use CHECK-DAG for the following,
 *       since the order of the two blocks isn't important.
 *
 * We need to check the first argument against PI:
 * CHECK:   "[[NAME:.*constant-arg.c:[0-9]+#[0-9]+]]:match:0":
 * CHECK:     [[COND:%[0-9]+]] = icmp eq i32 %{{[0-9]+}}, 3
 * CHECK:     br i1 [[COND]], label %"[[NAME]]:match:1"
 *
 * We also need to check that the return value is ANSWER:
 * CHECK:   "[[NAME]]:match:1":
 * CHECK:     [[COND:%[0-9]+]] = icmp eq i32 %{{[0-9]+}}, 42
 * CHECK:     br i1 [[COND]], label %"[[NAME]]:instr"
 *
 * The actual instrumentation:
 * CHECK:   "[[NAME]]:instr":
 *
 * CHECK: }
 */
int
foo(int x)
{
	return 0;
}
