/**
 * @file indirection.c
 * Check parsing of a value returned from a function via a pointer.
 *
 * RUN: tesla analyse %s -o %t -- %cflags
 * RUN: FileCheck -input-file=%t %s
 * RUN: tesla print -format=dot -d %t -o %t.dot
 * RUN: FileCheck -check-prefix=DOT -input-file=%t.dot %s
 */

#include <tesla-macros.h>

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
	 *
	 * DOT: digraph automaton
	 * DOT:  0 [ label = "state 0\n{{.*}}([[ANY:&#[0-9]+;]])" ];
	 * DOT:  [[INIT:[0-9]+]] [ label = "state [[INIT]]\n{{.*}}([[ANY]])" ];
	 * DOT:  [[OBJ:[0-9]+]]  [ label = "state [[OBJ]]\n{{.*}}(o)" ];
	 * DOT:  [[DONE:[0-9]+]] [ label = "state [[DONE]]\n{{.*}}", shape = doublecircle ];
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
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        indirection {
			 * CHECK-NEXT:         type: Variable
			 * CHECK-NEXT:         name: "o"
			 * CHECK-NEXT:        }
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 *
			 * TODO: use DOT-DAG when we move to LLVM 3.4:
			 *
			 * DOT:        0 -> [[INIT]];
			 * DOT: [[INIT]] -> [[OBJ]];
			 * DOT: [[OBJ]] -> [[OBJ]];
			 * DOT: [[INIT]] -> [[DONE]];
			 * DOT: [[OBJ]]  -> [[DONE]];
			 */
			get_object(&o) == 0
		)
	);
}
