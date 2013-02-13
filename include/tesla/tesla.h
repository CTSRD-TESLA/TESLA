/*
 * Copyright (c) 2012 Jonathan Anderson
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
 */

#ifndef	TESLA_H
#define	TESLA_H

#include <limits.h>
#include <stdbool.h>

/** Basic TESLA types (magic for the compiler to munge). */
typedef	struct __tesla_event {}		__tesla_event;
typedef	struct __tesla_locality {}	__tesla_locality;

/** A number of times to match an event: positive or "any number". */
typedef	int	__tesla_count;

/** Magic "function" representing a TESLA assertion. */
void __tesla_inline_assertion(const char *filename, int line, int count,
		__tesla_locality*, bool);

/** A more programmer-friendly version of __tesla_inline_assertion. */
#define	TESLA_ASSERT(locality, predicate)				\
	__tesla_inline_assertion(					\
		__FILE__, __LINE__, __COUNTER__,			\
		locality, predicate					\
	)

#define	TESLA_GLOBAL(pred)	TESLA_ASSERT(__tesla_global, pred)
#define	TESLA_PERTHREAD(pred)	TESLA_ASSERT(__tesla_perthread, pred)


/* Only define the following things if doing TESLA analysis, not compiling. */
#ifdef	__TESLA_ANALYSER__

/**
 * TESLA events can be serialised either with respect to the current thread
 * or, using explicit synchronisation, the global execution context.
 */
extern __tesla_locality *__tesla_global;
extern __tesla_locality *__tesla_perthread;

#define	TESLA_STRUCT_AUTOMATON(fn_name) \
	void *__tesla_struct_annotation_##fn_name;

#define	automaton(name, ...) \
	bool __tesla_automaton_description_##name(__VA_ARGS__)

#define	done return true

/** A sequence of TESLA events. Can be combined with && or ||. */
bool __tesla_sequence(__tesla_event, ...);
#define	TSEQUENCE(...)	__tesla_sequence(__tesla_ignore, __VA_ARGS__)


/* TESLA events: */
/** Entering a function. */
__tesla_event __tesla_entered(void*);
#define	entered(f)	__tesla_entered(f)

/** Exiting a function. */
__tesla_event __tesla_leaving(void*);
#define	leaving(f)	__tesla_leaving(f)

/** Nothing to see here, move along... */
struct __tesla_event __tesla_ignore;

/** Reaching the inline assertion. */
__tesla_event __tesla_now;
#define	TESLA_NOW &__tesla_now

/** The result of a function call (e.g., foo(x) == y). */
__tesla_event __tesla_call(bool);

__tesla_event __tesla_optional(__tesla_event, ...);
#define	optional(...)	__tesla_optional(__tesla_ignore, __VA_ARGS__)

#define	ANY_REP	INT_MAX

/** A repetition of events — this allows globby "?", "*", "+", etc. */
__tesla_event __tesla_repeat(__tesla_count, __tesla_count, ...);
#define	REPEAT(m, n, ...)	__tesla_repeat(m, n, __VA_ARGS__)
#define	UPTO(n, ...)		__tesla_repeat(0, n, __VA_ARGS__)
#define	ATLEAST(n, ...)		__tesla_repeat(n, ANY_REP, __VA_ARGS__)

/** A value that could match a lot of function parameters. Maybe anything? */
void* __tesla_any();
#define	ANY	__tesla_any()


/** A more programmer-friendly way to write assertions about the past. */
#define since(bound, call)						\
	__tesla_sequence(						\
		bound,							\
		__tesla_call(call),					\
		__tesla_now						\
	)

/** A more programmer-friendly way to write assertions about the future. */
#define before(bound, call)						\
	__tesla_sequence(						\
		__tesla_now,						\
		__tesla_call(call),					\
		bound							\
	)


#else	/* !__TESLA_ANALYSER__ */

/*
 * We are not doing TESLA analysis, no we don't want a lot of artefacts left
 * behind like 'extern struct __tesla_locality* __tesla_global'.
 *
 * All that we do want to leave behind are the inline assertion sites, which
 * we can translate into instrumentation calls.
 */

#define	TESLA_STRUCT_AUTOMATON(fn_name)
#define	TSEQUENCE(...)		true
#define	since(...)		true
#define	before(...)		true

#define	__tesla_global		((struct __tesla_locality*) 0)
#define	__tesla_perthread	((struct __tesla_locality*) 0)


#endif	/* __TESLA_ANALYSER__ */

#endif	/* TESLA_H */

