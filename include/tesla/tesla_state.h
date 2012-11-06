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

#include "tesla_iterator.h"

/*
 * tesla_class is part of the libtesla runtime environment.  tesla_class is
 * used by compiled TESLA assertions to hold state for in-execution automata.
 *
 * The state of each TESLA assertion is described by struct tesla_class, which
 * is opaque to consumers.  An individual TESLA assertion may contain a
 * number of different automata describing various parts of an expression, and
 * potentially many instances of each automata in flight.  All of this state
 * is maintained in a single tesla_class, and addressed using one or more
 * keys.  By convention, the first key is the name of the automata; the
 * remainder of the lookup keys are constants that select a specific instance
 * of the automata.
 */
struct tesla_class;

#define	TESLA_KEY_SIZE		4

/**
 * A TESLA instance can be identified by a @ref tesla_class and a
 * @ref tesla_key. This key represents the values of event parameters (e.g. a
 * credential passed to a security check), some of which may not be specified.
 *
 * Clients can use @ref tesla_key to look up sets of automata instances, using
 * the bitmask to specify don't-care parameters.
 */
struct tesla_key {
	/** A bitmask of the keys that are actually set. */
	register_t	tk_mask;

	/** The keys / event parameters that name this automata instance. */
	register_t	tk_keys[TESLA_KEY_SIZE];
};

/**
 * Check to see if a key matches a pattern.
 *
 * @returns  1 if @ref #k matches @ref pattern, 0 otherwise
 */
int	tesla_key_matches(struct tesla_key *pattern, struct tesla_key *k);


/*
 * Each automata instance is captured by a struct tesla_instance, which holds
 * data capturing the state of an in-execution automata.  Storage and
 * synchronisation are managed by the TESLA runtime.
 *
 * The first (n) fields are the automata's keys (see comment above); these
 * must not be modified by the consumer, a they are also used by tesla_class
 * for lookup.  Keys are register-sized so that they can hold arbitrary
 * data/pointers that might be arguments to TESLA instrumentation points.  It
 * is important that this structure be no bigger than necessary, as one will
 * be allocated for every potential intance of an automata.
 */
#define	TESLA_STATE_SIZE	4
struct tesla_instance {
	struct tesla_key	ti_key;
	u_int			ti_state[TESLA_STATE_SIZE];
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
 * Create a new TESLA automata class.
 *
 * @param  scope  @ref TESLA_SCOPE_PERTHREAD or @ref TESLA_SCOPE_GLOBAL.
 * @param  limit  Maximum number of automata to support.
 *                Memory use scales linearly with this value.
 *                It is recommended that the limit be prime, and ideally at
 *                least 10x the actual number you might use in practice, in
 *                order to ensure an adequately sparse hash table.
 */
int	tesla_class_new(struct tesla_class **tspp, u_int scope, u_int limit,
	    const char *name, const char *description);

/** Free a @ref tesla_class instance. */
void	tesla_class_destroy(struct tesla_class *tsp);

/** Free currently instantiated automata, leaving the tesla_class reusable. */
void	tesla_class_flush(struct tesla_class *tsp);

/**
 * Set the action to take when a TESLA assertion fails; implemented via a
 * callback from the TESLA runtime.
 */
typedef void	(*tesla_assert_fail_callback)(struct tesla_instance *tip);
void	tesla_class_setaction(struct tesla_class *tsp,
	    tesla_assert_fail_callback handler);

/** Retrieve a TESLA automata class, creating if it does not exist. */
int	tesla_class_get(struct tesla_class **tspp, u_int scope, u_int limit,
	    const char *name, const char *description);

/** Find (or create) an automata instance that matches a key. */
int	tesla_instance_get(struct tesla_class *tclass, struct tesla_key *key,
	    struct tesla_instance **instance);

/**
 * Find all automata instances in a class that match a particular key.
 *
 * @param[in]  tclass   the class of automata to match
 * @param[in]  key      must remain valid as long as the iterator is in use
 * @param[out] iter     the return
 *
 * @returns    a standard TESLA error code (e.g., TESLA_ERROR_ENOMEM)
 */
int
tesla_match(struct tesla_class *tclass, struct tesla_key *key,
	    struct tesla_iterator **iter);

/**
 * Once an instance has been queried, it must be "returned" to its
 * tesla_class, which will release synchronisation on the instance.
 */
void	tesla_instance_put(struct tesla_class *tsp,
	    struct tesla_instance *tip);

/**
 * This interface releases an instance for reuse; some types of automata will
 * prefer tesla_class_flush(), which clears all instances associated with a
 * particular tesla_class.
 *
 * An instance passed to tesla_instance_destroy() will not require a call to
 * tesla_instance_put().
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
	    struct tesla_instance *tip);

#endif /* _TESLA_STATE */
