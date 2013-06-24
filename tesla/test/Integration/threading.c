//! @file hold.c  Tests instrumentation of 'hold' event.
/*
 * Commands for llvm-lit:
 * RUN: tesla analyse %s -o %t.tesla -- %cflags -D TESLA
 * RUN: clang -S -emit-llvm %cflags %s -o %t.ll
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t | tee %t.out
 * RUN: FileCheck -input-file %t.out %s
 */

#include <assert.h>
#include <errno.h>
#include <pthread.h>
#include <stddef.h>

#include "tesla-macros.h"


/*
 * A few declarations of things that look a bit like real code:
 */
struct object {
	int	refcount;
};

static struct object objects[] = {
	{ .refcount = 0 },
	/*
	 * just one thread for now:
	 * FileCheck can't express arbitrary interleavings.
	 *
	{ .refcount = 0 },
	{ .refcount = 0 },
	{ .refcount = 0 }
	*/
};
const static size_t LEN = sizeof(objects) / sizeof(objects[0]);


/*
 * Some functions we can reference in assertions:
 */
static void	hold(struct object *o) { o->refcount += 1; }

static void
release(struct object *o)
{
	assert(o->refcount >= 1);
	o->refcount -= 1;
}

void
worker(int index)
{
	struct object *obj = objects + index;
	hold(obj);

	TESLA_WITHIN(worker, previously(called(hold(obj))));
	TESLA_WITHIN(worker, eventually(called(release(obj))));

	release(obj);
}


void*
thread_fn(void *indexp)
{
	worker(*((int*) indexp));
	pthread_exit(indexp);

	return NULL;
}


int
main(int argc, char *argv[]) {
	int indices[LEN];
	pthread_t threads[LEN];

	for (size_t i = 0; i < LEN; i++)
		indices[i] = i;

	for (size_t i = 0; i < LEN; i++) {
		int err = pthread_create(threads + i, NULL, thread_fn,
		                         indices + i);
		assert(err == 0);
	}

	/*
	 * It would be nice to check for both assertions' reset events, but
	 * FileCheck will only let us test things whose ordering is known;
	 * arbitrary interleavings are possible here.
	 *
	 * CHECK: tesla_class_reset [[ASSERT:.*threading.c:[0-9]+#[0-9]+]]
	 * CHECK-NOT: tesla_class_reset [[ASSERT]]
	 */

	for (size_t i = 0; i < LEN; i++) {
		void *retval;
		int err = pthread_join(threads[i], &retval);

		assert(err == 0);
		assert(retval == indices + i);
	}

	/*
	 * CHECK: tesla_store_free
	 * CHECK-NOT: tesla_store_free
	 */

	return 0;
}

