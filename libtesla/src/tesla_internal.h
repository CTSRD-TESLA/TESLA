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
	 * State fields if per-thread.
	 */
#ifdef _KERNEL
	u_int		 ts_perthread_index;	/* Per-thread array index. */
#else
	pthread_key_t	 ts_pthread_key;
#endif

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
#define	TESLA_ACTION_PRINTF	3	/* Console/stdio printf. */

#if defined(_KERNEL) && defined(MALLOC_DECLARE)
/*
 * Memory type for TESLA allocations in the kernel.
 */
MALLOC_DECLARE(M_TESLA);
#endif

/*
 * Interfaces to global state management.
 */
int	tesla_state_global_new(struct tesla_state *tsp);
void	tesla_state_global_destroy(struct tesla_state *tsp);
int	tesla_state_global_gettable(struct tesla_state *tsp,
	    struct tesla_table **ttpp);
void	tesla_state_global_flush(struct tesla_state *tsp);
void	tesla_state_global_lock(struct tesla_state *tsp);
void	tesla_state_global_unlock(struct tesla_state *tsp);

/*
 * Interfaces to per-thread state management.
 */
int	tesla_state_perthread_new(struct tesla_state *tsp);
void	tesla_state_perthread_destroy(struct tesla_state *tsp);
void	tesla_state_perthread_flush(struct tesla_state *tsp);
int	tesla_state_perthread_gettable(struct tesla_state *tsp,
	    struct tesla_table **ttpp);

/*
 * Debug helpers.
 */

/**
 * Assert that a @ref tesla_instance is an instance of a @ref tesla_state.
 *
 * This could be expensive (a linear walk over all @ref tesla_instance in
 * @ref #tclass), so it should only be called from debug code.
 *
 * @param   i          the instance to test
 * @param   tclass     the expected class of @ref #i
 */
void	assert_instanceof(struct tesla_instance *i, struct tesla_state *tclass);

#endif /* TESLA_INTERNAL_H */
