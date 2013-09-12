/** @file tesla_store.c  Implementation of @ref tesla_store. */
/*-
 * Copyright (c) 2012 Jonathan Anderson
 * Copyright (c) 2011, 2013 Robert N. M. Watson
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

#include "tesla_internal.h"

#ifndef _KERNEL
#include <errno.h>

/** The pthreads key used to identify TESLA data. */
pthread_key_t	pthread_key(void);
void		tesla_pthread_destructor(void*);
#endif

static struct tesla_store global_store = { .ts_length = 0 };

static void	tesla_class_acquire(tesla_class*);

#ifdef _KERNEL
static void
tesla_global_store_sysinit(__unused void *arg)
{
	uint32_t error;

	error = tesla_store_init(&global_store, TESLA_CONTEXT_GLOBAL,
	    TESLA_MAX_CLASSES, TESLA_MAX_INSTANCES);
	tesla_assert(error == TESLA_SUCCESS, ("tesla_store_init failed"));
}
SYSINIT(tesla_global_store, SI_SUB_TESLA, SI_ORDER_FIRST,
    tesla_global_store_sysinit, NULL);
#endif

#ifndef _KERNEL
static __thread tesla_store *cache = NULL;
#endif

int32_t
tesla_store_get(enum tesla_context context, uint32_t classes,
	uint32_t instances, tesla_store* *storep)
{
	assert(storep);

	tesla_store *store;

	switch (context) {
	case TESLA_CONTEXT_GLOBAL:
		store = &global_store;
		break;

	case TESLA_CONTEXT_THREAD: {
#ifdef _KERNEL
		store = curthread->td_tesla;
#else
		pthread_key_t key;
		if (!cache) {
			key = pthread_key();
			cache = pthread_getspecific(key);
		}
		store = cache;
#endif

		// Create a new store if we don't already have one.
		if (store == NULL) {
			store = tesla_malloc(sizeof(tesla_store));
#ifdef _KERNEL
			curthread->td_tesla = store;
#else
			__debug int err = pthread_setspecific(key, store);
			assert(err == 0);
#endif
		}
		break;
	}

	default:
		return (TESLA_ERROR_EINVAL);
	}

	if (store->ts_length == 0) {
		int32_t error =
			tesla_store_init(store, context, classes, instances);

		if (error != TESLA_SUCCESS) return (error);

		assert(store->ts_classes != NULL);
	}

	*storep = store;
	return (TESLA_SUCCESS);
}


int32_t
tesla_store_init(tesla_store *store, enum tesla_context context,
                 uint32_t classes, uint32_t instances)
{
	assert(classes > 0);
	assert(instances > 0);

	store->ts_length = classes;
	store->ts_classes = tesla_malloc(classes * sizeof(tesla_class));
	if (store->ts_classes == NULL)
		return (TESLA_ERROR_ENOMEM);

	int error = TESLA_SUCCESS;
	for (uint32_t i = 0; i < classes; i++) {
		error = tesla_class_init(store->ts_classes + i,
		                         context, instances);

		assert(error == TESLA_SUCCESS);
		if (error != TESLA_SUCCESS)
			break;

		assert(store->ts_classes[i].tc_context >= 0);
	}

	/*
	 * For now, allocate as many lifetime storage slots as there are
	 * classes. In practice, many automata will share lifetime information.
	 *
	 * TODO(JA): perhaps allocate fewer of these?
	 */
	const size_t lifetime_size = classes * sizeof(store->ts_lifetimes[0]);
	store->ts_lifetimes = tesla_malloc(lifetime_size);
	bzero(store->ts_lifetimes, lifetime_size);

	store->ts_lifetime_count = 0;

	return (error);
}


void
tesla_store_free(tesla_store *store)
{
	DEBUG(libtesla.store.free, "tesla_store_free %tx\n", store);

	for (uint32_t i = 0; i < store->ts_length; i++)
		tesla_class_destroy(store->ts_classes + i);

	tesla_free(store->ts_lifetimes);
	tesla_free(store);
}


void
tesla_store_reset(struct tesla_store *store)
{
	DEBUG(libtesla.store.reset, "tesla_store_reset %tx\n", store);

	for (uint32_t i = 0; i < store->ts_length; i++)
		tesla_class_reset(store->ts_classes + i);
}


int32_t
tesla_class_get(struct tesla_store *store,
                const struct tesla_automaton *description,
                struct tesla_class **tclassp)
{
	assert(store != NULL);
	assert(description != NULL);
	assert(tclassp != NULL);

	uint32_t desc_hash = fnv_hash32((uint32_t) description);
	const uint32_t len = store->ts_length;

	// Find the class: start at the bucket indicated by the hash but
	// walk around the array if there is a collision.
	tesla_class *tclass = NULL;
	for (uint32_t i = 0; i < len; i++) {
		tesla_class *t = store->ts_classes + ((desc_hash + i) % len);
		assert(t != NULL);

		// If the bucket is empty, the class doesn't exist in the
		// hash table; take ownership of this bucket.
		if (t->tc_automaton == NULL) {
			t->tc_automaton = description;
			tclass = t;
			break;
		}

		// There is something there; is it the class we're looking for?
		if (t->tc_automaton == description) {
			tclass = t;
			break;
		}

		// Otherwise, there is a collision... keep walking around
		// the hash table, looking for the desired class.
	}

	if (tclass == NULL)
		return (TESLA_ERROR_ENOENT);

	assert(tclass->tc_instances != NULL);
	assert(tclass->tc_context >= 0);

	tesla_class_acquire(tclass);

	*tclassp = tclass;
	return (TESLA_SUCCESS);
}

void
tesla_class_acquire(tesla_class *class) {
	switch (class->tc_context) {
	case TESLA_CONTEXT_GLOBAL:
		return tesla_class_global_acquire(class);

	case TESLA_CONTEXT_THREAD:
		return tesla_class_perthread_acquire(class);

	default:
		assert(0 && "unhandled TESLA context");
	}
}

#ifndef _KERNEL
pthread_key_t
pthread_key()
{
	// This function is just a singleton accessor.
	static pthread_key_t key;
	static int key_initialised = 0;
	static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

	// The key, once initialised, is immutable, so it is safe to check and
	// return it without locking. Multiple initialisations are prevented by
	// the critical section below.
	if (key_initialised) return key;

	int error __debug = pthread_mutex_lock(&lock);
	assert(error == 0 && "failed to lock pthread key mutex");

	// Now that we're in the critical section, check again to make sure we
	// initialise the key twice.
	if (key_initialised) return key;

	error = pthread_key_create(&key, tesla_pthread_destructor);
	assert(error == 0 && "failed to create pthread_key_t");

	key_initialised = 1;

	error = pthread_mutex_unlock(&lock);
	assert(error == 0 && "failed to unlock pthread key mutex");

	return key;
}

void
tesla_pthread_destructor(__unused void *x)
{
	tesla_store *store = (tesla_store*) x;
	tesla_store_free(store);
}
#endif

