/** @file  tesla_iterator.c    Iterators over TESLA instances. */
/*-
 * Copyright (c) 2012 Jonathan Anderson
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
MALLOC_DECLARE(M_TESLA);
#endif

struct tesla_iterator {
	struct tesla_state	*tclass;
	struct tesla_table	*table;

	struct tesla_key	*pattern;

	struct tesla_instance	*next;
	struct tesla_instance	*end;
};


int
tesla_match(struct tesla_state *tclass, struct tesla_key *pattern,
	    struct tesla_iterator **iter_out)
{
	struct tesla_iterator *iter = 0;
	const size_t len = sizeof(struct tesla_iterator);

#ifdef _KERNEL
	iter = malloc(len, M_TESLA, M_WAITOK | M_ZERO);
#else
	iter = malloc(len);
#endif

	if (iter == NULL)
		return (TESLA_ERROR_ENOMEM);

	iter->tclass = tclass;
	iter->pattern = pattern;

	int error = tesla_gettable_locked(tclass, &iter->table);
	if (error != TESLA_SUCCESS) {
		free(iter);
		return error;
	}
	assert(iter->table != NULL);

	iter->end = iter->table->tt_instances + iter->table->tt_length;

	// Find the first instance that matches the pattern.
	struct tesla_instance *i;
	assert(iter->table->tt_instances != NULL);
	for (i = iter->table->tt_instances; i < iter->end; i++) {
		if (tesla_key_matches(pattern, &i->ti_key)) {
			break;
		}
	}
	iter->next = i;

	*iter_out = iter;

	return (TESLA_SUCCESS);
}

int
tesla_hasnext(struct tesla_iterator *it)
{
#ifdef ASSERTS
	assert(it != NULL);
	assert(it->next != NULL);
	assert(it->end != NULL);
#endif

	return (it->next < it->end);
}

struct tesla_instance*
tesla_next(struct tesla_iterator *it)
{
#ifdef DEBUG
	assert(tesla_hasnext(it));
#endif

	struct tesla_instance *next = it->next;

	for (it->next += 1; it->next < it->end; it->next++) {
		if (tesla_key_matches(it->pattern, &it->next->ti_key)) {
			break;
		}
	}

	assert(next != NULL);
	return next;
}

void
tesla_iterator_free(struct tesla_iterator *it)
{
	if (it->tclass->ts_scope == TESLA_SCOPE_GLOBAL)
		tesla_state_global_unlock(it->tclass);

#ifdef _KERNEL
	free(it, M_TESLA);
#else
	free(it);
#endif
}

