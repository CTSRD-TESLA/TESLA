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
int	e(int);
int	f(int);

void ab() {
  /*
   * Test a `inclusive-or` b:
   * This should produce the following automaton:
   *
   * = (prefix*(a) || b) | (a || prefix*(b)) | (a || b)
   * = (Ã¸ || b          | (a || Ã¸          | (a || b)
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
   * CHECK: label = "ab(){{.*}}Entry{{.*}}init{{.*}}
   * CHECK: 0 -> [[CALL:[0-9]+]]
   *
   * a(x): [ 1->2, 1->5, 6->4 ]
   * CHECK: label = "a(x)
   * CHECK: [[CALL]] -> [[A1:[0-9]+]]
   * CHECK: [[CALL]] -> [[A2:[0-9]+]]
   * CHECK: [[B2:[0-9]+]] -> [[Final:[0-9]+]]
   *
   * b(y): [ 1->3, 1->6, 5->4 ]
   * CHECK: label = "b(y)
   * CHECK: [[CALL]] -> [[B1:[0-9]+]]
   * CHECK: [[A2]] -> [[Final]]
   * CHECK: [[CALL]] -> [[B2]]
   *
   * ø: [ 2->4, 3->4 ]
   * CHECK: label = "[[EPSILON:&#[0-9a-f]+;]]"
   * CHECK: [[A1]] -> [[Final]]
   * CHECK: [[B1]] -> [[Final]]
   */

  /*
   * Graph footer:
   * CHECK: label = "{{.*inclusive-or.c:[0-9]+#[0-9]+}}"
   */
}

// TODO: write this test
void abcd() {
  /*
   * Test ab `inclusive-or` cd:
   * This should produce the following automaton:
   *
   * = (prefix*(ab) || cd)         | (ab || prefix*(cd))          | (ab || cd)
   * = (Ã || cd) | (a || cd)       | (ab || c)       | (ab || Ã¸) | (ab || cd)
   * =
   * = cd        | acd | cad | cda | abc | acb | cab | ab         | a (b || cd)        | c (ab || d)
   * = cd        | acd | cad | cda | abc | acb | cab | ab         | abcd | acbd | acdb | cabd | cadb | cdab
   */
  /*int w, x, y, z;
  __tesla_inline_assertion("example.c", __LINE__, __COUNTER__,
                           __tesla_perthread,
                           __tesla_sequence (
                             a(w) == 0,
                             b(x) == 0
                           )
                           ||
                           __tesla_sequence(
                             c(y) == 0,
                             d(z) == 0
                           )
  );*/
}
