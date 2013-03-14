/**
 * Test that the inclusive OR is correctly implemented.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla graph -l %t.tesla -o %t.dot
 * RUN: FileCheck -input-file=%t.dot %s
 *
 * XFAIL: *
 */

#include <tesla.h>

int	a(int);
int	b(int);
int	c(int);
int	d(int);
int	e(int);
int	f(int);

// CHECK: digraph automaton_{{[0-9]+}}

int main(int argc, char *argv[]) {
	int x, y, z;

	/*
	 * This simple assertion should result in a not-so-simple automaton:
	 *
	 * abc 'inclusive-or' def
	 * = (prefix*(abc) || def) | (abc || prefix*(def))
	 * = ((ab?)? || def) | (abc || (de?)?)
	 * = (∅|a|ab || def) | (abc || ∅|d|de)
	 * = (def | (a || def) | (ab || def)) | (abc | (abc || d) | (abc || de))
	 * = (def
	 *    | (adef | daef | deaf | defa)
	 *    | (abdef | adbef | adebf | adefb
	 *       | dabef | daebf | daefb
	 *       | deabf | deafb
	 *       | defab)
	 *   )
	 *   |
	 *   (abc
	 *    | (abcd | abdc | adbc | dabc)
	 *    | (abcde | abdce | adbce | dabce
	 *       | abdec | adbec | dabec
	 *       | adebc | daebc
	 *       | deabc)
	 *   )
	 * = def | adef | daef | deaf | defa | abdef | adbef | adebf | adefb
	 *   | dabef | daebf | daefb | deabf | deafb | defab
	 *   | abc | abcd | abdc | adbc | dabc | abcde | abdce | adbce | dabce
	 *   | abdec | adbec | dabec | adebc | daebc | deabc
	 *
	 * = abc | abcd | abcde | abdc | abdce | abdec | abdef
	 *   | adbc | adbce | adbec | adbef | adebc | adebf | adef | adefb
	 *   | dabc | dabce | dabec | dabef | daebc | daebf
	 *   | daef | daefb | deabc | deabf | deaf | deafb
	 *   | def | defa | defab
	 *
	 * = a(b(c | c(d|de) | d(c|ce|ec|ef)))
	 *   | d(b(c | ce | e(c|f)) | e(b(c|f) | f | fb))
	 *
	 */
	__tesla_inline_assertion("example.c", __LINE__, __COUNTER__,
	                         __tesla_perthread,
	                         __tesla_sequence(
	                             a(x) == 0,
	                             b(y) == 0,
	                             c(z) == 0
	                         )
	                         ||
	                         __tesla_sequence(
	                             d(x) == 0,
	                             e(y) == 0,
	                             f(z) == 0
	                         )
	);
	/*
	 * CHECK: 0 -> [[A:[0-9]+]] [ label = "a(x)
	 * CHECK: 0 -> [[D:[0-9]+]] [ label = "d(x)
	 *
	 * CHECK: [[A]] -> [[AB:[0-9]+]]
	 * CHECK: [[A]] -> [[AC:[0-9]+]]
	 * CHECK: [[A]] -> [[AD:[0-9]+]]
	 *
	 * CHECK: [[AB]] -> [[ABC:[0-9]+]]
	 * CHECK: [[AB]] -> [[ABD:[0-9]+]]
	 *
	 * CHECK: [[ABC]] -> [[ABCD:[0-9]+]]
	 *
	 * CHECK: [[ABCD]] -> [[ABCDE:[0-9]+]]
	 *
	 * CHECK: [[ABD]] -> [[ABDC:[0-9]+]]
	 * CHECK: [[ABD]] -> [[ABDE:[0-9]+]]
	 *
	 * CHECK: [[ABDC]] -> [[ABDCE:[0-9]+]]
	 *
	 * CHECK: [[ABDE]] -> [[ABDEC:[0-9]+]]
	 * CHECK: [[ABDE]] -> [[ABDEF:[0-9]+]]
	 *
	 * etc.
	 */
}

// CHECK: label = "example.c:61#0"

