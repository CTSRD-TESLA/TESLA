//! @file call.c  Tests basic caller and callee instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t 2>%t.err | tee %t.out || true
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
static void	release(struct object *o) { o->refcount -= 1; }


int
perform_operation(int op, struct object *o)
{
	TESLA_WITHIN(example_syscall, eventually(called(release, o)));

	return 0;
}


int
example_syscall(struct credential *cred, int index, int op)
{
	struct object *o;
	int error = get_object(index, &o);
	if (error != 0)
		return (error);

	/*
	 * perform_operation() contains the NOW event:
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: transitions:  [ (0:0x0 -> [[INIT:[0-9]+]]:0x0 <init>) ]
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: new [[ID:[0-9]+]]: [[INIT]]
	 * CHECK: ----
	 * CHECK: ====
	 */
	perform_operation(op, o);

	// Error: missing release(o)!
	//release(o);

	/*
	 * CHECK-NOT: update [[ID]]
	 *
	 * ERR: TESLA failure
	 * ERR: No instance matched key '0x0 [ X X X X ]' for transition(s) [ ({{[0-9]+}}:0x1 -> {{[0-9]+}}:0x1 <clean>) ]
	 */
	return 0;
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

