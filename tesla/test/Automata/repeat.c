/**
 * @file repeat.c
 * Check automata generated from repeated expressions.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla print -format=text -d %t.tesla | FileCheck %s
 */

#include <tesla-macros.h>

int	context();
int	foo();
int	bar();
int	baz();

int foo() {
	/*
	 * CHECK: automaton '[[NAME:.*repeat.c:[0-9]+#[0-9]+]]' {
	 *
	 * CHECK: state {{.*}} :
	 * CHECK: context(): Entry <<init>>
	 * CHECK: -->([[INIT:.*]])
	 */
	TESLA_WITHIN(context,
		TSEQUENCE(
			/*
			 * Since there is a minimum of two foo()
			 * transitions but no maximum, we create two
			 * foo()-following states, the last of which can
			 * loop back.
			 *
			 * CHECK: state [[INIT]]
			 * CHECK: foo(): Entry)-->([[FOO1:[':,a-zA-Z0-9]+]])
			 *
			 * CHECK: state [[FOO1]]
			 * CHECK: --(foo(): Entry)-->([[FOO2:[':,a-zA-Z0-9]+]])
			 *
			 * CHECK: state [[FOO2]]
			 * CHECK: --(foo(): Entry)-->([[FOO2]])
			 */
			ATLEAST(2, call(foo)),

			/*
			 * Up to three bar() events are allowed: after each
			 * one, a baz() event could advance the state to
			 * the [[BAZ1]] state.
			 *
			 * CHECK: --(bar(): Entry)-->([[BAR1:[':,a-zA-Z0-9]+]])
			 *
			 * CHECK: state [[BAR1]]
			 * CHECK: --(bar(): Entry)-->([[BAR2:[':,a-zA-Z0-9]+]])
			 * CHECK: --(baz(): Entry)-->([[BAZ1:[':,a-zA-Z0-9]+]])
			 *
			 * CHECK: state [[BAR2]]
			 * CHECK: --(bar(): Entry)-->([[BAR3:[':,a-zA-Z0-9]+]])
			 * CHECK: --(baz(): Entry)-->([[BAZ1]])
			 */
			UPTO(3, call(bar)),

			/*
			 * Finally, we may have no fewer than two and no more
			 * than four baz() transitions.
			 *
			 * We've already had one from a [[BARx]] state; after
			 * one more we can take an exit transition:
			 *
			 * CHECK: state [[BAZ1]]
			 * CHECK: --(baz(): Entry)-->([[BAZ2:[':,a-zA-Z0-9]+]])
			 *
			 * CHECK: state [[BAZ2]]
			 * CHECK: --(baz(): Entry)-->([[BAZ3:[':,a-zA-Z0-9]+]])
			 * CHECK: --(context() == X <<cleanup>>)-->([[DONE:[':,a-zA-Z0-9]+]])
			 *
			 * We are allowed one more baz() transition:
			 *
			 * CHECK: state [[BAZ3]]
			 * CHECK: --(baz(): Entry)-->([[BAZ4:[':,a-zA-Z0-9]+]])
			 * CHECK: --(context() == X <<cleanup>>)-->([[DONE]])
			 *
			 * But that was absolutely the last baz() transition:
			 *
			 * CHECK: state [[BAZ4]]
			 * CHECK: --(context() == X <<cleanup>>)-->([[DONE]])
			 */
			REPEAT(2, 4, call(baz))

			/*
			 * TODO: use CHECK-DAG when we switch to LLVM 3.4:
			 *
			 * CHECK: state [[BAR3]]
			 * CHECK: --(baz(): Entry)-->([[BAZ1]])
			 */
		)
	);

	return 0;
}
