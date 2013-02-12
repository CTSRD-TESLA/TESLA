/**
 * @file update.c
 * Tests automata-updating behaviour.
 *
 * When an event is fired, it must be delivered to all automata instances that
 * care about it, even if they don't exist yet.
 *
 * We support this use case by forking automata: an automaton with a
 * non-specific name like (x,y,ANY) can be forked off into a more specific
 * automaton named (x,y,z).
 *
 * This test ensures that automata forking works correctly.
 */

#include <tesla/libtesla.h>
#include "tesla_internal.h"

#include <assert.h>
#include <err.h>
#include <stdio.h>

#include "helpers.h"

int	count(struct tesla_store*, const struct tesla_key*);

const int id = 0;
const char name[] = "demo class";
const char descrip[] = "a demonstration class of automata";

int
main(int argc, char **argv)
{
	install_default_signal_handler();

	const int scope = TESLA_SCOPE_GLOBAL;
	const int instances_in_class = 10;

	struct tesla_store *store;
	check(tesla_store_get(scope, 1, instances_in_class, &store));

	// Test the following sequence of automata update events:
	//
	// (X,X,X,X): 0->1       new    (X,X,X,X):1
	// (1,X,X,X): 1->2       fork   (X,X,X,X):1 -> (1,X,X,X):2
	// (1,2,X,X): 2->3       fork   (1,X,X,X):2 -> (1,2,X,X):3
	// (1,2,X,X): 3->4       update (1,X,X,X):4 -> (1,2,X,X):4
	// (2,X,X,X): 1->5       fork   (X,X,X,X):1 -> (2,X,X,X):5
	// (2,X,X,3): 5->6       fork   (2,X,X,X):5 -> (2,X,X,3):6
	// (2,X,X,4): 1->7       fork   (X,X,X,X):1 -> (2,X,X,4):7

	struct tesla_key key;
	const struct tesla_key
		any = { .tk_mask = 0 },
		one = { .tk_mask = 1, .tk_keys[0] = 1 },
		two = { .tk_mask = 1, .tk_keys[0] = 2 }
		;

	// (X,X,X,X): 0->1       new    (X,X,X,X):1
	key.tk_mask = 0;
	check(tesla_update_state(scope, id, &key, name, descrip, 0, 1));
	assert(count(store, &any) == 1);
	assert(count(store, &one) == 0);
	assert(count(store, &two) == 0);

	// (1,X,X,X): 1->2       fork   (X,X,X,X):1 -> (1,X,X,X):2
	key.tk_mask = 1;
	key.tk_keys[0] = 1;
	check(tesla_update_state(scope, id, &key, name, descrip, 1, 2));

	assert(count(store, &any) == 2);
	assert(count(store, &one) == 1);
	assert(count(store, &two) == 0);

	// (1,2,X,X): 2->3       fork   (1,X,X,X):2 -> (1,2,X,X):3
	key.tk_mask = 3;
	key.tk_keys[0] = 1;
	key.tk_keys[1] = 2;
	check(tesla_update_state(scope, id, &key, name, descrip, 2, 3));

	assert(count(store, &any) == 3);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 0);

	// (1,2,X,X): 3->4       update (1,X,X,X):4 -> (1,2,X,X):4
	key.tk_mask = 3;
	key.tk_keys[0] = 1;
	key.tk_keys[1] = 2;
	check(tesla_update_state(scope, id, &key, name, descrip, 3, 4));

	assert(count(store, &any) == 3);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 0);

	// (2,X,X,X): 1->5       fork   (X,X,X,X):1 -> (2,X,X,X):5
	key.tk_mask = 1;
	key.tk_keys[0] = 2;
	check(tesla_update_state(scope, id, &key, name, descrip, 1, 5));

	assert(count(store, &any) == 4);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 1);

	// (2,X,X,3): 5->6       fork   (2,X,X,X):5 -> (2,X,X,3):6
	key.tk_mask = 9;
	key.tk_keys[0] = 2;
	key.tk_keys[3] = 3;
	check(tesla_update_state(scope, id, &key, name, descrip, 5, 6));

	assert(count(store, &any) == 5);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 2);

	// (2,X,X,4): 1->7       fork   (X,X,X,X):1 -> (2,X,X,4):7
	key.tk_mask = 9;
	key.tk_keys[0] = 2;
	key.tk_keys[3] = 4;
	check(tesla_update_state(scope, id, &key, name, descrip, 1, 7));

	assert(count(store, &any) == 6);
	assert(count(store, &one) == 2);
	assert(count(store, &two) == 3);


	/*
	 * After all that, we should be left with the following automata:
	 *
	 * (X,X,X,X):1
	 * (1,X,X,X):2
	 * (1,2,X,X):3
	 * (2,X,X,X):4
	 * (2,X,X,3):5
	 * (2,X,X,4):6
	 */

	return 0;
}


int
count(struct tesla_store *store, const struct tesla_key *key)
{
	size_t len = 20;
	struct tesla_instance* matches[len];
	struct tesla_class *class;

	check(tesla_class_get(store, id, &class, name, descrip));

	check(tesla_match(class, key, matches, &len));

	tesla_class_put(class);

	return len;
}

