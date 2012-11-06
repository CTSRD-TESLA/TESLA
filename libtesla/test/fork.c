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

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include <stdio.h>


int
main(int argc, char **argv)
{
	printf("Creating new TESLA class... ");
	int err;
	struct tesla_class *class;
	err = tesla_class_new(&class, TESLA_SCOPE_PERTHREAD, 23,
		"classA", "a class of TESLA automata");
	if (err) {
		printf("error: '%s'\n", tesla_strerror(err));
		return 1;
	}
	printf("done.\n");

	/* TODO: write more libtesla code to actually support forking */

	return 0;
}

