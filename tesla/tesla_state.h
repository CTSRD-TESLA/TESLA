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
 * tesla_state is part of the libtesla runtime environment.  tesla_state is
 * used by compiled TESLA assertions to hold state for in-execution automata.
 *
 * The state of each TESLA assertion is described by struct tesla_state, which
 * is opaque to consumers.  An individual TESLA assertion may contain a
 * number of different automata describing various parts of an expression, and
 * potentially many instances of each automata in flight.  All of this state
 * is maintained in a single tesla_state, and addressed using one or more
 * keys.  By convention, the first key is the name of the automata; the
 * remainder of the lookup keys are constants that select a specific instance
 * of the automata.
 */
struct tesla_state;

/*
 * Each automata instance is captured by a struct tesla_instance, which holds
 * data capturing the state of an in-execution automata.  Storage and
 * synchronisation are managed by the TESLA runtime.
 *
 * The first (n) fields are the automata's keys (see comment above); these
 * must not be modified by the consumer, a they are also used by tesla_state
 * for lookup.  Keys are register-sized so that they can hold arbitrary
 * data/pointers that might be arguments to TESLA instrumentation points.  It
 * is important that this structure be no bigger than necessary, as one will
 * be allocated for every potential intance of an automata.
 */
struct tesla_instance {
	register_t	ti_keys[4];
	u_int		ti_state[4];
};

/*
 * Instances of tesla_state each have a "scope", used to determine where data
 * should be stored, and how it should be synchronised.  Two scopes are
 * currently supported: thread-local and global.  Thread-local storage does
 * not require explicit synchronisation, as accesses are serialised by the
 * executing thread, whereas global storage does.  On the other hand,
 * thread-local storage is accessible only to the thread itself, so cannot be
 * used to track events across multiple threads.  Global storage is globally
 * visible, but requires explicit (and potentially expensive)
 * synchronisation.
 */
#define	TESLA_SCOPE_PERTHREAD	1
#define	TESLA_SCOPE_GLOBAL	2

/*
 * Allocate, free, and flush tesla_state instances.  The latter will mark as
 * free all currently instantiated automata for an assertion, while leaving
 * the tesla_state reusable.  Note: for per-thread storage,
 * tesla_state_flush() affects only the current thread.
 *
 * The 'limit argument specifies the maximum number of automata to support,
 * and memory use scales linearly with this value.  It is recommended that
 * the limit be prime, and ideally at least 10x the actual number you might
 * use in practice, in order to ensure an adequately sparse hash table.
 */
int	tesla_state_new(struct tesla_state **tspp, u_int scope, u_int limit,
	    const char *name, const char *description);
void	tesla_state_destroy(struct tesla_state *tsp);
void	tesla_state_flush(struct tesla_state *tsp);

/*
 * Set the action to take when a TESLA assertion fails; implemented via a
 * callback from the TESLA runtime.
 */
typedef void	(*tesla_assert_fail_callback)(struct tesla_instance *tip);
void	tesla_state_setaction(struct tesla_state *tsp,
	    tesla_assert_fail_callback handler);

/*
 * Interfaces to look up/allocate, release, free, and flush automata state
 * from a struct tesla_state.  New automata instances are returned with their
 * state field set to (0); automata generators should use state between 1
 * and the maximum positive integer to avoid collisions with the state
 * infrastructure.
 */
int	tesla_instance_get1(struct tesla_state *tsp, register_t key1,
	    struct tesla_instance **tip);
int	tesla_instance_get2(struct tesla_state *tsp, register_t key1,
	    register_t key2, struct tesla_instance **tip);
int	tesla_instance_get3(struct tesla_state *tsp, register_t key1,
	    register_t key2, register_t key3, struct tesla_instance **tip);
int	tesla_instance_get4(struct tesla_state *tsp, register_t key1,
	    register_t key2, register_t key3, register_t key4,
	    struct tesla_instance **tip);

/*
 * Once an instance has been queried, it must be "returned" to its
 * tesla_state, which will release synchronisation on the instance.
 */
void	tesla_instance_put(struct tesla_state *tsp,
	    struct tesla_instance *tip);

/*
 * This interface releases an instance for reuse; some types of automata will
 * prefer tesla_state_flush(), which clears all instances associated with a
 * particular tesla_state.  An instance passed to tesla_instance_destroy()
 * will not require a call to tesla_instance_put().
 */
void	tesla_instance_destroy(struct tesla_state *tsp,
	    struct tesla_instance *tip);

/*
 * Function to invoke when a TESLA assertion fails.  May not actually fail
 * stop at this point, so assertions must handle continuation after this
 * call.  Further cases of this particular instance firing should be
 * suppressed so that DTrace probes fire only once per failure.
 */
void	tesla_assert_fail(struct tesla_state *tsp,
	    struct tesla_instance *tip);

#endif /* _TESLA_STATE */
