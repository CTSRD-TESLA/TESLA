/**
 * @file lookup.c
 * Tests automata lookup.
 *
 * We should be able to look up automata by exact name or by using ANY.
 */

#include <tesla/tesla.h>
#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include <assert.h>
#include <err.h>
#include <stdio.h>



/** Some automata instances to look up (of more than one class). */
struct tesla_instance *instances[6];
const size_t INSTANCES = sizeof(instances) / sizeof(instances[0]);

/** Create an instance of an automata class using three key values. */
void	create_instance(struct tesla_class*, struct tesla_instance**,
	                register_t key0, register_t key1, register_t key2);

/**
 * Search through @ref instances using a pattern @ref tesla_key, returning a
 * bitmask of which instances were matched.
 */
int	search_for_pattern(struct tesla_class*, struct tesla_key *pattern);

int
main(int argc, char **argv)
{
	int err;

	/* Create two classes of automata: 'classA' and 'classB'. */
	struct tesla_class *classA;
	err = tesla_class_new(&classA, TESLA_SCOPE_PERTHREAD, 23,
		"classA", "a class of TESLA automata");
	if (err)
		errx(1, "error in 'new': %s\n", tesla_strerror(err));

	struct tesla_class *classB;
	err = tesla_class_new(&classB, TESLA_SCOPE_GLOBAL, 23,
		"classB", "another class of TESLA automata");
	if (err)
		errx(1, "error in 'new': %s\n", tesla_strerror(err));

	/* Create some automata instances. */
	create_instance(classA, &instances[0], 42, 0, 1000);
	create_instance(classA, &instances[1], 43, 0, 1000);
	create_instance(classA, &instances[2], 42, 0, -1);
	create_instance(classB, &instances[3], 42, 0, 1000);
	create_instance(classB, &instances[4], 43, 1, 1000);
	create_instance(classB, &instances[5], 42, 1, -1);

	// Make sure they are all unique; this is n^2, but n is small.
	for (size_t i = 0; i < INSTANCES; i++) {
		for (size_t j = 0; j < INSTANCES; j++) {
			if (i == j) continue;
			assert(instances[i] != instances[j]);
		}
	}

	// Ok, let's go looking for automata instances!
	struct tesla_key pattern;

	// keys[0] == 42 => {0,2,3,5}
	pattern.tk_mask = 1 << 0;
	pattern.tk_keys[0] = 42;
	assert((search_for_pattern(classA, &pattern)
	        | search_for_pattern(classB, &pattern))
	       == 0x2D
	);

	// keys[1] == 0 => {0,1,2,3}
	pattern.tk_mask = 1 << 1;
	pattern.tk_keys[1] = 0;     // the value 0 is not special
	assert((search_for_pattern(classA, &pattern)
	        | search_for_pattern(classB, &pattern))
	       == 0x0F
	);

	// keys[2] == -1 => {2,5}
	pattern.tk_mask = 1 << 2;
	pattern.tk_keys[2] = -1;    // the value -1 is not special, either
	assert((search_for_pattern(classA, &pattern)
	        | search_for_pattern(classB, &pattern))
	       == 0x24
	);

	// keys[0] == 42 && keys[1] == 1 => {5}
	pattern.tk_mask = (1 << 0) + (1 << 1);
	pattern.tk_keys[0] = 42;
	pattern.tk_keys[1] = 1;
	assert((search_for_pattern(classA, &pattern)
	        | search_for_pattern(classB, &pattern))
	       == 0x20
	);

	// 'ANY' pattern => all
	pattern.tk_mask = 0;
	assert((search_for_pattern(classA, &pattern)
	        | search_for_pattern(classB, &pattern))
	       == 0x3F
	);

	return 0;
}


void
create_instance(struct tesla_class *tclass, struct tesla_instance **instance,
                register_t key0, register_t key1, register_t key2)
{
	struct tesla_key key;
	key.tk_mask = 0x07;
	key.tk_keys[0] = key0;
	key.tk_keys[1] = key1;
	key.tk_keys[2] = key2;

	int err = tesla_instance_get(tclass, &key, instance);
	if (err != TESLA_SUCCESS)
		errx(1, "error in 'get': %s\n", tesla_strerror(err));

	assert(instance != NULL);
	tesla_instance_put(tclass, *instance);
}

int
search_for_pattern(struct tesla_class *tclass, struct tesla_key *pattern) {
	struct tesla_iterator *iter;
	int found = 0;

	for (assert(tesla_match(tclass, pattern, &iter) == TESLA_SUCCESS);
	     tesla_hasnext(iter);) {
		struct tesla_instance *inst = tesla_next(iter);
		assert(inst != NULL);
		for (size_t i = 0; i < INSTANCES; i++)
			if (inst == instances[i])
				found |= (1 << i);
	}
	tesla_iterator_free(iter);

	return found;
}

