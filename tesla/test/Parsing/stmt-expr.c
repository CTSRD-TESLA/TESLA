/**
 * @file stmt-expr.c
 * Check parsing of statement-expressions (GCC extension) as sequences.
 *
 * RUN: tesla analyse -S %s -o %t -- %cflags
 * RUN: %filecheck -input-file=%t %s
 */

#include <tesla-macros.h>

int	foo(int);
int	bar(int);
int	baz(int);

int foo(int x) {
	/*
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/stmt-expr.c"
	 * CHECK:           }
	 * CHECK:         }
	 * CHECK:         expression {
	 */
	TESLA_WITHIN(foo, ({
		/*
		 * CHECK-NEXT:    type: SEQUENCE
		 * CHECK-NEXT:    sequence {
		 */
		/*
		 * CHECK:       expression {
		 * CHECK:         type: FUNCTION
		 * CHECK-NEXT:    function {
		 * CHECK-NEXT:      function {
		 * CHECK-NEXT:        name: "foo"
		 * CHECK:           }
		 * CHECK:         }
		 * CHECK:       }
		 */
		foo(x) == 0;

		/*
		 * CHECK:       expression {
		 * CHECK-NEXT:    type: FUNCTION
		 * CHECK-NEXT:    function {
		 * CHECK-NEXT:      function {
		 * CHECK-NEXT:        name: "bar"
		 * CHECK:           }
		 * CHECK:         }
		 * CHECK:       }
		 */
		bar(x) == 0;

		/*
		 * CHECK:       expression {
		 * CHECK-NEXT:    type: FUNCTION
		 * CHECK-NEXT:    function {
		 * CHECK-NEXT:      function {
		 * CHECK-NEXT:        name: "baz"
		 * CHECK:           }
		 * CHECK:         }
		 * CHECK:       }
		 */
		baz(x) == 0;
	}));
	/*
	 * CHECK:   }
	 * CHECK: }
	 */


	/*
	 * Try the same thing again but with a previously():
	 *
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/stmt-expr.c"
	 * CHECK:           }
	 * CHECK:         }
	 * CHECK:         expression {
	 */
	TESLA_WITHIN(foo, previously(({
		/*
		 * CHECK-NEXT:    type: SEQUENCE
		 * CHECK-NEXT:    sequence {
		 */

		/*
		 * CHECK:       expression {
		 * CHECK:         type: FUNCTION
		 * CHECK-NEXT:    function {
		 * CHECK-NEXT:      function {
		 * CHECK-NEXT:        name: "foo"
		 * CHECK:           }
		 * CHECK:         }
		 * CHECK:       }
		 */
		foo(x) == 0;

		/*
		 * CHECK:       expression {
		 * CHECK-NEXT:    type: FUNCTION
		 * CHECK-NEXT:    function {
		 * CHECK-NEXT:      function {
		 * CHECK-NEXT:        name: "bar"
		 * CHECK:           }
		 * CHECK:         }
		 * CHECK:       }
		 */
		bar(x) == 0;
	})));
	/*
	 * CHECK:   }
	 * CHECK: }
	 */

	return 0;
}

