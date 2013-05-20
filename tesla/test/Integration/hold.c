//! @file hold.c  Tests instrumentation of 'hold' event.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
 * RUN: FileCheck -input-file %t.out %s
 */

#include <errno.h>
#include <stddef.h>

#include "tesla-macros.h"


/*
 * A few declarations of things that look a bit like real code:
 */
struct object {
	int	refcount;
};

struct credential {};

int get_object(int index, struct object **o);
int example_syscall(struct credential *cred, int index, int op);


/*
 * Some functions we can reference in assertions:
 */
static void	hold(struct object *o) { o->refcount += 1; }


int
perform_operation(int op, struct object *o)
{
	TESLA_WITHIN(example_syscall, previously(called(hold, o)));
	TESLA_WITHIN(example_syscall, previously(returned(hold, o)));

	return 0;
}


int
example_syscall(struct credential *cred, int index, int op)
{
	/*
	 * Entering the system call should update all automata:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        0 ('[[CLASS0:.*]]')
	 * CHECK: transitions:  [ (0:0x0 -> [[INIT0:[0-9]+]] <init>) ]
	 * CHECK: ----
	 * CHECK: new [[ID0:[0-9]+]]
	 * CHECK: ----
	 * CHECK: ====
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        1 ('[[CLASS1:.*]]')
	 * CHECK: transitions:  [ (0:0x0 -> [[INIT1:[0-9]+]] <init>) ]
	 * CHECK: ----
	 * CHECK: new [[ID1:[0-9]+]]
	 * CHECK: ----
	 * CHECK: ====
	 */

	struct object *o;

	/*
	 * get_object() calls hold(), which should be reflected in two automata:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        0 ('[[CLASS0]]')
	 * CHECK: transitions:  {{.*}} ([[INIT0]]:0x0 -> [[OBJ0:[0-9]+]])
	 * CHECK: ----
	 * CHECK: clone [[ID0]]:[[INIT0]] -> [[ID00:[0-9]+]]:[[OBJ0]]
	 * CHECK: ----
	 * CHECK: ====
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        1 ('[[CLASS1]]')
	 * CHECK: transitions:  {{.*}} ([[INIT1]]:0x0 -> [[OBJ1:[0-9]+]])
	 * CHECK: ----
	 * CHECK: clone [[ID1]]:[[INIT1]] -> [[ID10:[0-9]+]]:[[OBJ1]]
	 * CHECK: ----
	 * CHECK: ====
	 */
	int error = get_object(index, &o);
	if (error != 0)
		return (error);

	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        0 ('[[CLASS0]]')
	 * CHECK: transitions:  {{.*}} ([[INIT0]]:0x0 -> [[OBJ0]])
	 * CHECK: ----
	 * CHECK: clone [[ID0]]:[[INIT0]] -> [[ID01:[0-9]+]]:[[OBJ0]]
	 * CHECK: ----
	 * CHECK: ====
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        1 ('[[CLASS1]]')
	 * CHECK: transitions:  {{.*}} ([[INIT1]]:0x0 -> [[OBJ1]])
	 * CHECK: ----
	 * CHECK: clone [[ID1]]:[[INIT1]] -> [[ID11:[0-9]+]]:[[OBJ1]]
	 * CHECK: ----
	 * CHECK: ====
	 */
	error = get_object(index + 1, &o);
	if (error != 0)
		return (error);

	/*
	 * perform_operation() contains all NOW events:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        0 ('[[CLASS0]]')
	 * CHECK: transitions:  {{.*}} ([[OBJ0]]:0x1 -> [[OP0:[0-9]+]]) ]
	 * CHECK: ----
	 * CHECK-NOT: update [[ID00]]: [[OBJ0]]->[[OP0]]
	 * CHECK:     update [[ID01]]: [[OBJ0]]->[[OP0]]
	 * CHECK: ----
	 * CHECK: ====
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        1 ('[[CLASS1]]')
	 * CHECK: transitions:  {{.*}} ([[OBJ1]]:0x1 -> [[OP1:[0-9]+]]) ]
	 * CHECK: ----
	 * CHECK-NOT: update [[ID10]]: [[OBJ1]]->[[OP1]]
	 * CHECK:     update [[ID11]]: [[OBJ1]]->[[OP1]]
	 * CHECK: ----
	 * CHECK: ====
	 */
	return perform_operation(op, o);

	/*
	 * On leaving the assertion scope, we should be cleaning up:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        0 ('[[CLASS0]]')
	 * CHECK: transitions:  {{.*}} ([[OP0]]:0x1 -> [[FIN0:[0-9]+]] <clean>)
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK-NOT: fail
	 * CHECK: pass '[[CLASS0]]': [[ID01]]
	 * CHECK-NOT: fail
	 * CHECK: tesla_class_reset
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ====
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class:        1 ('[[CLASS1]]')
	 * CHECK: transitions:  {{.*}} ([[OP1]]:0x1 -> [[FIN1:[0-9]+]] <clean>)
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK-NOT: fail
	 * CHECK: pass '[[CLASS1]]': [[ID11]]
	 * CHECK-NOT: fail
	 * CHECK: tesla_class_reset
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ====
	 */
}


int
main(int argc, char *argv[]) {
	struct credential cred;
	return example_syscall(&cred, 0, 0);
}




int
get_object(int index, struct object **o)
{
	static struct object objects[] = {
		{ .refcount = 0 },
		{ .refcount = 0 },
		{ .refcount = 0 },
		{ .refcount = 0 }
	};
	static const size_t MAX = sizeof(objects) / sizeof(struct object);

	if ((index < 0) || (index >= MAX))
		return (EINVAL);

	struct object *obj = objects + index;
	hold(obj);
	*o = obj;

	return (0);
}

