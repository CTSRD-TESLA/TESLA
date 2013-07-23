/**
 * @file field-lookup.c
 * Check instrumentation using a struct field argument.
 *
 * RUN: clang %cflags% -c -emit-llvm -S %s -o %t.ll
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla instrument -S %t.ll -tesla-manifest %t.tesla -o %t.instr.ll
 * RUN: FileCheck -input-file=%t.instr.ll %s
 */

#include "tesla-macros.h"

struct object { struct object *child; };

void	context(void);
int	do_something(struct object*);

void foo(struct object *op) {
	struct object o;

	/*
	 */
	TESLA_WITHIN(context,
		TSEQUENCE(
			TESLA_ASSERTION_SITE,

#if NOTYET
			do_something(o.child->child) == 0,
#endif

			/*
			 * CHECK: [[CHILD0:%[a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.object* %0
			 * CHECK: [[CHILD1:%[a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.object* [[CHILD0]]
			 * CHECK: [[CHILD2:%[a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.object* [[CHILD1]]
			 * CHECK: [[VAL:%[0-9]+]] = ptrtoint %struct.object* [[CHILD2]] to i64
			 * CHECK: [[KEY:%[0-9]+]] = getelementptr inbounds %tesla_key* %key, i32 0, i32 0
			 * CHECK: store i64 [[VAL]], i64* [[KEY]]
			 * CHECK: [[MASK:%[0-9]+]] = getelementptr inbounds %tesla_key* %key, i32 0, i32 {{[0-9]+}}
			 * CHECK: store i32 1, i32* [[MASK]]
			 */
			do_something(op->child->child->child) == 0
		)
	);
}
