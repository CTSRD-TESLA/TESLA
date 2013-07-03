//! @file previously.c  Conversion of a 'previously' automaton to dot format. */
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: tesla graph -o %t.dot %t.tesla
 * RUN: FileCheck -input-file %t.dot %s
 */

#include <errno.h>
#include <stddef.h>

#include "tesla-macros.h"


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
	 * CHECK: 0 [ label = "state 0\n(&#8902;)" ];
	 * CHECK: 1 [ label = "state 1\n(&#8902;)" ];
	 * CHECK: 2 [ label = "state 2\n(o)" ];
	 * CHECK: 3 [ label = "state 3\n(o)" ];
	 * CHECK: 4 [ label = "state 4\n(o)", shape = doublecircle ];
	 *
	 * CHECK: example_syscall(X): Entry
	 * CHECK: 0 -> 1;
	 *
	 * CHECK: hold(o): Entry
	 * CHECK: 1 -> 2;
	 * CHECK: 1 -> 1;
	 *
	 * CHECK: NOW
	 * CHECK: 2 -> 3;
	 *
	 * CHECK: example_syscall(X) == X
	 * CHECK: 3 -> 4;
	 * CHECK: 1 -> 4;
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
	return example_syscall(&cred, 0, 0);
}
