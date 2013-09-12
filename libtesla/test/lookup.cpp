/**
 * @file lookup.cpp
 * Tests automata lookup.
 *
 * We should be able to look up automata by exact name or by using ANY.
 *
 * Commands for llvm-lit:
 * RUN: clang %cflags %ldflags %s -o %t
 * RUN: %t
 */

#include "tesla_internal.h"
#include "test_helpers.h"

#include <assert.h>
#include <err.h>
#include <stdio.h>


/** Some automata instances to look up (of more than one class). */
struct tesla_instance *instances[6];
const int32_t INSTANCES = sizeof(instances) / sizeof(instances[0]);

/** Create an instance of an automata class using three key values. */
void	create_instance(struct tesla_class*, struct tesla_instance**,
	                int32_t key0, int32_t key1, int32_t key2);

/**
 * Search through @ref instances using a pattern @ref tesla_key, returning a
 * bitmask of which instances were matched.
 */
int	search_for_pattern(struct tesla_class*, struct tesla_key *pattern);


struct tesla_lifetime shared_lifetime = {
	.tl_begin = {
		.tle_repr = "cleanup",
		.tle_length = sizeof("cleanup"),
		.tle_hash = 1,
	},
	.tl_end = {
		.tle_repr = "cleanup",
		.tle_length = sizeof("cleanup"),
		.tle_hash = 1,
	},
};

struct tesla_automaton glob = {
	.ta_name = "glob_automaton",
	.ta_description = "a class of TESLA automata",
	.ta_lifetime = &shared_lifetime,
};

struct tesla_automaton thr = {
	.ta_name = "thr_automaton",
	.ta_description = "a class of TESLA automata",
	.ta_lifetime = &shared_lifetime,
};

int
main(int argc, char **argv)
{
	install_default_signal_handler();

	struct tesla_store *global_store;
	struct tesla_class *glob_automaton;
	check(tesla_store_get(TESLA_CONTEXT_GLOBAL, 1, 3, &global_store));
	check(tesla_class_get(global_store, &glob, &glob_automaton));

	struct tesla_store *perthread_store;
	struct tesla_class *thr_automaton;
	check(tesla_store_get(TESLA_CONTEXT_THREAD, 1, 3, &perthread_store));
	check(tesla_class_get(perthread_store, &thr, &thr_automaton));

	/* Create some automata instances. */
	create_instance(glob_automaton, &instances[0], 42, 0, 1000);
	create_instance(glob_automaton, &instances[1], 43, 0, 1000);
	create_instance(glob_automaton, &instances[2], 42, 0, -1);
	create_instance(thr_automaton, &instances[3], 42, 0, 1000);
	create_instance(thr_automaton, &instances[4], 43, 1, 1000);
	create_instance(thr_automaton, &instances[5], 42, 1, -1);

	// Make sure they are all unique; this is n^2, but n is small.
	for (int32_t i = 0; i < INSTANCES; i++) {
		for (int32_t j = 0; j < INSTANCES; j++) {
			if (i == j) continue;
			assert(instances[i] != instances[j]);
		}
	}

	// Ok, let's go looking for automata instances!
	struct tesla_key pattern;

	// keys[0] == 42 => {0,2,3,5}
	pattern.tk_mask = 1 << 0;
	pattern.tk_keys[0] = 42;
	assert((search_for_pattern(glob_automaton, &pattern)
	        | search_for_pattern(thr_automaton, &pattern))
	       == 0x2D
	);

	// keys[1] == 0 => {0,1,2,3}
	pattern.tk_mask = 1 << 1;
	pattern.tk_keys[1] = 0;     // the value 0 is not special
	assert((search_for_pattern(glob_automaton, &pattern)
	        | search_for_pattern(thr_automaton, &pattern))
	       == 0x0F
	);

	// keys[2] == -1 => {2,5}
	pattern.tk_mask = 1 << 2;
	pattern.tk_keys[2] = -1;    // the value -1 is not special, either
	assert((search_for_pattern(glob_automaton, &pattern)
	        | search_for_pattern(thr_automaton, &pattern))
	       == 0x24
	);

	// keys[0] == 42 && keys[1] == 1 => {5}
	pattern.tk_mask = (1 << 0) + (1 << 1);
	pattern.tk_keys[0] = 42;
	pattern.tk_keys[1] = 1;
	assert((search_for_pattern(glob_automaton, &pattern)
	        | search_for_pattern(thr_automaton, &pattern))
	       == 0x20
	);

	// 'ANY' pattern => all
	pattern.tk_mask = 0;
	assert((search_for_pattern(glob_automaton, &pattern)
	        | search_for_pattern(thr_automaton, &pattern))
	       == 0x3F
	);

	tesla_class_put(glob_automaton);
	tesla_class_put(thr_automaton);

	return 0;
}


void
create_instance(struct tesla_class *tclass, struct tesla_instance **instance,
                int32_t key0, int32_t key1, int32_t key2)
{
	struct tesla_key key;
	key.tk_mask = 0x07;
	key.tk_keys[0] = key0;
	key.tk_keys[1] = key1;
	key.tk_keys[2] = key2;

	check(tesla_instance_new(tclass, &key, 0, instance));

	assert(instance != NULL);
}

int
search_for_pattern(struct tesla_class *tclass, struct tesla_key *pattern) {
	uint32_t len = 20;
	struct tesla_instance* matches[len];

	int found = 0;

	int32_t err = tesla_match(tclass, pattern, matches, &len);
	assert(err == TESLA_SUCCESS);
	assert(len >= 0);

	for (uint32_t i = 0; i < len; i++) {
		struct tesla_instance *inst = matches[i];
		assert(inst != NULL);

		for (uint32_t j = 0; j < INSTANCES; j++)
			if (inst == instances[j])
				found |= (1 << j);
	}

	return found;
}

