//! @file hold.c  Tests a missing 'hold' event.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t > %t.out 2>%t.err || true
 * RUN: FileCheck -input-file %t.out %s
 * RUN: FileCheck -check-prefix=ERR -input-file %t.err %s
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
	 * CHECK: transitions:  [ (0:0x0 -> 1 <init>) ]
	 * CHECK: ====
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: transitions:  [ (0:0x0 -> 1 <init>) ]
	 * CHECK: ====
	 */

	struct object *o;

	/*
	 * Error: get_object() does *not* call hold(o)!
	 */
	int error = get_object(index, &o);
	if (error != 0)
		return (error);

	error = get_object(index + 1, &o);
	if (error != 0)
		return (error);

	/*
	 * ERR: TESLA failure
	 * ERR: no instance found to match key '0x1 [ {{[0-9a-f]+}} X X X ]' for transition(s) [ (2:0x1 -> 3) ]
	 */
	return perform_operation(op, o);
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

	// Error: failed to hold(obj)!
	//hold(obj);

	*o = obj;

	return (0);
}

