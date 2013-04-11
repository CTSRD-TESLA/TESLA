/**
 * Test that the inclusive OR is correctly implemented.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla graph -l %t.tesla -o %t.dot
 * RUN: FileCheck -input-file=%t.dot %s
 * 
 */

#include "Inputs/tesla-macros.h"

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
   */
  // CHECK: digraph automaton_{{[0-9]+}}
  int x, y;
  __tesla_inline_assertion("example.c", __LINE__, __COUNTER__, 
                           __tesla_perthread, 
                           called(ab), 
                           returned(ab), 
                           a(x)==0 
                           || 
                           b(y)==0
                          );
  // 0 -- ab() --> 1
  // CHECK: 0 -> [[CALL:[0-9]+]] [ label = "ab()
  // 1 -- a(x) --> 2
  // CHECK: [[CALL]] -> [[A1:[0-9]+]] [ label = "a(x)
  // 1 -- b(y) --> 3
  // CHECK: [[CALL]] -> [[B1:[0-9]+]] [ label = "b(y)
  // 1 -- a(x) --> 5
  // CHECK: [[CALL]] -> [[A3:[0-9]+]] [ label = "a(x)
  // 1 -- b(y) --> 6
  // CHECK: [[CALL]] -> [[B3:[0-9]+]] [ label = "b(y)
  // 2 -- ø --> 4
  // CHECK: [[A1]] -> [[Final:[0-9]+]] [ label = "&#949;
  // 3 -- ø --> 4
  // CHECK: [[B1]] -> [[Final]] [ label = "&#949;
  // 5 -- b(y) --> 4
  // CHECK: [[A3]] -> [[Final]] [ label = "b(y)
  // 6 -- a(x) --> 4
  // CHECK: [[B3]] -> [[Final]] [ label = "a(x)

  // CHECK: label = "{{example.c:[0-9]+#[0-9]+}}"
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

