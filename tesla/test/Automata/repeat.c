/**
 * @file repeat.c
 * Check automata generated from repeated expressions.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla graph -u %t.tesla -o %t.dot
 * RUN: FileCheck -input-file=%t.dot %s
 */

#include "tesla-macros.h"

int	context();
int	foo();
int	bar();
int	baz();

int foo() {
	/*
	 * CHECK:  digraph automaton{{.*}} {
	 *
	 * TODO: when we move to LLVM 3.4, use CHECK-DAG:
	 *
	 * CHECK:    edge [ label = "context()
	 * CHECK:    0 -> [[INIT:[0-9]+]];
	 */
	TESLA_WITHIN(context,
		TSEQUENCE(
			/*
			 * TODO: this is an excellent example of why we need
			 *       CHECK-DAG: there is nothing wrong with this
			 *       ordering, but it is a silly ordering to
			 *       hard-code in a test!
			 *
			 * CHECK:    edge [ label = "foo()
			 * CHECK:    [[INIT]] -> [[FOO1:[0-9]+]]
			 * CHECK:    [[FOO1]] -> [[FOO2:[0-9]+]]
			 * CHECK:    [[INIT]] -> [[INIT]]
			 */
			ATLEAST(2, called(foo)),

			/*
			 * CHECK:    edge [ label = "[[EPISLON:&#949;]]
			 * CHECK:    [[FOO2]] -> [[BAR0:[0-9]+]]
			 * CHECK:    [[FOO2]] -> [[IGNORE:[0-9]+]]
			 */

			/*
			 * CHECK:    edge [ label = "bar()
			 * CHECK:    [[BAR1:[0-9]+]] -> [[BAR2:[0-9]+]]
			 * CHECK:    [[BAR0]] -> [[BAR1]]
			 * CHECK:    [[BAR2]] -> [[BAR3:[0-9]+]]
			 * CHECK:    [[INIT]] -> [[INIT]]
			 */
			UPTO(3, called(bar)),

			/*
			 * CHECK:    edge [ label = "baz()
			 * CHECK:    [[INIT]] -> [[INIT]]
			 * CHECK:    [[BAZ1:[0-9]+]] -> [[BAZ2:[0-9]+]]
			 * CHECK:    [[BAZ0:[0-9]+]] -> [[BAZ1]]
			 * CHECK:    [[BAZ2]] -> [[BAZ3:[0-9]+]]
			 */
			REPEAT(2, 3, called(baz))
		)
	);

	return 0;
}
