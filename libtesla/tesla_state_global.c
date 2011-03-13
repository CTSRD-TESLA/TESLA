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
#include <sys/libkern.h>
#include <sys/lock.h>
#include <sys/mutex.h>
#else
#include <assert.h>
#include <err.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#endif

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "tesla_internal.h"

/*
 * Currently, this serialises all automata associated with a globally-scoped
 * assertion.  This is undesirable, and we should think about something more
 * granular, such as using key values to hash to locks.  This might cause
 * atomicity problems when composing multi-clause expressions, however; more
 * investigation required.
 */
static void
tesla_state_global_lock_init(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_init(&tsp->ts_lock, "tesla", NULL, MTX_DEF);
#else
	int error = pthread_mutex_init(&tsp->ts_lock, NULL);
	assert(error == 0);
#endif
}

static void
tesla_state_global_lock_destroy(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_destroy(&tsp->ts_lock);
#else
	int error = pthread_mutex_destroy(&tsp->ts_lock);
	assert(error == 0);
#endif
}

void
tesla_state_global_lock(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_lock(&tsp->ts_lock);
#else
	int error = pthread_mutex_lock(&tsp->ts_lock);
	assert(error == 0);
#endif
}

void
tesla_state_global_unlock(struct tesla_state *tsp)
{

#ifdef _KERNEL
	mtx_unlock(&tsp->ts_lock);
#else
	int error = pthread_mutex_unlock(&tsp->ts_lock);
	assert(error == 0);
#endif
}

int
tesla_state_global_new(struct tesla_state *tsp)
{

	tesla_state_global_lock_init(tsp);
	tsp->ts_table.tt_length = tsp->ts_limit;
	tsp->ts_table.tt_free = tsp->ts_limit;
	return (TESLA_ERROR_SUCCESS);
}

void
tesla_state_global_destroy(struct tesla_state *tsp)
{

	tesla_state_global_lock_destroy(tsp);
}

void
tesla_state_global_flush(struct tesla_state *tsp)
{

	tesla_state_global_lock(tsp);
	bzero(&tsp->ts_table.tt_instances,
	    sizeof(struct tesla_instance) * tsp->ts_table.tt_length);
	tsp->ts_table.tt_free = tsp->ts_table.tt_length;
	tesla_state_global_unlock(tsp);
}
