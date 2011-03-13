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

#include "tesla_internal.h"

#ifdef _KERNEL
#else /* _KERNEL */
/*
 * Support for storing per-thread TESLA state in POSIX thread-local storage.
 * pthreads will run per-thread destructors on thread exit, which allows us
 * to clean up state machines automatically.  However, state has to be
 * manually allocated when we encounter a new thread interacting with TESLA
 * per-thread assertions.
 */
static void
tesla_state_perthread_destructor(void *arg)
{
	struct tesla_table *ttp = arg;

	free(ttp);
}

static int
tesla_state_perthread_constructor(struct tesla_state *tsp,
    struct tesla_table **ttpp)
{
	struct tesla_table *ttp;
	size_t len;
	int error;

	len = sizeof(*ttp) + sizeof(struct tesla_instance) * tsp->ts_limit;
	ttp = malloc(len);
	if (ttp == NULL)
		return (TESLA_ERROR_ENOMEM);
	bzero(ttp, len);
	ttp->tt_length = tsp->ts_limit;
	ttp->tt_free = tsp->ts_limit;
	error = pthread_setspecific(tsp->ts_pthread_key, ttp);
	assert(error == 0);
	*ttpp = ttp;
	return (TESLA_ERROR_SUCCESS);
}

int
tesla_state_perthread_new(struct tesla_state *tsp)
{
	int error;

	error = pthread_key_create(&tsp->ts_pthread_key,
	    tesla_state_perthread_destructor);
	if (error != 0)
		return (TESLA_ERROR_ENOMEM);
	return (TESLA_ERROR_SUCCESS);
}

void
tesla_state_perthread_destroy(struct tesla_state *tsp)
{
	int error;

	error = pthread_key_delete(tsp->ts_pthread_key);
	assert(error == 0);
}

void
tesla_state_perthread_flush(struct tesla_state *tsp)
{
	struct tesla_table *ttp;

	ttp = pthread_getspecific(tsp->ts_pthread_key);
	if (ttp == NULL)
		return;
	bzero(&ttp->tt_instances,
	    sizeof(struct tesla_instance) * ttp->tt_length);
	ttp->tt_free = ttp->tt_length;
}

int
tesla_state_perthread_gettable(struct tesla_state *tsp,
    struct tesla_table **ttpp)
{
	struct tesla_table *ttp;
	int error;

	ttp = pthread_getspecific(tsp->ts_pthread_key);
	if (ttp == NULL) {
		error = tesla_state_perthread_constructor(tsp, &ttp);
		if (error != 0)
			return (error);
	}
	*ttpp = ttp;
	return (TESLA_ERROR_SUCCESS);
}
#endif
