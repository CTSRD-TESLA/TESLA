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

	/* TODO: write more libtesla code to actually support forking */

	return 0;
}

