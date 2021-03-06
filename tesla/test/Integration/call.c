//! @file call.c  Tests basic caller and callee instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
 * RUN: %filecheck -input-file %t.out %s
 */

#include <tesla-macros.h>

void	foo(void);
void	bar(void);

int
main(int argc, char *argv[])
{
	/*
	 * We should note that we've entered main():
	 *
	 * CHECK: [CALE] main
         * CHECK: sunrise per-thread (main(X,X){{.*}} -> main(X,X) == X{{.*}})
	 */


	/*
	 * Update state on calling foo():
	 *
	 * CHECK: [CALR] foo
	 * CHECK: new    0: [[INIT:[0-9]+:0x0]] ('[[NAME:.*]]')
	 * CHECK: update 0: [[INIT]]->[[FOO:[0-9]+:0x0]]
	 */
	foo();


	/*
	 * Again on calling bar():
	 *
	 * CHECK: [CALE] bar
	 * CHECK: update 0: [[FOO]]->[[BAR:[0-9]+:0x0]]
	 */
	bar();


	/*
	 * Next we reach the assertion:
	 *
	 * CHECK: [ASRT]
	 * CHECK: update 0: [[BAR]]->[[NOW:[0-9]+:0x0]]
	 */
	TESLA_PERTHREAD(call(main), returnfrom(main),
		previously(
			TSEQUENCE(
				caller(call(foo)),
				callee(call(bar))
			)
		)
	);


	/*
	 * Finally, we leave the context:
	 *
	 * CHECK: [RETE] main
         * CHECK: sunset per-thread (main(X,X){{.*}} -> main(X,X) == X{{.*}})
	 * CHECK: update 0: [[NOW]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[NAME]]': 0
	 * CHECK: tesla_class_reset [[NAME]]
	 */

	return 0;
}


void
foo()
{
}

void
bar()
{
}
