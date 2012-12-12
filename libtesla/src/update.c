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

#ifdef NDEBUG
#define DEBUG_PRINT(...)
#else
#include <stdio.h>
#define DEBUG_PRINT(...) fprintf(stderr, __VA_ARGS__)
#endif

#define	CHECK(fn, ...) do { \
	int err = fn(__VA_ARGS__); \
	if (err != TESLA_SUCCESS) { \
		DEBUG_PRINT("error in " #fn ": %s\n", tesla_strerror(err)); \
		return (err); \
	} \
} while(0)

int
tesla_update_state(int tesla_context, int class_id, struct tesla_key *key,
	const char *name, const char *description,
	register_t expected_state, register_t new_state)
{
#ifndef NDEBUG
	fprintf(stderr, "\n====\n%s()\n", __func__);
	fprintf(stderr, "  context:  %s\n",
	       (tesla_context == TESLA_SCOPE_GLOBAL ? "global" : "per-thread"));
	fprintf(stderr, "  class:    %d ('%s')\n", class_id, name);
	fprintf(stderr, "  state:    %lld->%lld\n", expected_state, new_state);
	fprintf(stderr, "  key:      ");
	print_key(key);
	fprintf(stderr, "\n");
#endif

	struct tesla_store *store;
	CHECK(tesla_store_get, tesla_context, 4, 4, &store);

	struct tesla_class *class;
	CHECK(tesla_class_get, store, class_id, &class, name, description);

	// To start automata, we need to fork from the null state.
	if (expected_state == 0) {
		struct tesla_instance *inst;
		CHECK(tesla_instance_get, class, key, &inst);

		DEBUG_PRINT("new instance @ 0x%llx: %llx -> %llx\n",
		            (register_t) inst, inst->ti_state, new_state);

		inst->ti_state = new_state;
	} else {
		struct tesla_iterator *iter;
		CHECK(tesla_match, class, key, &iter);

		while (tesla_hasnext(iter)) {
			struct tesla_instance *inst = tesla_next(iter);

			if (inst->ti_state != expected_state) {
				tesla_assert_fail(class, inst);
			} else {
				DEBUG_PRINT("instance @ 0x%llx: %llx -> %llx\n",
				            (register_t) inst,
				            inst->ti_state, new_state);
				inst->ti_state = new_state;
			}
		}

		tesla_iterator_free(iter);
	}

	DEBUG_PRINT("====\n\n");

	return (TESLA_SUCCESS);
}

