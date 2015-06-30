/**
 * @file field-lookup.c
 * Check instrumentation using a struct field argument.
 *
 * RUN: clang %cflags% -c -emit-llvm -S %s -o %t.ll
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla instrument -S %t.ll -tesla-manifest %t.tesla -o %t.instr.ll
 * RUN: %filecheck -input-file=%t.instr.ll %s
 *
 * XFAIL: *
 */

#include <tesla-macros.h>

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
	TESLA_WITHIN(context,
/*
 * TODO: use CHECK-DAG once we switch to LLVM 3.4:
 *
 * First, we need to look up op->child_of_1->child_of_2:
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj1* %op
 * CHECK: [[C:%[_a-zA-Z0-9\.]+]] = load %struct.obj2** [[PTR]]
 *
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj2* [[C]]
 * CHECK: [[CHILD:%[_a-zA-Z0-9\.]+]] = load %struct.obj1** [[PTR]]
 *
 * Next, we look up op->child_of_1->value:
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj1* %op
 * CHECK: [[C:%[_a-zA-Z0-9\.]+]] = load %struct.obj2** [[PTR]]
 *
 * CHECK: [[PTR:%[_a-zA-Z0-9\.]+]] = getelementptr inbounds %struct.obj2* [[C]]
 * CHECK: [[VALUE:%[_a-zA-Z0-9\.]+]] = load i32* [[PTR]]
 *
 * CHECK: call void [[INSTR:@.*_tesla_instr.*assert.*]](%struct.obj1* [[CHILD]], [[INT:i[3264]+]] [[VALUE]])
 */
		eventually(
			do_something(
				op->child_of_1->child_of_2,
				op->child_of_1->value) == 0
		)
	);
}

/*
 * CHECK: define internal void [[INSTR]](%struct.obj1*, i32) {
 *
 * CHECK: [[KEY:%[_a-zA-Z0-9\.]+]] = alloca %tesla_key
 *
 * CHECK: [[CHILD:%[_a-zA-Z0-9\.]+]] = ptrtoint {{.*}}* %0 to [[REG_T:i[3264]+]]
 * CHECK: [[CHILD_KEY:%[_a-zA-Z0-9\.]+]] = getelementptr {{.*}} [[KEY]]
 * CHECK: store [[INT:i[3264]+]] [[CHILD]], [[INT]]* [[CHILD_KEY]]
 *
 * CHECK: [[VALUE:%[_a-zA-Z0-9\.]+]] = zext {{.*}} %1 to [[REG_T]]
 * CHECK: [[VALUE_KEY:%[_a-zA-Z0-9\.]+]] = getelementptr {{.*}} [[KEY]]
 * CHECK: store [[INT]] [[VALUE]], [[INT]]* [[VALUE_KEY]]
 *
 * CHECK: call void @tesla_update_state({{.*}} [[KEY]]
 *
 * CHECK: }
 */
