/**
 * @file function-call.c
 * Check parsing of TESLA sequences.
 *
 * RUN: tesla analyse %s -o %t -- %cflags
 * RUN: FileCheck -input-file=%t %s
 */

#include <tesla-macros.h>

int	foo(int);
int	bar(int);
int	baz(int, int);

#define	PI	3

int foo(int x) {
	/*
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/function-call.c"
	 * CHECK:           }
	 * CHECK:         }
	 * CHECK:         expression {
	 */
	TESLA_WITHIN(foo,
		TSEQUENCE(
			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "foo"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        name: "x"
			 * CHECK:           }
			 * CHECK:           expectedReturnValue {
			 * CHECK-NEXT:        type: Constant
			 * CHECK-NEXT:        value: 0
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 */
			foo(x) == 0,

			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "foo"
			 * CHECK:           }
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        name: "x"
			 * CHECK:           }
			 * CHECK:         }
			 * CHECK:       }
			 */
			call(foo(x)),

			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "foo"
			 * CHECK:           }
			 * CHECK:           context: Caller
			 * CHECK:         }
			 * CHECK:       }
			 */
			caller(foo(x) == 0),

			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "foo"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:         }
			 * CHECK:       }
			 */
			callee(foo(x) == 0),

			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "foo"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:         }
			 * CHECK:       }
			 */
			caller(callee(foo(x) == 0)),

			caller(
				/*
				 * CHECK: expression {
				 * CHECK:   sequence {
				 */
				TSEQUENCE(
					/*
					 * CHECK:       expression {
					 * CHECK:         type: FUNCTION
					 * CHECK-NEXT:    function {
					 * CHECK-NEXT:      function {
					 * CHECK-NEXT:        name: "foo"
					 * CHECK:           }
					 * CHECK:           context: Caller
					 * CHECK:         }
					 * CHECK:       }
					 */
					foo(x) == 0,

					/*
					 * CHECK:       expression {
					 * CHECK:         type: FUNCTION
					 * CHECK-NEXT:    function {
					 * CHECK-NEXT:      function {
					 * CHECK-NEXT:        name: "bar"
					 * CHECK:           }
					 * CHECK:           context: Caller
					 * CHECK:         }
					 * CHECK:       }
					 */
					bar(x) == 0
				)
				/*
				 * CHECK:   }
				 * CHECK: }
				 */
			),

			/*
			 * CHECK:       expression {
			 * CHECK-NEXT:    type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "bar"
			 * CHECK:           }
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        name: "x"
			 * CHECK:           }
			 * CHECK:           expectedReturnValue {
			 * CHECK-NEXT:        type: Constant
			 * CHECK-NEXT:        value: 42
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 */
			bar(x) == 42,

			/*
			 * CHECK:       expression {
			 * CHECK-NEXT:    type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "baz"
			 * CHECK:           }
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        name: "x"
			 * CHECK:           }
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Constant
			 * CHECK-NEXT:        value: 3
			 * CHECK:           }
			 * CHECK:           expectedReturnValue {
			 * CHECK-NEXT:        type: Constant
			 * CHECK-NEXT:        value: 3
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 */
			baz(x, PI) == PI
		)
	);

	return 0;
}
