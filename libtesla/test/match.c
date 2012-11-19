/** @file match.c  Tests automata key matching. */

#include <tesla/libtesla.h>

#include <assert.h>
#include <err.h>
#include <stdio.h>

#include "helpers.h"

#define CREATE_AUTOMATA_INSTANCE(class, instance, key0, key1, key2) { \
	struct tesla_key key; \
	key.mask = 3; \
	key.keys[0] = key0; \
	key.keys[1] = key1; \
	key.keys[2] = key2; \
	int err = tesla_instance_get(class, &key, &instance); \
	if (err != TESLA_SUCCESS) \
		errx(1, "error in 'get': %s\n", tesla_strerror(err)); \
	assert(instance != NULL); \
	tesla_instance_put(class, instance); \
}

int
main(int argc, char **argv)
{
	install_default_signal_handler();

	struct tesla_key pattern, good, bad;

	pattern.tk_mask = 0x09;
	pattern.tk_keys[0] = 42;
	pattern.tk_keys[3] = -1;

	good.tk_mask = 0x0F;
	good.tk_keys[0] = 42;
	good.tk_keys[3] = -1;
	assert(tesla_key_matches(&pattern, &good));

	// Keys not specified by the pattern should be ignored.
	good.tk_keys[1] = 999;
	assert(tesla_key_matches(&pattern, &good));
	good.tk_keys[1] = -1;
	assert(tesla_key_matches(&pattern, &good));

	// The target's mask must be a superset of the pattern's (ANY matches
	// 42, but not the other way around).
	bad.tk_mask = 0x01;
	bad.tk_keys[0] = 42;
	bad.tk_keys[3] = -1;
	assert(!tesla_key_matches(&pattern, &bad));

	return 0;
}

