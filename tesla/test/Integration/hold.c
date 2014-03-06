//! @file hold.c  Tests instrumentation of 'hold' event.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
 * RUN: %filecheck -input-file %t.out %s
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


int
perform_operation(int op, struct object *o)
{
	TESLA_WITHIN(example_syscall, previously(call(hold(o))));
	TESLA_WITHIN(example_syscall, previously(returnfrom(hold(o))));

	return 0;
}


int
example_syscall(struct credential *cred, int index, int op)
{
	/*
	 * Entering the system call should instantiate automata:
	 *
	 * CHECK: [CALE] example_syscall
         * CHECK: sunrise
	 */

	struct object *o;

	/*
	 * get_object() calls hold(), which should be reflected in two automata
	 * (one which cares about entry and the other, exit):
	 *
	 * CHECK: [CALE] hold
	 * CHECK: new  [[A0I0:[0-9]+]]: [[INIT:[0-9]+:0x0]] ('[[A0:.*]]')
	 * CHECK: clone [[A0I0]]:[[INIT]] -> [[A0I1:[0-9]+]]:[[HOLD:[0-9]+:0x1]]
	 * CHECK: [RETE] hold
	 * CHECK: new  [[A1I0:[0-9]+]]: [[INIT:[0-9]+:0x0]] ('[[A1:.*]]')
	 * CHECK: clone [[A1I0]]:[[INIT]] -> [[A1I1:[0-9]+]]:[[HOLD:[0-9]+:0x1]]
	 */
	int error = get_object(index, &o);
	if (error != 0)
		return (error);

	/*
	 * CHECK: [CALE] hold
	 * CHECK: clone [[A0I0]]:[[INIT]] -> [[A0I2:[0-9]+]]:[[HOLD:[0-9]+:0x1]]
	 * CHECK: [RETE] hold
	 * CHECK: clone [[A1I0]]:[[INIT]] -> [[A1I2:[0-9]+]]:[[HOLD:[0-9]+:0x1]]
	 */
	error = get_object(index + 1, &o);
	if (error != 0)
		return (error);

	/*
	 * perform_operation() contains all NOW events:
	 *
	 * CHECK: [ASRT] automaton 0
	 * CHECK: update [[A0I2]]: [[HOLD]]->[[NOW:[0-9]+:0x1]]
	 * CHECK: [ASRT] automaton 1
	 * CHECK: update [[A1I2]]: [[HOLD]]->[[NOW:[0-9]+:0x1]]
	 */
	return perform_operation(op, o);

	/*
	 * On leaving the assertion scope, we should be cleaning up:
	 *
	 * CHECK: [RETE] example_syscall
         *
         * There should only be one (shared) sunset event:
         * CHECK: sunset
         * CHECK-NOT: sunset
	 *
	 * CHECK: update [[A0I0]]: [[INIT]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[A0]]': [[A0I0]]
	 * CHECK: update [[A0I1]]: [[HOLD]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[A0]]': [[A0I1]]
	 * CHECK: update [[A0I2]]: [[NOW]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[A0]]': [[A0I2]]
	 * CHECK: tesla_class_reset [[A0]]
	 *
	 * CHECK: update [[A1I0]]: [[INIT]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[A1]]': [[A1I0]]
	 * CHECK: update [[A1I1]]: [[HOLD]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[A1]]': [[A1I1]]
	 * CHECK: update [[A1I2]]: [[NOW]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[A1]]': [[A1I2]]
	 * CHECK: tesla_class_reset [[A1]]
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

