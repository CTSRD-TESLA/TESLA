/**
 * Test that the inclusive OR is correctly implemented.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla graph -n %t.tesla -o %t.dot
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
   * CHECKX: label = "ab(){{.*}}Entry{{.*}}init{{.*}}
   * CHECKX: 0 -> [[CALL:[0-9]+]]
   *
   * a(x): [ 8->11, 2->5, 1->1, 7->13, 9->12 ]
   * CHECKX: label = "a(x)
   * CHECKX: [[C:[0-9]]] -> [[CA:[0-9]+]]
   * CHECKX: [[INIT1:[0-9]+]] -> [[A:[0-9]+]]
   * CHECKX: [[IGNORE1:[0-9]+]] -> [[IGNORE2:[0-9]+]]
   * CHECKX: [[CDEps:[0-9]+]] -> [[CDEpsA:[0-9]+]]
   * CHECKX: [[CD:[0-9]+]] -> [[CDA:[0-9]+]]
   *
   * b(y): [ 5->6, 13->16, 1->1, 11->14, 12->15 ]
   * CHECKX: label = "b(y)
   * CHECKX: [[A]] -> [[AB:[0-9]+]]
   * CHECKX: [[CDEpsA]] -> [[CDEpsAB:[0-9]+]]
   * CHECKX: [[CA]] -> [[CAB:[0-9]+]]
   * CHECKX: [[CDA]] -> [[CDAB:[0-9]+]]
   *
   * ø: [ 4->10, 7->10, 12->13, 6->4, 9->7, 1->2, 1->3, 18->19, 17->10, 18->10, 19->10, 13->10, 15->16, 16->10]
   * CHECKX: label = "[[EPSILON:&#[0-9a-f]+;]]"
   * CHECKX: [[CALL]] -> [[INIT1]]
   * CHECKX: [[CALL]] -> [[INIT2:[0-9]+]]
   *
   * c(z): [ 3->8, 4->17, 1->1, 6->14, 5->11 ]
   * CHECKX: label = "c(z)
   * CHECKX: [[INIT2]] -> [[C]]
   * CHECKX: [[ABEps:[0-9]+]] -> [[ABEpsC:[0-9]+]]
   * CHECKX: [[AB]] -> [[CAB]]
   * CHECKX: [[A]] -> [[CA]]
   *
   * d(p): [ 8->9, 14->15, 1->1, 17->18, 11->12 ]
   * CHECKX: label = "d(p)
   * CHECKX: [[C]] -> [[CD:[0-9]+]]
   * CHECKX: [[CAB]] -> [[CABD:[0-9]+]]
   * CHECKX: [[ABEpsC]] -> [[ABEpsCD:[0-9]+]]
   * CHECKX: [[CA]] -> [[ACD:[0-9]+]]
   */

  /*
   * Graph footer:
   * CHECK: label = "{{.*inclusive-or2.c:[0-9]+#[0-9]+}}
   */
}
