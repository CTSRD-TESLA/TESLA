/**
 * @file Parsing/free-variables.c
 * Allow programmers to specify variables that can be used in pattern
 * matching but which are unknown at the assertion site.
 *
 * This requires the GCC expression-of-statements extension.
 *
 * RUN: tesla analyse -S %s -o %t -- %cflags
 * RUN: FileCheck -input-file=%t %s
 */

#include <tesla-macros.h>

int	foo(int);
int	bar(int);
int	baz(int);

void context() {
	/*
	 * This assertion specifies that foo, bar and baz have all been
	 * previously called with the same parameter, but that parameter's
	 * value is not known at the assertion site.
	 *
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/free-variables.c"
	 * CHECK:           }
	 * CHECK:         }
	 * CHECK:         expression {
	 */
	TESLA_WITHIN(foo, previously(({
		int x;

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
		 * CHECK-NEXT:      }
		 * CHECK:           argument {
		 * CHECK-NEXT:        type: Variable
		 * CHECK-NEXT:        index: 0
		 * CHECK-NEXT:        name: "x"
		 * CHECK-NEXT:        free: true
		 * CHECK-NEXT:      }
		 * CHECK-NEXT:      expectedReturnValue {
		 * CHECK-NEXT:        type: Constant
		 * CHECK-NEXT:        value: 0
		 * CHECK-NEXT:      }
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
	})));
	/*
	 * CHECK:   }
	 * CHECK: }
	 */
}
