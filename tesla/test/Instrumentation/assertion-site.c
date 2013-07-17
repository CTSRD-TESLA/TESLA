//! @file assertion-site.c  Tests instrumentation of assertion sites.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: FileCheck -input-file %t.instr.ll %s
 */

#include "tesla-macros.h"

void	foo(void);
void	bar(void);

int
main(int argc, char *argv[])
{
	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	// CHECK: call void @__tesla_instrumentation_assertion_reached_0()
	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	TESLA_WITHIN(main,
		TSEQUENCE(
			callee(called(foo)),
			TESLA_ASSERTION_SITE,
			callee(returned(bar))
		)
	);

	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	// CHECK: call void @__tesla_instrumentation_assertion_reached_1()
	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	TESLA_WITHIN(main,
		TSEQUENCE(
			caller(called(foo)),
			caller(returned(bar)),
			TESLA_ASSERTION_SITE
		)
	);

	return 0;
}

