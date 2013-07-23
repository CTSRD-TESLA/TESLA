/**
 * @file no-such-function.c
 * Writing assertions about non-existent functions should cause errors.
 *
 * RUN: tesla analyse %s -o %t -- %cflags 2> %t.err || true
 * RUN: FileCheck -input-file=%t.err %s
 */

#include "tesla-macros.h"

int	context();
int     foo(int);

int foo(int x) {
	/*
         * CHECK: implicit declaration of function 'NONEXISTENT' is invalid
         */
	TESLA_WITHIN(context, previously(NONEXISTENT(x) == 0));
	return 0;
}
