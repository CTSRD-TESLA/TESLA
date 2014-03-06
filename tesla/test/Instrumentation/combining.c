/*! @file combining.c
 *
 * Tests the combination of identical transitions into a single
 * @ref tesla_transitions struct.
 */
/*
 * Commands for llvm-lit:
 * RUN: mkdir -p %t
 * RUN: clang -S -emit-llvm %cflags %s -o %t/main.ll
 * RUN: tesla analyse %s -o %t/tesla -- %cflags
 * RUN: tesla instrument -S -tesla-manifest %t/tesla %t/main.ll -o %t/instr.ll
 * RUN: clang %ldflags %t/instr.ll -o %t/binary
 * RUN: %filecheck -check-prefix=INSTR -input-file %t/instr.ll %s
 * RUN: %t/binary | tee %t/out.txt
 * RUN: %filecheck -check-prefix=TESLA -input-file %t/out.txt %s
 */

#include <tesla-macros.h>

/*
 * Check that the instrumented IR contains a static struct tesla_transitions
 * with at least two transitions in it:
 *
 * INSTR: @"[[AUTO:.*]]_transitions" = internal constant [{{[2-9]}} x %tesla_transitions]
 * INSTR: @"[[AUTO]]" = {{.*}}"[[AUTO]]_transitions"
 */

static void
foo()
{
	/*
	 * INSTR: define internal void @foo()
	 * INSTR: call void @__tesla_instrumentation_callee_enter_foo
	 */
}


int
main(int argc, char *argv[])
{
	/*
	 * TESLA: [CALE] main
         * TESLA: sunrise per-thread (main(X,X){{.*}} -> main(X,X) == X{{.*}})
	 */

	/*
	 * INSTR: call void @tesla_update_state({{.*}}[[AUTO]]
	 *
	 * TESLA: [CALE] foo
	 * TESLA: new    0: [[INIT:1:0x0]] ('[[NAME:.*]]')
	 * TESLA: update 0: [[INIT]]->[[FOO:[0-9]+:0x0]]
	 */
	foo();

	/*
	 * TESLA: [ASRT]
	 * TESLA: update 0: [[FOO]]->[[NOW:[0-9]+:0x0]]
	 */
	TESLA_WITHIN(main,
		TSEQUENCE(
			call(foo),
			TESLA_ASSERTION_SITE,
			call(foo)
		)
	);

	/*
	 * TESLA: [CALE] foo
	 * TESLA: update 0: [[NOW]]->[[FOO2:[0-9]+:0x0]]
	 */
	foo();

	/*
	 * TESLA: [RETE] main
         * TESLA: sunset per-thread (main(X,X){{.*}} -> main(X,X) == X{{.*}})
	 * TESLA: update 0: [[FOO2]]->[[DONE:[0-9]+:0x0]]
	 * TESLA: pass '[[NAME]]': 0
	 * TESLA: tesla_class_reset [[NAME]]
	 */
	return 0;
}
