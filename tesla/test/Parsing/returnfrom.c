//! @file returnfrom.c  Parse some returnfrom() patterns. */
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: tesla print -format=text -d -o %t.out %t.tesla
 * RUN: FileCheck -input-file %t.out %s
 */

#include <errno.h>
#include <stddef.h>

#include <tesla-macros.h>


int	foo(void);
int	bar(void);

int
context()
{
	/*
	 * CHECK: automaton '{{.*}}returnfrom.c:{{[0-9]+#[0-9]}}' {
	 * CHECK:   foo() == X
	 * CHECK: }
	 */
	TESLA_WITHIN(context, previously(returnfrom(foo)));

	/*
	 * CHECK: automaton '{{.*}}returnfrom.c:{{[0-9]+#[0-9]}}' {
	 * CHECK:   foo() == X
	 * CHECK: }
	 */
	TESLA_WITHIN(context, previously(returnfrom(foo())));

	/*
	 * CHECK: automaton '{{.*}}returnfrom.c:{{[0-9]+#[0-9]}}' {
	 * CHECK:   foo() == 0
	 * CHECK: }
	 */
	TESLA_WITHIN(context, previously(returnfrom(foo() == 0)));

	return 0;
}
