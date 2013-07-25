/**
 * Test that the inclusive OR is correctly implemented.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla print -format=dot -n %t.tesla -o %t.dot
 * RUN: FileCheck -input-file=%t.dot %s
 */

#include "tesla-macros.h"

int	a(int);
int	b(int);

void ab() {
  /*
   * Test a `inclusive-or` b:
   * This should produce the following automaton:
   *
   * = (prefix*(a) || b) | (a || prefix*(b)) | (a || b)
   * = (ø || b          | (a || ø          | (a || b)
   * = b                 | a                 | ab | ba
   *
   * CHECK: digraph automaton_{{[0-9]+}}
   */
  int x, y;
  TESLA_PERTHREAD(strict(called(ab)), strict(returned(ab)),
                  strict(a(x) == 0 || b(y) == 0));

  /*
   * Transitions, grouped into equivalence classes:
   *
   * ab(): 0->1
   * CHECKX: label = "ab(){{.*}}Entry{{.*}}init{{.*}}
   * CHECKX: 0 -> [[CALL:[0-9]+]]
   *
   * a(x): [ 2->4, 5->7 ]
   * CHECKX: label = "a(x)
   * CHECKX: [[INIT1:[0-9]+]] -> [[A1:[0-9]+]]
   * CHECKX: [[B1:[0-9]+]] -> [[A2:[0-9]+]]
   *
   * b(y): [ 3->5, 4->7 ]
   * CHECKX: label = "b(y)
   * CHECKX: [[INIT2:[0-9]+]] -> [[B1]]
   * CHECKX: [[A1]] -> [[A2]]
   *
   * �: [ 5->6, 4->6, 7->6, 1->2, 1->3 ]
   * CHECKX: label = "[[EPSILON:&#[0-9a-f]+;]]"
   * CHECKX: [[B1]] -> [[FINAL:[0-9]+]]
   * CHECKX: [[A1]] -> [[FINAL]]
   * CHECKX: [[CALL]] -> [[INIT2]]
   * CHECKX: [[A2]] -> [[FINAL]]
   * CHECKX: [[CALL]] -> [[INIT1]]
   */

  /*
   * Graph footer:
   * CHECKX: label = "{{.*inclusive-or.c:[0-9]+#[0-9]+}}
   */
}

