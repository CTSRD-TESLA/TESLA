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

struct obj1;
struct obj2;

struct obj1 {
	struct obj2 *child_of_1;
};

struct obj2 {
	struct obj1 *child_of_2;
	int value;
};

void	context(void);
int	do_something(struct obj1*, int);

void foo(struct obj1 *op) {
	/*
	 */
	TESLA_WITHIN(context,
		eventually(
/*
 * TODO: use CHECK-DAG once we switch to LLVM 3.4:
 *
 * First, we need to look up op->child_of_1->child_of_2:
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj1* %0
 * CHECK: [[C:%[_a-zA-Z0-9\.]+]] = load %struct.obj2** [[PTR]]
 *
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj2* [[C]]
 * CHECK: [[CHILD:%[_a-zA-Z0-9\.]+]] = load %struct.obj1** [[PTR]]
 *
 * Next, we look up op->child_of_1->value:
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj1* %1
 * CHECK: [[C:%[_a-zA-Z0-9\.]+]] = load %struct.obj2** [[PTR]]
 *
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj2* [[C]]
 * CHECK: [[VALUE:%[_a-zA-Z0-9\.]+]] = load i32* [[PTR]]
 *
 * Then we use them in a tesla_key:
 * CHECK: [[KEY:%[_a-zA-Z0-9\.]+]] = alloca %tesla_key
 *
 * CHECK: [[CHILD_CAST:%[_a-zA-Z0-9\.]+]] = ptrtoint %struct.obj1* [[CHILD]]
 * CHECK: [[CHILD_KEY:%[_a-zA-Z0-9\.]+]] = getelementptr {{.*}} [[KEY]]
 * CHECK: store [[INT:i[3264]+]] [[CHILD_CAST]], [[INT]]* [[CHILD_KEY]]
 *
 * CHECK: [[VALUE_CAST:%[_a-zA-Z0-9\.]+]] = zext {{.*}} [[VALUE]]
 * CHECK: [[VALUE_KEY:%[_a-zA-Z0-9\.]+]] = getelementptr {{.*}} [[KEY]]
 * CHECK: store [[INT]] [[VALUE_CAST]], [[INT]]* [[VALUE_KEY]]
 *
 * CHECK: call void @tesla_update_state({{.*}} [[KEY]]
 */
			do_something(
				op->child_of_1->child_of_2,
				op->child_of_1->value) == 0
		)
	);
}
