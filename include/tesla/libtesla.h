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

#ifndef _TESLA_STATE
#define	_TESLA_STATE

#include <sys/types.h>		/* register_t */

/*
 * libtesla functions mostly return error values, and therefore return
 * pointers, etc, via call-by-reference arguments.  These errors are modeled
 * on errno(2), but a separate namespace.
 */
#define	TESLA_SUCCESS		0	/* Success. */
#define	TESLA_ERROR_ENOENT	1	/* Entry not found. */
#define	TESLA_ERROR_EEXIST	2	/* Entry already present. */
#define	TESLA_ERROR_ENOMEM	3	/* Insufficient memory. */
#define	TESLA_ERROR_EINVAL	4	/* Invalid parameters. */
#define	TESLA_ERROR_UNKNOWN	5	/* An unknown (e.g. platform) error. */

struct tesla_key;

/** Update all automata instances that match a given key to a new state. */
int	tesla_update_state(int context, int class_id,
	const struct tesla_key *key, const char *name, const char *description,
	register_t expected_state, register_t new_state);

/*
 * Provide string versions of TESLA errors.
 */
const char	*tesla_strerror(int error);

/**
 * A storage container for one or more @ref tesla_class objects.
 *
 * There may be one @ref tesla_store for each thread (for storing thread-local
 * automata) plus a single global @ref tesla_store.
 */
struct tesla_store;

/**
 * Retrieve the @ref tesla_store for a context (e.g., a thread).
 *
 * If the @ref tesla_store does not exist yet, it will be created.
 *
 * @param[in]  context     @ref TESLA_SCOPE_PERTHREAD or @ref TESLA_SCOPE_GLOBAL
 * @param[in]  classes     number of @ref tesla_class'es to expect
 * @param[in]  instances   @ref tesla_instance count per @ref tesla_class
 * @param[out] store       return parameter for @ref tesla_store pointer
 */
int	tesla_store_get(int context, u_int classes, u_int instances,
	                struct tesla_store* *store);

/** Reset all automata in a store to the inactive state. */
int	tesla_store_reset(struct tesla_store *store);



/**
 * A description of a TESLA automaton, which may be instantiated a number of
 * times with different names and current states.
 */
struct tesla_class;

/**
 * Retrieve (or create) a @ref tesla_class from a @ref tesla_store.
 *
 * Once the caller is done with the @ref tesla_class, @ref tesla_class_put
 * must be called.
 *
 * @param[in]   store    where the @ref tesla_class is expected to be stored
 * @param[in]   id       a client-generated handle (a small integer, used as
 *                       an index into an array)
 * @param[out]  tclass   the retrieved (or generated) @ref tesla_class;
 *                       only set if function returns TESLA_SUCCESS
 * @param[in]   name     a user-readable name (e.g. an automata filename)
 * @param[in]   description   a user-readable description (for error messages)
 *
 * @returns a TESLA error code (TESLA_SUCCESS, TESLA_ERROR_EINVAL, etc.)
 */
int	tesla_class_get(struct tesla_store *store,
	                u_int id,
	                struct tesla_class **tclass,
	                const char *name,
	                const char *description);



#define	TESLA_KEY_SIZE		4

/**
 * A TESLA instance can be identified by a @ref tesla_class and a
 * @ref tesla_key. This key represents the values of event parameters (e.g. a
 * credential passed to a security check), some of which may not be specified.
 *
 * Clients can use @ref tesla_key to look up sets of automata instances, using
 * the bitmask to specify don't-care parameters.
 *
 * Keys are register-sized so that they can hold arbitrary data/pointers.
 */
struct tesla_key {
	/** The keys / event parameters that name this automata instance. */
	register_t	tk_keys[TESLA_KEY_SIZE];

	/** A bitmask of the keys that are actually set. */
	register_t	tk_mask;
};

/**
 * Check to see if a key matches a pattern.
 *
 * @returns  1 if @ref #k matches @ref pattern, 0 otherwise
 */
int	tesla_key_matches(
	    const struct tesla_key *pattern, const struct tesla_key *k);


/** A single instance of an automaton: a name (@ref ti_key) and a state. */
struct tesla_instance {
	struct tesla_key	ti_key;
	register_t		ti_state;
};

/**
 * Instances of tesla_class each have a "scope", used to determine where data
 * should be stored, and how it should be synchronised.
 *
 * Two scopes are currently supported: thread-local and global. Thread-local
 * storage does not require explicit synchronisation, as accesses are
 * serialised by the executing thread, whereas global storage does.  On the
 * other hand, thread-local storage is accessible only to the thread itself,
 * so cannot be used to track events across multiple threads.  Global storage
 * is globally visible, but requires explicit (and potentially expensive)
 * synchronisation.
 */
#define	TESLA_SCOPE_PERTHREAD	1
#define	TESLA_SCOPE_GLOBAL	2

/**
 * Set the action to take when a TESLA assertion fails; implemented via a
 * callback from the TESLA runtime.
 */
typedef void	(*tesla_assert_fail_callback)(struct tesla_instance *tip);
void	tesla_class_setaction(struct tesla_class *tsp,
	    tesla_assert_fail_callback handler);


/**
 * Checks whether or not a TESLA automata instance is active (in use).
 *
 * @param  i    pointer to a <b>valid</b> @ref tesla_instance
 *
 * @returns     1 if active, 0 if inactive
 */
int	tesla_instance_active(struct tesla_instance *i);


/** Clone an existing instance into a new instance. */
int	tesla_instance_clone(struct tesla_class *tclass,
	    struct tesla_instance *original, struct tesla_instance **copy);

/** Find an existing automata instance that matches a key. */
int	tesla_instance_find(struct tesla_class *tclass,
	    const struct tesla_key *key, struct tesla_instance **instance);

/** Release resources (e.g., locks) associated with a @ref tesla_class. */
void	tesla_class_put(struct tesla_class*);

/** Reset a @ref tesla_class for re-use from a clean state. */
void	tesla_class_reset(struct tesla_class*);

/**
 * This interface releases an instance for reuse; some types of automata will
 * prefer tesla_class_reset(), which clears all instances associated with a
 * particular tesla_class.
 */
void	tesla_instance_destroy(struct tesla_class *tsp,
	    struct tesla_instance *tip);

/**
 * Function to invoke when a TESLA assertion fails.
 *
 * May not actually fail stop at this point, so assertions must handle
 * continuation after this call.  Further cases of this particular instance
 * firing should be suppressed so that e.g. DTrace probes fire only once
 * per failure.
 */
void	tesla_assert_fail(struct tesla_class *tsp,
		struct tesla_instance *tip, register_t expected_state,
		register_t actual_state);

#endif /* _TESLA_STATE */
