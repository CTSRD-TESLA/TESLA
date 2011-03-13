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
#error "No kernel support yet"
#else
#include <assert.h>
#include <err.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#endif

#include <tesla/tesla_util.h>
#include <tesla/tesla_state.h>

/*
 * Instance table definition, used for both global and per-thread scopes.  A
 * more refined data structure might eventually be used here.
 */
struct tesla_table {
	u_int			tt_length;
	u_int			tt_free;
	struct tesla_instance	tt_instances[];
};

/*
 * Assertion state definition is internal to libtesla so we can change it as
 * we need to.
 */
struct tesla_state {
	const char	*ts_name;	/* Name of the assertion. */
	const char	*ts_description;/* Description of the assertion. */
	u_int		 ts_scope;	/* Per-thread or global. */
	u_int		 ts_limit;	/* Simultaneous automata limit. */
	tesla_assert_fail_callback	ts_handler;	/* Run on failure. */
	u_int		 ts_action;	/* What to do on failure. */

	/*
	 * State fields if global.  Table must be last field as it uses a
	 * zero-length array.
	 */
#ifdef _KERNEL
	struct mtx	ts_lock;	/* Synchronise ts_table. */
#else
	pthread_mutex_t	 ts_lock;	/* Synchronise ts_table. */
#endif
	struct tesla_table	ts_table;	/* Table of instances. */
};

/*
 * When the assertion fails, what to do?
 */
#define	TESLA_ACTION_FAILSTOP	1	/* Stop on failure. */
#define	TESLA_ACTION_DTRACE	2	/* Fire DTrace probe on failure. */

/*
 * Currently, this serialised all automata associated with a globally-scoped
 * assertion.  This is undesirable, and we should think about something more
 * granular, such as using key values to hash to locks.  This might cause
 * atomicity problems when composing multi-clause expressions, however; more
 * investigation required.
 */
static void
tesla_state_lock_init(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_init(&tsp->ts_lock, "tesla", NULL, MTX_DEF);
#else
	int error = pthread_mutex_init(&tsp->ts_lock, NULL);
	assert(error == 0);
#endif
}

static void
tesla_state_lock_destroy(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_destroy(&tsp->ts_lock);
#else
	int error = pthread_mutex_destroy(&tsp->ts_lock);
	assert(error == 0);
#endif
}

static void
tesla_state_lock(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_lock(&tsp->ts_lock);
#else
	int error = pthread_mutex_lock(&tsp->ts_lock);
	assert(error == 0);
#endif
}

static void
tesla_state_unlock(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_unlock(&tsp->ts_lock);
#else
	int error = pthread_mutex_unlock(&tsp->ts_lock);
	assert(error == 0);
#endif
}

int
tesla_state_new(struct tesla_state **tspp, u_int scope, u_int limit,
    const char *name, const char *description)
{
	struct tesla_state *tsp;
	size_t len;

#ifdef _KERNEL
	KASSERT((scope == TESLA_SCOPE_PERTHREAD) ||
	    (scope == TESLA_SCOPE_GLOBAL),
	    ("tesla_state_new: invalid scope %u", scope));
#else
	assert(scope == TESLA_SCOPE_PERTHREAD || scope == TESLA_SCOPE_GLOBAL);
#endif

	/* XXXRW: Should validate 'limit' argument. */
	if (scope == TESLA_SCOPE_GLOBAL)
		len = sizeof(*tsp) + sizeof(struct tesla_instance) * limit;
	else
		len = sizeof(*tsp);

#ifdef _KERNEL
	/* XXXRW: Kernel implementation? */
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
	tsp->ts_action = TESLA_ACTION_FAILSTOP;	/* XXXRW: Default for now? */
	if (scope == TESLA_SCOPE_GLOBAL) {
		tsp->ts_table.tt_length = limit;
		tsp->ts_table.tt_free = limit;
		tesla_state_lock_init(tsp);
	} else {
		/* XXXRW: Some per-thread storage actions? */
	}
	*tspp = tsp;
	return (TESLA_ERROR_SUCCESS);
}

void
tesla_state_destroy(struct tesla_state *tsp)
{

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_lock_destroy(tsp);
	} else {
		/* XXXRW: Some per-thread storage actions? */
	}
	free(tsp);
}

void
tesla_state_flush(struct tesla_state *tsp)
{

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_lock(tsp);
		bzero(&tsp->ts_table.tt_instances,
		    sizeof(struct tesla_instance) * tsp->ts_table.tt_length);
		tsp->ts_table.tt_free = tsp->ts_table.tt_length;
		tesla_state_unlock(tsp);
	} else {
		/* XXXRW: Some per-thread storage actions? */
	}
}

int
tesla_instance_get4(struct tesla_state *tsp, register_t key0, register_t key1,
    register_t key2, register_t key3, struct tesla_instance **tipp)
{
	struct tesla_instance *tip, *free_tip;
	struct tesla_table *ttp;
	u_int i;

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL) {
		tesla_state_lock(tsp);
		ttp = &tsp->ts_table;
	} else {
		/* XXX: Some per-thread storage actions? */
		ttp = NULL;
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
		tesla_state_unlock(tsp);
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
	u_int i;

	tesla_state_lock(tsp);
	for (i = 0; i < tsp->ts_table.tt_length; i++) {
		tip = &tsp->ts_table.tt_instances[i];
		if (tip->ti_keys[0] != key0)
			continue;
		handler(tip, arg);
	}
	tesla_state_unlock(tsp);
}

void
tesla_instance_put(struct tesla_state *tsp, struct tesla_instance *tip)
{

	if (tsp->ts_scope == TESLA_SCOPE_GLOBAL)
		tesla_state_unlock(tsp);
	/* No action required for TESLA_SCOPE_PERTHREAD. */
}

void
tesla_instance_destroy(struct tesla_state *tsp, struct tesla_instance *tip)
{

	tip->ti_state[0] = 0;
	tip->ti_state[1] = 0;
	tip->ti_state[2] = 0;
	tip->ti_state[3] = 0;
	tip->ti_keys[0] = 0;
	tip->ti_keys[1] = 0;
	tip->ti_keys[2] = 0;
	tip->ti_keys[3] = 0;

	/* XXXRW: If we move to hashed locks, will need to revisit this. */
	tsp->ts_table.tt_free++;
	tesla_instance_put(tsp, NULL);
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
#ifdef NOTYET
	case TESLA_ACTION_DTRACE:
		return;
#endif
	}
}

void
tesla_state_setaction(struct tesla_state *tsp,
    tesla_assert_fail_callback handler)
{

	tsp->ts_handler = handler;
}
