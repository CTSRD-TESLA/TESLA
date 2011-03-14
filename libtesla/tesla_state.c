/*-
 * Copyright (c) 2011 Robert N. M. Watson
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
#include <sys/param.h>
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
		if (error != TESLA_ERROR_SUCCESS) {
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
	return (TESLA_ERROR_SUCCESS);
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
tesla_instance_get4(struct tesla_state *tsp, register_t key0, register_t key1,
    register_t key2, register_t key3, struct tesla_instance **tipp)
{
	struct tesla_instance *tip, *free_tip;
	struct tesla_table *ttp;
	u_int i;
	int error;

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_global_lock(tsp);
		ttp = &tsp->ts_table;
	} else {
		error = tesla_state_perthread_gettable(tsp, &ttp);
		if (error != TESLA_ERROR_SUCCESS)
			return (error);
	}

	/* XXXRW: Absolutely the wrong algorithm. */
	free_tip = NULL;
	for (i = 0; i < ttp->tt_length; i++) {
		tip = &ttp->tt_instances[i];
		if (free_tip == NULL &&
		    tip->ti_keys[0] == 0 &&
		    tip->ti_keys[1] == 0 &&
		    tip->ti_keys[2] == 0 &&
		    tip->ti_keys[3] == 0)
			free_tip = tip;
		if (tip->ti_keys[0] != key0 ||
		    tip->ti_keys[1] != key1 ||
		    tip->ti_keys[2] != key2 ||
		    tip->ti_keys[3] != key3)
			continue;
		*tipp = tip;
		return (TESLA_ERROR_SUCCESS);
	}
	if (free_tip != NULL) {
		tip = free_tip;
		tip->ti_keys[0] = key0;
		tip->ti_keys[1] = key1;
		tip->ti_keys[2] = key2;
		tip->ti_keys[3] = key3;
		/* Note: ti_state left zero'd. */
		*tipp = tip;
		return (TESLA_ERROR_SUCCESS);
	}
	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_global_unlock(tsp);
	}
	return (TESLA_ERROR_ENOMEM);
}

int
tesla_instance_get3(struct tesla_state *tsp, register_t key0, register_t key1,
    register_t key2, struct tesla_instance **tipp)
{

	return (tesla_instance_get4(tsp, key0, key1, key2, 0, tipp));
}

int
tesla_instance_get2(struct tesla_state *tsp, register_t key0, register_t key1,
    struct tesla_instance **tipp)
{

	return (tesla_instance_get4(tsp, key0, key1, 0, 0, tipp));
}

int
tesla_instance_get1(struct tesla_state *tsp, register_t key0,
    struct tesla_instance **tipp)
{

	return (tesla_instance_get4(tsp, key0, 0, 0, 0, tipp));
}

void
tesla_instance_foreach1(struct tesla_state *tsp, register_t key0,
    tesla_instance_foreach_callback handler, void *arg)
{
	struct tesla_instance *tip;
	struct tesla_table *ttp;
	int error;
	u_int i;

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_global_lock(tsp);
		ttp = &tsp->ts_table;
	} else {
		error = tesla_state_perthread_gettable(tsp, &ttp);
		if (error != TESLA_ERROR_SUCCESS)
			return;
	}
	for (i = 0; i < ttp->tt_length; i++) {
		tip = &ttp->tt_instances[i];
		if (tip->ti_keys[0] != key0)
			continue;
		handler(tip, arg);
	}
	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL)
		tesla_state_global_unlock(tsp);
}

void
tesla_instance_put(struct tesla_state *tsp, struct tesla_instance *tip)
{

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
	tip->ti_keys[0] = 0;
	tip->ti_keys[1] = 0;
	tip->ti_keys[2] = 0;
	tip->ti_keys[3] = 0;

	/*
	 * XXXRW: this will need revisiting if we change locking strategies.
	 */
	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tsp->ts_table.tt_free++;
		tesla_state_global_unlock(tsp);
	} else  {
		error = tesla_state_perthread_gettable(tsp, &ttp);
		if (error != TESLA_ERROR_SUCCESS)
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
		printf("tesla_assert_failed: %s: %s", tsp->ts_name,
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
