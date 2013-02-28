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

/** Basic TESLA types (magic for the compiler to munge). */
typedef	struct __tesla_event {}		__tesla_event;
typedef	struct __tesla_locality {}	__tesla_locality;

/** A number of times to match an event: positive or "any number". */
typedef	int	__tesla_count;

/** Magic "function" representing a TESLA assertion. */
void __tesla_inline_assertion(const char *filename, int line, int count,
		__tesla_locality*, int expression);


/* Only define the following things if doing TESLA analysis, not compiling. */
#ifdef	__TESLA_ANALYSER__

#include <sys/types.h>

/**
 * TESLA events can be serialised either with respect to the current thread
 * or, using explicit synchronisation, the global execution context.
 */
extern __tesla_locality *__tesla_global;
extern __tesla_locality *__tesla_perthread;

/** A sequence of TESLA events. Can be combined with && or ||. */
int __tesla_sequence(__tesla_event*, ...);


/* TESLA events: */
/** Entering a function (with optionally-specified arguments). */
struct __tesla_event* __tesla_call(void*, ...);

/** Exiting a function (with optionally-specified arguments). */
struct __tesla_event* __tesla_return(void*, ...);

/** Nothing to see here, move along... */
struct __tesla_event* __tesla_ignore;

/** Reaching the inline assertion. */
struct __tesla_event* __tesla_now;

struct __tesla_event* __tesla_optional(__tesla_event*, ...);

/** A repetition of events — this allows globby "?", "*", "+", etc. */
struct __tesla_event* __tesla_repeat(__tesla_count, __tesla_count, ...);

/** A value that could match a lot of function parameters. Maybe anything? */
void*		__tesla_any_ptr();
int		__tesla_any_int();
long		__tesla_any_long();
long long	__tesla_any_longlong();
register_t	__tesla_any_register_t();

#define	__tesla_any(type)	__tesla_any_##type()


/*
 * Structure-related automata descriptions:
 */

struct __tesla_automaton_description;

/** In an explicit automata description, return this to say "we're done". */
struct __tesla_automaton_description*	__tesla_automaton_done();


/** Declare an automaton that describes behaviour of this struct. */
#define	__tesla_struct_automaton(fn_name) \
	void *__tesla_struct_annotation_##fn_name;

/**
 * Define an automaton to describe a struct's behaviour.
 *
 * This should take the relevant structure as an argument.
 */
#define	__tesla_automaton(name, ...) \
	struct __tesla_automaton_description* name(__VA_ARGS__)

#else	/* !__TESLA_ANALYSER__ */

/*
 * We are not doing TESLA analysis, no we don't want a lot of artefacts left
 * behind like 'extern struct __tesla_locality* __tesla_global'.
 *
 * All that we do want to leave behind are the inline assertion sites, which
 * we can translate into instrumentation calls.
 */

#define	__tesla_global		((struct __tesla_locality*) 0)
#define	__tesla_perthread	((struct __tesla_locality*) 0)

#define __tesla_sequence(...)	1

#define	__tesla_struct_automaton(fn_name)
#define	__tesla_automaton(name, ...)

#endif	/* __TESLA_ANALYSER__ */

#endif	/* TESLA_H */

