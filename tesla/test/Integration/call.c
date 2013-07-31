//! @file call.c  Tests basic caller and callee instrumentation.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
 * RUN: FileCheck -input-file %t.out %s
 */

#include <tesla-macros.h>

void	foo(void);
void	bar(void);

int
main(int argc, char *argv[])
{
	/*
	 * We should update state on entering main():
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: per-thread
	 * CHECK: transitions:  [ (0:0x0 -> [[INIT:[0-9]+]]:0x0 <init>) ]
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ----
	 * CHECK: new [[ID:[0-9]+]]
	 * CHECK: ----
	 * CHECK: ====
	 */


	// Update state again on calling foo():
	foo();
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: per-thread
	 * CHECK: transitions:  {{.*}} ([[INIT]]:0x0 -> [[FOO:[0-9]+]]:0x0)
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ----
	 * CHECK: update [[ID]]: [[INIT]]->[[FOO]]
	 * CHECK: ----
	 * CHECK: ====
	 */


	// Again on calling bar():
	bar();
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: per-thread
	 * CHECK: transitions:  {{.*}} ([[FOO]]:0x0 -> [[BAR:[0-9]+]]:0x0)
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ----
	 * CHECK: update [[ID]]: [[FOO]]->[[BAR]]
	 * CHECK: ----
	 * CHECK: ====
	 */


	// And finally, on the NOW event:
	TESLA_PERTHREAD(call(main), returnfrom(main),
		previously(
			TSEQUENCE(
				caller(call(foo)),
				callee(call(bar))
			)
		)
	);
	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: per-thread
	 * CHECK: transitions:
	 * CHECK:    ([[BAR]]:0x0 -> [[NOW:[0-9]+]]:0x0)
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ----
	 * CHECK: update [[ID]]: [[BAR]]->[[NOW]]
	 * CHECK: ----
	 * CHECK: ====
	 */

	/*
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: per-thread
	 * CHECK: transitions:
	 * CHECK:    ([[NOW]]:0x0 -> [[FINAL:[0-9]+]]:0x0 <clean>)
	 * CHECK: key:          0x0 [ X X X X ]
	 * CHECK: ----
	 * CHECK: update [[ID]]: [[NOW]]->[[FINAL]]
	 * CHECK: pass '{{.*}}': {{[0-9]+}}
	 * CHECK: ----
	 * CHECK: ====
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

