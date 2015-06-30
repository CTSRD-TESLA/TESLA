//! @file assertion-site.c  Tests instrumentation of assertion sites.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: %filecheck -input-file %t.instr.ll %s
 *
 * XFAIL: *
 */

#include <tesla-macros.h>

void	foo(void);
void	bar(void);

int
main(int argc, char *argv[])
{
	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	// CHECK: call void @{{.*}}_tesla_instrumentation_assertion_{{.*}}()
	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	TESLA_WITHIN(main,
		TSEQUENCE(
			callee(call(foo)),
			TESLA_ASSERTION_SITE,
			callee(returnfrom(bar))
		)
	);

	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	// CHECK: call void @{{.*}}_tesla_instrumentation_assertion_{{.*}}()
	// CHECK-NOT: call void {{.*}}@__tesla_inline_assertion
	TESLA_WITHIN(main,
		TSEQUENCE(
			caller(call(foo)),
			caller(returnfrom(bar)),
			TESLA_ASSERTION_SITE
		)
	);

	return 0;
}

