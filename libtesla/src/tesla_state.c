/*-
 * Copyright (c) 2011 Robert N. M. Watson
 * Copyright (c) 2011 Anil Madhavapeddy
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

#ifdef _KERNEL
#include "opt_kdb.h"
#include <sys/param.h>
#include <sys/kdb.h>
#include <sys/kernel.h>
#include <sys/lock.h>
#include <sys/mutex.h>
#include <sys/malloc.h>
#include <sys/systm.h>
#else
#include <assert.h>
#include <err.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif

#include <tesla/tesla_util.h>
#include <tesla/tesla_state.h>

#include "tesla_internal.h"

#ifdef _KERNEL
MALLOC_DEFINE(M_TESLA, "tesla", "TESLA internal state");
#endif

int
tesla_state_new(struct tesla_state **tspp, u_int scope, u_int limit,
    const char *name, const char *description)
{
	struct tesla_state *tsp;
	size_t len;
	int error;

#ifdef _KERNEL
	KASSERT((scope == TESLA_SCOPE_PERTHREAD) ||
	    (scope == TESLA_SCOPE_GLOBAL),
	    ("tesla_state_new: invalid scope %u", scope));
#else
	assert(scope == TESLA_SCOPE_PERTHREAD || scope == TESLA_SCOPE_GLOBAL);
#endif

	/* XXXRW: Should validate 'limit' argument. */

	if (scope == TESLA_SCOPE_PERTHREAD)
		len = sizeof(*tsp);
	else
		len = sizeof(*tsp) + sizeof(struct tesla_instance) * limit;

#ifdef _KERNEL
	tsp = malloc(len, M_TESLA, M_WAITOK | M_ZERO);
#else
	tsp = malloc(len);
	if (tsp == NULL)
		return (TESLA_ERROR_ENOMEM);
	bzero(tsp, len);
#endif

	tsp->ts_name = name;
	tsp->ts_description = description;
	tsp->ts_scope = scope;
	tsp->ts_limit = limit;
#ifdef _KERNEL
	tsp->ts_action = TESLA_ACTION_PRINTF;
#else
	tsp->ts_action = TESLA_ACTION_FAILSTOP;	/* XXXRW: Default for now? */
#endif

	if (scope == TESLA_SCOPE_PERTHREAD) {
		error = tesla_state_perthread_new(tsp);
		if (error != TESLA_SUCCESS) {
#ifdef _KERNEL
			free(tsp, M_TESLA);
#else
			free(tsp);
#endif
			return (error);
		}
	} else
		tesla_state_global_new(tsp);
	*tspp = tsp;
	return (TESLA_SUCCESS);
}

void
tesla_state_destroy(struct tesla_state *tsp)
{

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL)
		tesla_state_global_destroy(tsp);
	else
		tesla_state_perthread_destroy(tsp);
#ifdef _KERNEL
	free(tsp, M_TESLA);
#else
	free(tsp);
#endif
}

void
tesla_state_flush(struct tesla_state *tsp)
{

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL)
		tesla_state_global_flush(tsp);
	else
		tesla_state_perthread_flush(tsp);
}

int
tesla_gettable_locked(struct tesla_state *tsp, struct tesla_table **ttp)
{
#ifdef ASSERTS
	assert(tsp != NULL);
	assert(ttp != NULL);
#endif

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_global_lock(tsp);
		*ttp = &tsp->ts_table;
		return (TESLA_SUCCESS);
	} else
		return tesla_state_perthread_gettable(tsp, ttp);
}

int
tesla_key_matches(struct tesla_key *pattern, struct tesla_key *k)
{
#ifdef ASSERTS
	assert(pattern);
	assert(k);
#endif

	// The pattern's mask must be a subset of the target's (ANY matches
	// 42 but not the other way around).
	if ((pattern->tk_mask & k->tk_mask) != pattern->tk_mask) return (0);

	for (size_t i = 0; i < TESLA_KEY_SIZE; i++) {
		// Only check keys specified by the bitmasks.
		register_t mask = (1 << i);
		if ((pattern->tk_mask & mask) != mask) continue;

		// A non-match of any sub-key implies a non-match of the key.
		if (pattern->tk_keys[i] != k->tk_keys[i]) return (0);
	}

	return (1);
}

