/**
 * @file multicat.c
 * We should be able to 'cat' together multiple copies of an automaton
 * and resolve them, so long as they are all exactly equivalent.
 *
 * First create several .tesla files:
 * RUN: tesla analyse %s -o %t.good1.tesla -- %cflags
 * RUN: tesla analyse %s -o %t.good2.tesla -- %cflags
 * RUN: tesla analyse %s -o %t.bad.tesla -- %cflags -D BAD_ROBOT
 *
 * It is an error to 'tesla cat' different definitions with the same name:
 * RUN: tesla cat %t.good1.tesla %t.bad.tesla -o %t.err.tesla 2> %t.err || true
 * RUN: FileCheck %s -check-prefix=ERR -input-file %t.err
 * RUN: test -e %t.err.tesla || false
 *
 * Concatenate files with identical definitions is supported:
 * RUN: tesla cat %t.good1.tesla %t.good2.tesla -o %t.cat.tesla
 * RUN: FileCheck %s -check-prefix=AUTO -input-file %t.cat.tesla
 * RUN: FileCheck %s -check-prefix=ROOT -input-file %t.cat.tesla
 */

#include "tesla-macros.h"

int	context();
int	foo();
int	bar();
int	baz();

/*
 * One variation of this file (-D BAD_ROBOT) should have
 * a subtly different automaton than the others:
 *
 * ERR: Attempting to cat two files containing
 * ERR: not exactly the same
 */
#ifdef	BAD_ROBOT
#define	EXPR()	returned(foo)
#else
#define	EXPR()	foo() == 0
#endif

int foo() {
	TESLA_WITHIN(context, previously(EXPR()));

	/*
	 * We should have one copy of the automaton in the output file:
	 *
	 * AUTO:      automaton {
	 * AUTO-NEXT:   identifier {
	 * AUTO-NEXT:     location {
	 * AUTO-NEXT:       filename: "{{.*}}multicat.c"
	 *
	 * But not two:
	 *
	 * AUTO-NOT:  automaton {
	 */

	/*
	 * Similarly, we should only have a 'root' usage (specification of
	 * how an automaton should be grafted into the program lifetime):
	 *
	 * ROOT:      root {
	 * ROOT-NEXT:   identifier {
	 * ROOT-NEXT:     location {
	 * ROOT-NEXT:       filename: "{{.*}}multicat.c"
	 *
	 * But not two:
	 *
	 * ROOT-NOT:  root {
	 */

	return 0;
}
