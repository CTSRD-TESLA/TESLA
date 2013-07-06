/**
 * @file indirection.c
 * Check parsing of a value returned from a function via a pointer.
 *
 * RUN: tesla analyse %s -o %t -- %cflags
 * RUN: FileCheck -input-file=%t %s
 */

#include "tesla-macros.h"

struct object;

void	context(void);
int	get_object(struct object* *obj_out);

void foo(struct object *o) {
	/*
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/indirection.c"
	 * CHECK:           }
	 * CHECK:         }
	 * CHECK:         expression {
	 */
	TESLA_WITHIN(context,
		TSEQUENCE(
			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "get_object"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Indirect
			 * CHECK-NEXT:        indirection {
			 * CHECK-NEXT:         type: Variable
			 * CHECK-NEXT:         index: 0
			 * CHECK-NEXT:         name: "o"
			 * CHECK-NEXT:        }
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 */
			get_object(&o) == 0
		)
	);
}
