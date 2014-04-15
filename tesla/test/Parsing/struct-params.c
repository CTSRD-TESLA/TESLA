/**
 * @file struct-params.c
 * Check parsing of pass-by-value structures (which LLVM translates into
 * passing of parameters).
 *
 * RUN: tesla analyse -S %s -o %t -- %cflags
 * RUN: %filecheck -input-file=%t %s
 */

#include <tesla-macros.h>

struct buffer {
	size_t length;
	char *data;
};

typedef struct buffer buffer_untagged;

void	context(void);
int	init(struct buffer);
int	process(buffer_untagged);

void foo(struct buffer buf) {
	/*
	 * CHECK:       automaton {
	 * CHECK-NEXT:    identifier {
	 * CHECK-NEXT:      location {
	 * CHECK-NEXT:        filename: "{{.*}}/struct-params.c"
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
			 * CHECK-NEXT:        name: "init"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Any
			 * CHECK-NEXT:        name: "{{.*}}length"
			 * CHECK-NEXT:      }
			 * CHECK-NEXT:      argument {
			 * CHECK-NEXT:        type: Any
			 * CHECK-NEXT:        name: "{{.*}}data"
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 */
			call(init),

			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "init"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        name: "{{.*}}length"
			 * CHECK-NEXT:      }
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 1
			 * CHECK-NEXT:        name: "{{.*}}data"
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 */
			init(buf) == 0,

			/*
			 * CHECK:       expression {
			 * CHECK:         type: FUNCTION
			 * CHECK-NEXT:    function {
			 * CHECK-NEXT:      function {
			 * CHECK-NEXT:        name: "process"
			 * CHECK:           }
			 * CHECK:           context: Callee
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 0
			 * CHECK-NEXT:        name: "{{.*}}length"
			 * CHECK-NEXT:      }
			 * CHECK:           argument {
			 * CHECK-NEXT:        type: Variable
			 * CHECK-NEXT:        index: 1
			 * CHECK-NEXT:        name: "{{.*}}data"
			 * CHECK-NEXT:      }
			 * CHECK:         }
			 * CHECK:       }
			 */
			process(buf) == 0
		)
	);
}
