/**
 * Test that the inclusive OR is correctly implemented.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla graph -u %t.tesla -o %t.nondeterministic.dot
 * RUN: tesla graph -l %t.tesla -o %t.deterministic.dot
 * RUN: FileCheck -check-prefix=NFA -input-file=%t.nondeterministic.dot %s
 * RUN: FileCheck -check-prefix=DFA -input-file=%t.deterministic.dot %s
 */

#include "tesla-macros.h"

int foo(int x) {
	/*
	 * NFA: digraph automaton_{{[0-9]+}}
	 * DFA: digraph automaton_{{[0-9]+}}
	 */
	if (x > 10)
		return 0;

	/*
	 * NFA: label = "foo([[ANY:&#[0-9a-f]+;]])\n(Entry){{.*}}init
	 * DFA: label = "foo([[ANY:&#[0-9a-f]+;]])\n(Entry){{.*}}init
	 */
	if (x > 0)
		TESLA_WITHIN(foo, previously(foo(x) == 0));

	/*
	 * NFA: label = "foo(x) == 0
	 * DFA: label = "foo(x) == 0
	 */
	return foo(x++);

	/*
	 * NFA: label = "foo([[ANY]]) == [[ANY]]{{.*}}cleanup
	 * DFA: label = "foo([[ANY]]) == [[ANY]]{{.*}}cleanup
	 */

	/*
	 * Graph footer:
	 * NFA: label = "{{.*determinise.c:[0-9]+#[0-9]+}}"
	 * DFA: label = "{{.*determinise.c:[0-9]+#[0-9]+}}"
	 */
}
