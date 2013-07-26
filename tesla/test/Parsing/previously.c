//! @file previously.c  Conversion of a 'previously' automaton to dot format. */
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: tesla print -format=dot -d -o %t.dot %t.tesla
 * RUN: FileCheck -input-file %t.dot %s
 */

#include <errno.h>
#include <stddef.h>

#include <tesla-macros.h>


/*
 * A few declarations of things that look a bit like real code:
 */
struct object {
};

struct credential {};

int get_object(struct object **o);
int example_syscall(struct credential *cred);


/*
 * Some functions we can reference in assertions:
 */
void	hold(struct object *o);


int
perform_operation(struct object *o)
{
	/*
	 * CHECK: digraph automaton_0 {
	 *
	 * TODO: when we switch to LLVM 3.4, use CHECK-DAG here:
	 *
	 * CHECK: 0 [ label = "state 0\n{{.*}}(&#8902;)" ];
	 * CHECK: [[INIT:[0-9]+]] [ label = "state [[INIT]]\n{{.*}}(&#8902;)" ];
	 * CHECK: [[HOLD:[0-9]+]] [ label = "state [[HOLD]]\n{{.*}}(o)" ];
	 * CHECK: [[DONE:[0-9]+]] [ label = "state [[DONE]]\n{{.*}}", shape = doublecircle ];
	 * CHECK: [[ASRT:[0-9]+]] [ label = "state [[ASRT]]\n{{.*}}(o)" ];
	 *
	 * CHECK: example_syscall(X): Entry
	 * CHECK: 0 -> [[INIT]];
	 *
	 * CHECK: hold(o): Entry
	 * CHECK: [[INIT]] -> [[HOLD]];
	 * CHECK: [[HOLD]] -> [[HOLD]];
	 *
	 * CHECK: example_syscall(X) == X
	 * CHECK: [[INIT]] -> [[DONE]];
	 * CHECK: [[HOLD]] -> [[DONE]];
	 * CHECK: [[ASRT]] -> [[DONE]];
	 *
	 * CHECK: assertion
	 * CHECK: [[HOLD]] -> [[ASRT]];
	 *
	 * CHECK: }
	 */
	TESLA_WITHIN(example_syscall, previously(called(hold(o))));

	return 0;
}


int
example_syscall(struct credential *cred)
{
	struct object *o;

	int error = get_object(&o);
	if (error != 0)
		return (error);

	return perform_operation(o);
}


int
main(int argc, char *argv[]) {
	struct credential cred;
	return example_syscall(&cred);
}
