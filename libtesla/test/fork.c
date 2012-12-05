/**
 * @file fork.c
 * Tests automata-forking behaviour.
 *
 * When an event is fired, it must be delivered to all automata instances that
 * care about it, even if they don't exist yet.
 *
 * We will support this use case by forking automata: an automaton with a
 * non-specific name like (x,y,ANY) can be forked off into a more specific
 * automaton named (x,y,z).
 *
 * Forking should happen transparently to the event-translation code: once an
 * event is translated into foo(x,y,z), the lookup of (x,y,z) automatically
 * triggers a fork, and the event 'foo' is only dispatched to the automaton
 * named (x,y,z). After that, (x,y,z) and (x,y,ANY) will be in different
 * states.
 *
 * This test ensures that automata forking works correctly.
 */

#include <tesla/libtesla.h>

#include <assert.h>
#include <err.h>
#include <stdio.h>

#include "helpers.h"


int
main(int argc, char **argv)
{
	install_default_signal_handler();

	struct tesla_store *global_store, *perthread;
	assert(tesla_store_get(TESLA_SCOPE_GLOBAL, 1, 5, &global_store) == 0);
	assert(tesla_store_get(TESLA_SCOPE_PERTHREAD, 1, 5, &perthread) == 0);

	struct tesla_class *class;
	check(tesla_class_get(perthread, 0, &class,
		"classA", "a class of TESLA automata"));

	struct tesla_key general, specific;

	general.tk_mask = 1;
	general.tk_keys[0] = 42;

	specific.tk_mask = 0xF;
	specific.tk_keys[0] = 42;
	specific.tk_keys[1] = 1;
	specific.tk_keys[2] = 2;
	specific.tk_keys[3] = 3;

	struct tesla_instance *general_instance;
	check(tesla_instance_get(class, &general, &general_instance));

	struct tesla_iterator *iter;
	check(tesla_match(class, &specific, &iter));

	int count = 0;
	while (tesla_hasnext(iter)) {
		struct tesla_instance *inst = tesla_next(iter);
		assert(inst->ti_state == 0);

		assert(inst->ti_key.tk_mask == specific.tk_mask);
		assert(inst->ti_key.tk_keys[0] == specific.tk_keys[0]);
		assert(inst->ti_key.tk_keys[1] == specific.tk_keys[1]);
		assert(inst->ti_key.tk_keys[2] == specific.tk_keys[2]);
		assert(inst->ti_key.tk_keys[3] == specific.tk_keys[3]);

		count++;
	}

	tesla_iterator_free(iter);

	assert(count == 1);

	return 0;
}

