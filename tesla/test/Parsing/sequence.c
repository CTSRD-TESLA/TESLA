/**
 * @file sequence.c
 * Check parsing of TESLA sequences.
 *
 * RUN: tesla analyse -S %s -o %t -- %cflags
 * RUN: FileCheck -input-file=%t %s
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
	 * CHECK-NEXT:        filename: "{{.*}}/sequence.c"
	 * CHECK:           }
	 * CHECK:         }
	 * CHECK:         expression {
	 */
	TESLA_WITHIN(foo,
		/*
		 * CHECK-NEXT:    type: SEQUENCE
		 * CHECK-NEXT:    sequence {
		 */
		TSEQUENCE(
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
			foo(x) == 0,

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
			bar(x) == 0,

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
			baz(x) == 0
		)
	);
	/*
	 * CHECK:   }
	 * CHECK: }
	 */

	return 0;
}
