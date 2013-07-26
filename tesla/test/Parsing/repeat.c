/**
 * @file repeat.c
 * Check parsing of repeated expressions.
 *
 * RUN: tesla analyse %s -o %t -- %cflags
 * RUN: FileCheck -input-file=%t %s
 */

#include <tesla-macros.h>

int	foo();
int	bar();
int	baz();

int foo() {
	/*
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/repeat.c"
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
			 * CHECK:     sequence {
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "foo"
			 * CHECK:           }
			 * CHECK:         }
			 * CHECK:       }
			 * CHECK:       minReps: 2
			 * CHECK:     }
			 */
			ATLEAST(2, called(foo)),

			/*
			 * CHECK:     sequence {
			 * CHECK:       expression {
			 * CHECK-NEXT:    type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "bar"
			 * CHECK:           }
			 * CHECK:         }
			 * CHECK:       }
			 * CHECK:         maxReps: 10
			 * CHECK:     }
			 */
			UPTO(10, called(bar)),

			/*
			 * CHECK:     sequence {
			 * CHECK:       expression {
			 * CHECK-NEXT:    type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "baz"
			 * CHECK:           }
			 * CHECK:         }
			 * CHECK:         minReps: 42
			 * CHECK:         maxReps: 314
			 * CHECK:       }
			 * CHECK:     }
			 */
			REPEAT(42, 314, called(baz))
		)
	);
	/*
	 * CHECK:   }
	 * CHECK: }
	 */

	return 0;
}
