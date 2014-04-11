/**
 * @file Instrumentation/free-variables-mismatch.c
 * Check that, when we use a free variable to bind events together, we do
 * actually bind events with the same value.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t > %t.out 2> %t.out || true
 * RUN: %filecheck -input-file %t.out %s
 */

#include <tesla-macros.h>

int	foo(int x) { return 0; }
int	bar(int x) { return 0; }
int	baz(int x) { return 0; }
int	main(int, char *[]);

void	do_some_work()
{
	TESLA_WITHIN(main, previously(({
		int x;

		foo(x) == 0;
		bar(x) == 0;
		baz(x) == 0;
	})));
}

int main(int argc, char *argv[])
{
	/*
	 * CHECK: [CALE] main
	 * CHECK-NEXT: sunrise  per-thread (main(X,X): Entry (Callee)
	 */

	int x = 42;
	int y = 42;

	foo(x);
	/*
	 * CHECK: [RETE] foo 42 0
	 * CHECK-NEXT: new   [[GENERAL:[0-9]+]]: [[INIT:[0-9]+]]:0x0
	 * CHECK-NEXT: clone [[GENERAL]]:[[INIT]]:0x0
	 * CHECK:         -> [[SPECIFIC:[0-9]+]]:[[FOO:[0-9]+]]:0x1
	 */

	bar(y);
	/*
	 * CHECK: [RETE] bar 42 0
	 * CHECK: update [[SPECIFIC]]: [[FOO]]:0x1->[[BAR:[0-9]+]]:0x1
	 */

	baz(43);
	/*
	 * CHECK: [RETE] baz 43 0
	 * CHECK-NOT: update [[SPECIFIC]]: [[BAR]]:0x1->[[BAZ:[0-9]+]]:0x1
	 */

	do_some_work();
	/*
	 * CHECK: [ASRT] automaton
	 * CHECK: Instance [[SPECIFIC]] is in state [[BAR]]
	 * CHECK-NEXT: but received event '{{.*}}<<assertion>>{{.*}}'
	 * CHECK-NEXT: causes transition in: [ ({{[0-9]+}}:0x1 -> {{[0-9]+}}:0x1) ]
	 */

	return 0;
}
