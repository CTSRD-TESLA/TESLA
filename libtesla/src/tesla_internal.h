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

#ifndef TESLA_INTERNAL_H
#define	TESLA_INTERNAL_H

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
#include <string.h>
#endif

#include <tesla/libtesla.h>


/**
 * Create a new @ref tesla_instance.
 *
 * The caller is responsible for locking the class if needed.
 */
int	tesla_instance_new(struct tesla_class *tclass,
	    const struct tesla_key *name, register_t state,
	    struct tesla_instance **out);

/**
 * Clone an existing @ref tesla_instance within a @ref tesla_class.
 */
int	tesla_clone(struct tesla_class*, const struct tesla_instance *orig,
	    struct tesla_instance **copy);

/**
 * Find all automata instances in a class that match a particular key.
 *
 * The caller is responsible for locking the class if necessary.
 *
 * @param[in]     tclass   the class of automata to match
 * @param[in]     key      must remain valid as long as the iterator is in use
 * @param[out]    array    a caller-allocated array to store matches in
 * @param[in,out] size     in: size of array. out: number of instances.
 *
 * @returns    a standard TESLA error code (e.g., TESLA_ERROR_ENOMEM)
 */
int	tesla_match(struct tesla_class *tclass, const struct tesla_key *key,
	    struct tesla_instance **array, size_t *size);


#ifndef NDEBUG

#define __debug

#include <stdio.h>
#define DEBUG_PRINT(...) fprintf(stderr, __VA_ARGS__)

#else // NDEBUG

// When not in debug mode, some values might not get checked.
#define __debug __unused
#define DEBUG_PRINT(...)

#endif


// Kernel vs userspace implementation details.
#ifdef _KERNEL

/** In the kernel, panic really means panic(). */
#define tesla_panic(...) panic(__VA_ARGS__)

/** Our @ref tesla_assert has the same signature as @ref KASSERT. */
#define tesla_assert(...) KASSERT(__VA_ARGS__)

/** Emulate simple POSIX assertions. */
#define assert(cond) KASSERT(cond, "Assertion failed: '" # cond "'")

#define tesla_malloc(len) malloc(len, M_TESLA, M_WAITOK | M_ZERO)
#define tesla_free(x) free(x, M_TESLA)

#define tesla_lock(l) mtx_lock(l)
#define tesla_unlock(l) mtx_unlock(l)

#else	/* !_KERNEL */

/** @ref errx() is the userspace equivalent of panic(). */
#define tesla_panic(...) errx(1, __VA_ARGS__)

/** POSIX @ref assert() doesn't let us provide an error message. */
#define tesla_assert(condition, ...) assert(condition)

#define tesla_malloc(len) calloc(1, len)
#define tesla_free(x) free(x)

#define tesla_lock(l) \
	do { __debug int err = pthread_mutex_lock(l); assert(err == 0); } while(0)

#define tesla_unlock(l) \
	do { __debug int err = pthread_mutex_unlock(l); assert(err == 0); } while(0)

#endif


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
struct tesla_class {
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

	struct tesla_table	*ts_table;	/* Table of instances. */
};

typedef struct tesla_store tesla_store;
typedef struct tesla_class tesla_class;
typedef struct tesla_instance tesla_instance;


/**
 * @internal Definition of @ref tesla_store.
 *
 * Modifications to this structure should only be made while a lock is held
 * or in a thread-local context.
 */
struct tesla_store {
	u_int			length;
	struct tesla_class	*classes;
};

/**
 * Initialize @ref tesla_class internals.
 * Locking is the responsibility of the caller.
 */
int	tesla_class_init(struct tesla_class*, u_int context, u_int instances);


/*
 * When the assertion fails, what to do?
 */
#define	TESLA_ACTION_FAILSTOP	1	/* Stop on failure. */
#define	TESLA_ACTION_DTRACE	2	/* Fire DTrace probe on failure. */
#define	TESLA_ACTION_PRINTF	3	/* Console/stdio printf. */

#if defined(_KERNEL) && defined(MALLOC_DECLARE)
/*
 * Memory type for TESLA allocations in the kernel.
 */
MALLOC_DECLARE(M_TESLA);
#endif

/*
 * Context-specific automata management:
 */
int	tesla_class_global_postinit(struct tesla_class*);
void	tesla_class_global_acquire(struct tesla_class*);
void	tesla_class_global_release(struct tesla_class*);
void	tesla_class_global_destroy(struct tesla_class*);

int	tesla_class_perthread_postinit(struct tesla_class*c);
void	tesla_class_perthread_acquire(struct tesla_class*);
void	tesla_class_perthread_release(struct tesla_class*);
void	tesla_class_perthread_destroy(struct tesla_class*);

/*
 * Debug helpers.
 */

/**
 * Assert that a @ref tesla_instance is an instance of a @ref tesla_class.
 *
 * This could be expensive (a linear walk over all @ref tesla_instance in
 * @ref #tclass), so it should only be called from debug code.
 *
 * @param   i          the instance to test
 * @param   tclass     the expected class of @ref #i
 */
void	assert_instanceof(struct tesla_instance *i, struct tesla_class *tclass);

/** Print a @ref tesla_key to stderr. */
void	print_key(const struct tesla_key *key);

/** Print a @ref tesla_class to stderr. */
void	print_class(const struct tesla_class*);

#endif /* TESLA_INTERNAL_H */
