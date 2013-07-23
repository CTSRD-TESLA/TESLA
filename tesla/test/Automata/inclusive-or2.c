/**
 * Test that the inclusive OR is correctly implemented.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla graph -l %t.tesla -o %t.dot
 * RUN: FileCheck -input-file=%t.dot %s
 */

#include "tesla-macros.h"

int	a(int);
int	b(int);
int	c(int);
int	d(int);

void ab() {
  int x, y, z, p;
  TESLA_WITHIN(ab, 
              TSEQUENCE(a(x) == 0, b(y) == 0)
              || 
              TSEQUENCE(c(z) == 0, d(p) == 0));

  /*
   * Transitions, grouped into equivalence classes:
   *
   * ab(): 0->1
   * CHECK: label = "ab(){{.*}}Entry{{.*}}init{{.*}}
   * CHECK: 0 -> [[CALL:[0-9]+]]
   *
   * a(x): [ 8->11, 2->5, 1->1, 7->13, 9->12 ]
   * CHECK: label = "a(x)
   * CHECK: [[C:[0-9]]] -> [[CA:[0-9]+]]
   * CHECK: [[INIT1:[0-9]+]] -> [[A:[0-9]+]]
   * CHECK: [[IGNORE1:[0-9]+]] -> [[IGNORE2:[0-9]+]]
   * CHECK: [[CDEps:[0-9]+]] -> [[CDEpsA:[0-9]+]]
   * CHECK: [[CD:[0-9]+]] -> [[CDA:[0-9]+]]
   *
   * b(y): [ 5->6, 13->16, 1->1, 11->14, 12->15 ]
   * CHECK: label = "b(y)
   * CHECK: [[A]] -> [[AB:[0-9]+]]
   * CHECK: [[CDEpsA]] -> [[CDEpsAB:[0-9]+]]
   * CHECK: [[CA]] -> [[CAB:[0-9]+]]
   * CHECK: [[CDA]] -> [[CDAB:[0-9]+]]
   *
   * ø: [ 4->10, 7->10, 12->13, 6->4, 9->7, 1->2, 1->3, 18->19, 17->10, 18->10, 19->10, 13->10, 15->16, 16->10]
   * CHECK: label = "[[EPSILON:&#[0-9a-f]+;]]"
   * CHECK: [[CALL]] -> [[INIT1]]
   * CHECK: [[CALL]] -> [[INIT2:[0-9]+]]
   *
   * c(z): [ 3->8, 4->17, 1->1, 6->14, 5->11 ]
   * CHECK: label = "c(z)
   * CHECK: [[INIT2]] -> [[C]]
   * CHECK: [[ABEps:[0-9]+]] -> [[ABEpsC:[0-9]+]]
   * CHECK: [[AB]] -> [[CAB]]
   * CHECK: [[A]] -> [[CA]]
   *
   * d(p): [ 8->9, 14->15, 1->1, 17->18, 11->12 ]
   * CHECK: label = "d(p)
   * CHECK: [[C]] -> [[CD:[0-9]+]]
   * CHECK: [[CAB]] -> [[CABD:[0-9]+]]
   * CHECK: [[ABEpsC]] -> [[ABEpsCD:[0-9]+]]
   * CHECK: [[CA]] -> [[ACD:[0-9]+]]
   */

  /*
   * Graph footer:
   * CHECK: label = "{{.*inclusive-or2.c:[0-9]+#[0-9]+}}
   */
}
