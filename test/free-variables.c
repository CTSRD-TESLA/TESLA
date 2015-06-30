/**
 * @file Instrumentation/free-variables.c
 * Allow programmers to specify variables that can be used in pattern
 * matching but which are unknown at the assertion site.
 *
 * This requires the GCC expression-of-statements extension.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: %filecheck -input-file %t.instr.ll %s
 *
 * XFAIL: *
 */

#include <tesla-macros.h>

// CHECK: call void @[[INSTR:__tesla_instrumentation]]_callee_return_foo
int	foo(int x) { return 0; }

// CHECK: call void @[[INSTR]]_callee_return_bar(i32 %x, i32 0)
int	bar(int x) { return 0; }

// CHECK: call void @[[INSTR]]_callee_return_baz(i32 %x, i32 0)
int	baz(int x) { return 0; }

int	main(int, char *[]);

void	do_some_work()
{
	// CHECK: call void @"[[INSTR]]_assertion_
	TESLA_WITHIN(main, previously(({
		int x;

		foo(x) == 0;
		bar(x) == 0;
		baz(x) == 0;
	})));
}

int main(int argc, char *argv[])
{
	// CHECK: call void @[[INSTR]]_callee_enter_main

	int x = 42;
	int y = 42;

	foo(x);
	bar(y);
	baz(42);

	do_some_work();

	// CHECK: call void @[[INSTR]]_callee_return_main({{.*}}, i32 0)
	return 0;
}

/*
 * The assertion instrumentation shouldn't set any values in the tesla_key
 * except for the mask (0) and free variable mask (1).
 *
 * CHECK: define internal void @"[[INSTR]]_assertion
 * CHECK: "assertion_reached:instr":
 * CHECK-NEXT: %key = alloca
 * CHECK-NEXT: %[[MASK:[0-9]+]] = getelementptr inbounds %tesla_key
 * CHECK-NEXT: store i32 0, i32* %[[MASK]]
 * CHECK-NEXT: %[[FREEMASK:[0-9]+]] = getelementptr inbounds %tesla_key
 * CHECK-NEXT: store i32 1, i32* %[[FREEMASK]]
 * CHECK-NEXT: call void @tesla_update_state({{.*}} %tesla_key* %key
 * CHECK-NEXT: br label %exit
 */
