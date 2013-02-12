/**
 * @file store.c
 * Tests automata class storage.
 */

#include <tesla/libtesla.h>
#include "tesla_internal.h"

#include <assert.h>
#include <err.h>
#include <stdio.h>

#include "helpers.h"


static void	check_store(struct tesla_store*);

const int	CLASSES = 4;

int
main(int argc, char **argv)
{
	install_default_signal_handler();

	struct tesla_store *global_store, *perthread;

	check(tesla_store_get(TESLA_SCOPE_GLOBAL, CLASSES, 1, &global_store));
	check(tesla_store_get(TESLA_SCOPE_PERTHREAD, CLASSES, 1, &perthread));

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

	struct tesla_class *classes[CLASSES];
	for (unsigned int i = 0; i < CLASSES; i++) {
		check(tesla_class_get(store, i, classes + i, name(i), desc(i)));

		struct tesla_instance *instance;
		struct tesla_key key;
		key.tk_mask = 1;
		key.tk_keys[0] = 42 + i;

		register_t state = 2 * i + 42;

		check(tesla_instance_new(classes[i], &key, state, &instance));
		assert(instance != NULL);
		assert(tesla_instance_active(instance));
		assert(instance->ti_state == 2 * i + 42);
		assert(instance->ti_key.tk_mask == 1);
		assert(instance->ti_key.tk_keys[0] == 42 + i);

		tesla_class_put(classes[i]);
	}

	void *JUNK = (void*) 0xF00BA5;
	struct tesla_class *junk = JUNK;
	int err = tesla_class_get(store, CLASSES, &junk, "foo", "bar");
	if (err != TESLA_ERROR_EINVAL)
		errx(1, "tesla_class_get() did not report EINVAL: %s",
		     tesla_strerror(err));

	if (junk != JUNK)
		errx(1, "tesla_class_get() clobbered output variable when"
		        " returning an error");
}

