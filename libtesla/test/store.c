/**
 * @file store.c
 * Tests automata class storage.
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


static void	check_store(struct tesla_store*);

const int	CLASSES = 4;

int
main(int argc, char **argv)
{
	install_default_signal_handler();

	struct tesla_store *global_store, *perthread;

	check(tesla_store_get(TESLA_CONTEXT_GLOBAL, CLASSES, 1, &global_store));
	check(tesla_store_get(TESLA_CONTEXT_THREAD, CLASSES, 1, &perthread));

	check_store(global_store);
	check_store(perthread);

	return 0;
}


#define name(i) (__FILE__ "#" #i)
#define desc(i) ("Automaton class " #i)

static void
check_store(struct tesla_store *store)
{
	assert(store != NULL);

	struct tesla_lifetime lifetime = {
		.tl_begin = {
			.tle_repr = "init",
			.tle_length = sizeof("init"),
			.tle_hash = 0,
		},
		.tl_end = {
			.tle_repr = "cleanup",
			.tle_length = sizeof("cleanup"),
			.tle_hash = 1,
		},
	};

	struct tesla_automaton descriptions[CLASSES];
	struct tesla_class *classes[CLASSES];

	for (unsigned int i = 0; i < CLASSES; i++) {
		struct tesla_automaton *descrip = descriptions + i;
		descrip->ta_name = name(i);
                descrip->ta_lifetime = &lifetime;

		check(tesla_class_get(store, descrip, classes + i));

		struct tesla_instance *instance;
		struct tesla_key key;
		key.tk_mask = 1;
		key.tk_keys[0] = 42 + i;

		intptr_t state = 2 * i + 42;

		check(tesla_instance_new(classes[i], &key, state, &instance));
		assert(instance != NULL);
		assert(tesla_instance_active(instance));
		assert(instance->ti_state == 2 * i + 42);
		assert(instance->ti_key.tk_mask == 1);
		assert(instance->ti_key.tk_keys[0] == 42 + i);

		tesla_class_put(classes[i]);
	}

	struct tesla_class *JUNK = (struct tesla_class*) 0xF00BA5;
	struct tesla_class *junk = JUNK;

	struct tesla_automaton descrip = {
		.ta_name = "store.cpp:i+1",
		.ta_description = "valid automaton, invalid tesla_class*",
		.ta_alphabet_size = 42,
	};

	int err = tesla_class_get(store, &descrip, &junk);
	if (err != TESLA_ERROR_ENOENT)
		errx(1, "tesla_class_get() did not report ENOENT: %s",
		     tesla_strerror(err));

	if (junk != JUNK)
		errx(1, "tesla_class_get() clobbered output variable when"
		        " returning an error");
}
