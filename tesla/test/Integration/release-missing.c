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

#include <tesla-macros.h>



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
	TESLA_WITHIN(example_syscall, eventually(call(release(o))));

	return 0;
}


int
example_syscall(struct credential *cred, int index, int op)
{
	/*
	 * CHECK: new    [[INST0:[0-9]+]]: [[INIT:1:0x0]]
	 */

	struct object *o;
	int error = get_object(index, &o);
	if (error != 0)
		return (error);

	/*
	 * perform_operation() contains the NOW event:
	 * CHECK: clone  [[INST0]]:[[INIT]] -> [[INST1:[0-9]+]]:[[NOW:[0-9]+:0x1]]
	 */
	perform_operation(op, o);

	// Error: missing release(o)!
	//release(o);

	/*
	 * ERR: Instance {{[0-9]+}} is in state {{[0-9]+}}
	 * ERR: but received event '{{.*}}example_syscall{{.*}}cleanup
	 * ERR: causes transition in: [
	 * ERR:     ({{[0-9]+}}:0x0 -> {{[0-9]+}}:0x0 <clean>)
	 * ERR:     ({{[0-9]+}}:0x1 -> {{[0-9]+}}:0x{{[01]}} <clean>)
	 * ERR: ]
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

