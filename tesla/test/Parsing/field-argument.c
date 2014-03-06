/**
 * @file field-argument.c
 * Check parsing of a automaton instance name derived from a struct field.
 *
 * RUN: tesla analyse -S %s -o %t -- %cflags
 * RUN: %filecheck -input-file=%t %s
 */

#include <tesla-macros.h>

struct object { int field; };

void	context(void);
int	do_something(int);

void foo(struct object *op) {
	struct object o;

	/*
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/field-argument.c"
	 * CHECK:           }
	 * CHECK:         }
	 * CHECK:         expression {
	 * CHECK:           sequence {
	 */
	TESLA_WITHIN(context,
		TSEQUENCE(
			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "do_something"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Field
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        field {
			 * CHECK-NEXT:          type: "object"
			 * CHECK-NEXT:          base {
			 * CHECK-NEXT:            type: Variable
			 * CHECK-NEXT:            name: "op"
			 * CHECK-NEXT:          }
			 * CHECK-NEXT:          name: "field"
			 * CHECK-NEXT:          index: 0
			 * CHECK-NEXT:        }
			 * CHECK:           }
			 * CHECK:         }
			 * CHECK:       }
			 */
			do_something(op->field) == 0,

			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "do_something"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Field
			 * CHECK-NEXT:        index: 1
			 * CHECK-NEXT:        field {
			 * CHECK-NEXT:          type: "object"
			 * CHECK-NEXT:          base {
			 * CHECK-NEXT:            type: Variable
			 * CHECK-NEXT:            name: "o"
			 * CHECK-NEXT:          }
			 * CHECK-NEXT:          name: "field"
			 * CHECK-NEXT:          index: 0
			 * CHECK-NEXT:        }
			 * CHECK:           }
			 * CHECK:         }
			 * CHECK:       }
			 */
			do_something(o.field) == 0
		)
	);
	/*
	 * CHECK:   }
	 * CHECK: }
	 * CHECK: argument {
	 * CHECK-NEXT:   type: Field
	 * CHECK-NEXT:   index: 0
	 * CHECK-NEXT:   field {
	 * CHECK-NEXT:     type: "object"
	 * CHECK-NEXT:     base {
	 * CHECK-NEXT:       type: Variable
	 * CHECK-NEXT:       name: "op"
	 * CHECK-NEXT:     }
	 * CHECK-NEXT:     name: "field"
	 * CHECK-NEXT:     index: 0
	 * CHECK-NEXT:   }
	 * CHECK-NEXT: }
	 * CHECK-NEXT: argument {
	 * CHECK-NEXT: type: Field
	 * CHECK-NEXT: index: 1
	 * CHECK-NEXT: field {
	 * CHECK-NEXT:   type: "object"
	 * CHECK-NEXT:   base {
	 * CHECK-NEXT:     type: Variable
	 * CHECK-NEXT:     name: "o"
	 * CHECK-NEXT:   }
	 * CHECK-NEXT:   name: "field"
	 * CHECK-NEXT:   index: 0
	 * CHECK-NEXT: }
	 */
}
