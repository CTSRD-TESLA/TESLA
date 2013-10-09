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
         * CHECK: sunrise
	 */
	struct object *o;

	/*
	 * CHECK: [RETE] get_object 0 [[OBJ_PTR:0x[0-9a-f]+]] 0
	 * CHECK: new    [[INST0:[0-9]+]]: [[INIT:1:0x0]]
	 * CHECK: clone  [[INST0]]:[[INIT]] -> [[INST1:[0-9]+]]:[[OBJ:[0-9]+:0x1]]
	 */
	get_object(0, &o);

	/*
	 * CHECK: [ASRT] automaton 0
	 * CHECK: update [[INST1]]: [[OBJ]]->[[NOW:[0-9]+:0x1]]
	 */
	foo(o);

	/*
	 * CHECK: [RETE] main
         * CHECK: sunset
	 * CHECK: [[INST0]]: [[INIT]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[NAME:.*]]': [[INST0]]
	 * CHECK: [[INST1]]: [[NOW]]->[[DONE:[0-9]+:0x0]]
	 * CHECK: pass '[[NAME:.*]]': [[INST1]]
	 * CHECK: tesla_class_reset [[NAME]]
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
