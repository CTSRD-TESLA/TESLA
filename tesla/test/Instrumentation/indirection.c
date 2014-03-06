/**
 * @file indirection.c
 * Check instrumentation of values passed or returned indirectly, via pointer.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang %cflags -emit-llvm -S -o %t.ll %s
 * RUN: tesla instrument -S -tesla-manifest %t.tesla -o %t.instr.ll %t.ll
 * RUN: %filecheck -input-file=%t.instr.ll %s
 */

#include <tesla-macros.h>

/*
 * TODO: use CHECK-DAG when we move to LLVM 3.4
 *
 * CHECK: [[TRANS_ARRAY:.*]] = private constant [2 x %tesla_transition]
 * CHECK:     [%tesla_transition { i32 1, i32 0, i32 2, i32 1, i32 0 },
 * CHECK:      %tesla_transition { i32 2, i32 1, i32 2, i32 1, i32 0 }]
 */

struct object;

void	context(void);
int	get_object(struct object* *obj_out);

void foo(struct object *o) {
	TESLA_WITHIN(context, previously(get_object(&o) == 0));
}

/*
 * CHECK: define void @__tesla_{{.*}}_return_get_object(%struct.object**, i32) {
 */
int
get_object(struct object* *obj_out)
{
	/*
	 * We should be using the value pointed at by the first argument as
	 * a key value:
	 *
	 * CHECK:   [[KEY:%[0-9a-zA-Z_]+]] = alloca %tesla_key
	 * CHECK:   [[KEY0:%[0-9a-zA-Z_]+]] = getelementptr
	 * CHECK:     %tesla_key* [[KEY]], i32 0, i32 0
	 *
	 * CHECK:   [[MASK:%[0-9a-zA-Z_]+]] = getelementptr
	 * CHECK:     %tesla_key* [[KEY]], i32 0, i32 4
	 * CHECK:   store i32 1, i32* [[MASK]]
	 *
	 * CHECK:   call void @tesla_update_state({{.*}}, %tesla_key* %key
	 */
	return 0;
}
/*
 * CHECK: }
 */
