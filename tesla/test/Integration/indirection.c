/**
 * @file indirection.c
 * Check instrumentation of values passed or returned indirectly, via pointer.
 *
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: clang %cflags -emit-llvm -S -o %t.ll %s
 * RUN: tesla instrument -S -tesla-manifest %t.tesla -o %t.instr.ll %t.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
 * RUN: FileCheck -input-file=%t.out %s
 */

#include <tesla-macros.h>

struct object {};

int	main(int argc, char *argv[]);
int	get_object(int index, struct object* *obj_out);

void foo(struct object *o) {
	TESLA_WITHIN(main, previously(get_object(ANY(int), &o) == 0));
}

int
main(int argc, char *argv[])
{
	/*
	 * CHECK: [CALE] main
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: class: 0 ('[[NAME:.*]]')
	 * CHECK: transitions:  [ (0:0x0 -> 1:0x0 <init>) ]
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: new    0: 1
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ====
	 */
	struct object *o;

	/*
	 * CHECK: [RETE] get_object 0 [[OBJ_PTR:0x[0-9a-f]+]] 0
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: transitions: [ (1:0x0 -> 2:0x1)
	 * CHECK: key: 0x1 [ [[OBJ:[0-9a-f]+]] X
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: clone 0:1 -> 1:2
	 * CHECK: ----
	 * CHECK: ====
	 */
	get_object(0, &o);

	/*
	 * CHECK: [ASRT] automaton 0
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: key: 0x1 [ [[OBJ:[0-9a-f]+]] X
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: update 1: 2->[[FOO:[0-9]+]]
	 * CHECK: ----
	 * CHECK: ====
	 */
	foo(o);

	/*
	 * CHECK: [RETE] main
	 *
	 * CHECK: ====
	 * CHECK: tesla_update_state
	 * CHECK: <clean>
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: ----
	 * CHECK: pass '[[NAME]]'
	 * CHECK: tesla_class_reset
	 * CHECK: ----
	 * CHECK: ====
	 */
	return 0;
}

int
get_object(int i, struct object* *obj_out)
{
	static struct object objects[4];

	*obj_out = objects + i;
	return 0;
}
