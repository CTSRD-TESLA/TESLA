/**
 * @file inclusive-or-repeat.c
 * Check automata generated from repeated expressions.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla graph -d %t.tesla -o %t.dot
 * RUN: FileCheck -input-file=%t.dot %s
 */

#include "tesla-macros.h"

int	context();
int	foo();
int	bar();

int foo() {
	TESLA_WITHIN(context,
	  strict(ATLEAST(0, called(foo)) || ATLEAST (0, called(bar)))
	);
  /*
   * Transitions, grouped into equivalence classes:
   *
   * context(): 0->1
   * CHECK: label = "context(){{.*}}Entry{{.*}}init{{.*}}
   * CHECK: 0 -> [[CALL:[0-9]+]]
   *
   * foo(): [ 3->3, 5->3, 1->3, 4->5, 6->5 ]
   * CHECK: label = "foo()
   * CHECK: [[F:[0-9]+]] -> [[F]]
   * CHECK: [[BF:[0-9]+]] -> [[F]]
   * CHECK: [[CALL]] -> [[F]]
   * CHECK: [[B:[0-9]+]] -> [[BF]]
   * CHECK: [[FB:[0-9]+]] -> [[BF]]
   *
   * bar(): [ 6->6, 1->4, 5->6, 4->4, 3->6 ]
   * CHECK: label = "bar()
   * CHECK: [[FB]] -> [[FB]]
   * CHECK: [[CALL]] -> [[B]]
   * CHECK: [[BF]] -> [[FB]]
   * CHECK: [[B]] -> [[B]]
   * CHECK: [[F]] -> [[FB]]
   */

  /*
   * Graph footer:
   * CHECK: label = "{{.*inclusive-or-repeat1.c:[0-9]+#[0-9]+}}
   */
	return 0;
}
