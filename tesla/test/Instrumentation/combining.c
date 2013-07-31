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
 * RUN: FileCheck -check-prefix=INSTR -input-file %t/instr.ll %s
 * RUN: %t/binary | tee %t/out.txt
 * RUN: FileCheck -check-prefix=TESLA -input-file %t/out.txt %s
 */

#include <tesla-macros.h>

/*
 * Check that the instrumented IR contains a static struct tesla_transitions
 * with at least two transitions in it:
 *
 * INSTR: [[TSET:@transitions[0-9]*]] = {{.*}} %tesla_transitions { i32 {{[2-9]}}
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
	 * TESLA: ====
	 * TESLA: ----
	 * TESLA: ----
	 * TESLA: new 0: [[INIT:[0-9]+]]
	 * TESLA: ----
	 * TESLA: ----
	 * TESLA: ====
	 */

	/*
	 * INSTR: call void @tesla_update_state({{.*}}[[TSET]]
	 *
	 * TESLA: ====
	 * TESLA: ([[INIT]]:0x0 -> [[FOO:[0-9]+]]:0x0) ({{[0-9]+}}:0x0 ->
	 * TESLA: ----
	 * TESLA: ----
	 * TESLA: update 0: [[INIT]]->[[FOO]]
	 * TESLA: ----
	 * TESLA: ----
	 * TESLA: ====
	 */
	foo();

	/*
	 * TESLA: ====
	 * TESLA: transitions:  [ ([[FOO]]:0x0 -> [[NOW:[0-9]+]]:0x0) ]
	 * TESLA: ----
	 * TESLA: ----
	 * TESLA: ----
	 * TESLA: update 0: [[FOO]]->[[NOW]]
	 * TESLA: ----
	 * TESLA: ====
	 */
	TESLA_WITHIN(main,
		TSEQUENCE(
			call(foo),
			TESLA_ASSERTION_SITE,
			call(foo)
		)
	);

	/*
	 * TESLA: ====
	 * TESLA: transitions:
	 * TESLA: ([[INIT]]:0x0 -> [[FOO]]:0x0)
	 * TESLA: ([[NOW]]:0x0 -> [[F2:[0-9]+]]:0x0)
	 * TESLA: ----
	 * TESLA: update 0: [[NOW]]->[[F2]]
	 * TESLA: ----
	 * TESLA: ====
	 */
	foo();

	return 0;
}
