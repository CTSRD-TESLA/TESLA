/*-
 * Copyright (c) 2012 Jonathan Anderson
 * All rights reserved.
 *
 * This software was developed by SRI International and the University of
 * Cambridge Computer Laboratory under DARPA/AFRL contract (FA8750-10-C-0237)
 * ("CTSRD"), as part of the DARPA CRASH research programme.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $Id$
 */

#include "tesla_internal.h"

#include <stdbool.h>
#include <inttypes.h>

#define	CHECK(fn, ...) do { \
	int err = fn(__VA_ARGS__); \
	if (err != TESLA_SUCCESS) { \
		DEBUG_PRINT("error in " #fn ": %s\n", tesla_strerror(err)); \
		return (err); \
	} \
} while(0)

int
tesla_update_state(int tesla_context, int class_id, const struct tesla_key *key,
	const char *name, const char *description,
	register_t expected_state, register_t new_state)
{
#ifndef NDEBUG
	DEBUG_PRINT("\n====\n%s()\n", __func__);
	DEBUG_PRINT("  context:  %s\n",
	       (tesla_context == TESLA_SCOPE_GLOBAL ? "global" : "per-thread"));
	DEBUG_PRINT("  class:    %d ('%s')\n", class_id, name);
	DEBUG_PRINT("  state:    %" PRIu64 "->%" PRIu64"\n",
               expected_state, new_state);
	DEBUG_PRINT("  key:      ");
	print_key(key);
	DEBUG_PRINT("\n----\n");
#endif

	struct tesla_store *store;
	CHECK(tesla_store_get, tesla_context, 4, 4, &store);

	struct tesla_class *class;
	CHECK(tesla_class_get, store, class_id, &class, name, description);

	struct tesla_table *table = class->ts_table;
	struct tesla_instance *start = table->tt_instances;

#ifndef NDEBUG
	print_class(class);
	DEBUG_PRINT("----\n");
#endif

	// If the expected current state is 0, create a new automaton.
	if (expected_state == 0) {
		struct tesla_instance *inst;
		CHECK(tesla_instance_new, class, key, new_state, &inst);
		assert(tesla_instance_active(inst));

		DEBUG_PRINT("new    %ld: %tx\n", inst - start, inst->ti_state);
	} else {
		bool success = false;

		// Update already-matching instances.
		size_t len = table->tt_length;
		struct tesla_instance* instances[len];
		CHECK(tesla_match, class, key, instances, &len);

		for (size_t i = 0; i < len; i++) {
			struct tesla_instance *inst = instances[i];

			if (inst->ti_state != expected_state) {
				tesla_assert_fail(class, inst,
						  expected_state, new_state);
			} else {
				success = true;
				DEBUG_PRINT("update %ld: %tx->%tx\n",
				            inst - start,
				            inst->ti_state, new_state);
				inst->ti_state = new_state;
			}
		}

		// Fork new instances if necessary.
		for (size_t i = 0; i < table->tt_length; i++) {
			struct tesla_instance *inst = start + i;

			// Only fork if the new key is a more specific version
			// of the existing one.
			if (tesla_instance_active(inst)
			    && (inst->ti_state == expected_state)
			    && tesla_key_matches(&inst->ti_key, key)
			    && !tesla_key_matches(key, &inst->ti_key)) {

				success = true;

				struct tesla_instance *copy;
				CHECK(tesla_clone, class, inst, &copy);
				DEBUG_PRINT("clone  %ld:%tx -> %ld:%tx\n",
				            inst - start, copy->ti_state,
				            copy - start, new_state);

				copy->ti_key = *key;
				copy->ti_state = new_state;
			}
		}

		// Make sure we updated something.
		if (!success) {
			struct tesla_instance *blame = NULL;
			for (size_t i = 0; i < table->tt_length; i++) {
				struct tesla_instance *inst = start + i;

				// Find an automata instance to blame.
				if (tesla_instance_active(inst)
				    && tesla_key_matches(&inst->ti_key, key)
				    && !tesla_key_matches(key, &inst->ti_key)) {
					blame = inst;
					break;
				}
			}

			assert(blame != NULL);
			tesla_assert_fail(class, blame,
			    expected_state, new_state);
		}
	}

#ifndef NDEBUG
	DEBUG_PRINT("----\n");
	print_class(class);
	DEBUG_PRINT("\n====\n\n");
#endif

	tesla_class_put(class);

	return (TESLA_SUCCESS);
}