int
tesla_instance_get(struct tesla_state *tclass, struct tesla_key *pattern,
		   struct tesla_instance **out)
{
#ifdef ASSERTS
	assert(tclass);
	assert(pattern);
	assert(out);
#endif

	struct tesla_instance *instance, *next_free_instance;
	struct tesla_table *ttp;
	u_int i;
	int error;

	error = tesla_gettable_locked(tclass, &ttp);
	if (error != TESLA_SUCCESS)
		return (error);

	next_free_instance = NULL;
	for (i = 0; i < ttp->tt_length; i++) {
		instance = &ttp->tt_instances[i];

		// If we found the droids we're looking for, go no further.
		if (tesla_key_matches(pattern, &instance->ti_key)) {
			*out = instance;
			assert(*out != NULL);
			return (TESLA_SUCCESS);
		}

		// No luck yet; make a note if this slot is empty.
		if (next_free_instance == NULL && instance->ti_key.tk_mask == 0)
			next_free_instance = instance;
	}

	// The named instance does not exist; create it.
	if (next_free_instance != NULL) {
		instance = next_free_instance;
		instance->ti_key = *pattern;
		/* Note: ti_state left zero'd. */
		*out = instance;
		ttp->tt_free--;
		assert(*out != NULL);
		return (TESLA_SUCCESS);
	}

	if (tclass->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_global_unlock(tclass);
	}
	return (TESLA_ERROR_ENOMEM);
}

void
tesla_instance_put(struct tesla_state *tsp, struct tesla_instance *tip)
{
#ifdef DEBUG
	assert_instanceof(tip, tsp);
#endif

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL)
		tesla_state_global_unlock(tsp);
	/* No action required for TESLA_SCOPE_PERTHREAD. */
}

void
tesla_instance_destroy(struct tesla_state *tsp, struct tesla_instance *tip)
{
	struct tesla_table *ttp;
	int error;

	tip->ti_state[0] = 0;
	tip->ti_state[1] = 0;
	tip->ti_state[2] = 0;
	tip->ti_state[3] = 0;
	tip->ti_key.tk_keys[0] = 0;
	tip->ti_key.tk_keys[1] = 0;
	tip->ti_key.tk_keys[2] = 0;
	tip->ti_key.tk_keys[3] = 0;

	/*
	 * XXXRW: this will need revisiting if we change locking strategies.
	 */
	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tsp->ts_table.tt_free++;
		tesla_state_global_unlock(tsp);
	} else  {
		error = tesla_state_perthread_gettable(tsp, &ttp);
		if (error != TESLA_SUCCESS)
			return;
		ttp->tt_free++;
	}
}

void
tesla_assert_fail(struct tesla_state *tsp, struct tesla_instance *tip)
{

	if (tsp->ts_handler != NULL) {
		tsp->ts_handler(tip);
		return;
	}

	switch (tsp->ts_action) {
	case TESLA_ACTION_FAILSTOP:
#ifdef _KERNEL
		panic("tesla_assert_failed: %s: %s", tsp->ts_name,
		    tsp->ts_description);
#else
		errx(-1, "tesla_assert failed: %s: %s", tsp->ts_name,
		    tsp->ts_description);
#endif
		break;		/* A bit gratuitous. */
#ifdef NOTYET
	case TESLA_ACTION_DTRACE:
		dtrace_probe(...);
		return;
#endif
	case TESLA_ACTION_PRINTF:
#if defined(_KERNEL) && defined(KDB)
		kdb_backtrace();
#endif
		printf("tesla_assert_failed: %s: %s\n", tsp->ts_name,
		    tsp->ts_description);
		break;
	}
}

void
tesla_state_setaction(struct tesla_state *tsp,
    tesla_assert_fail_callback handler)
{

	tsp->ts_handler = handler;
}
