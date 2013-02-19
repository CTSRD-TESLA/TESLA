/** @file tesla-macros.h    Macros to prettify TESLA names. */
/*
 * Copyright (c) 2013 Jonathan Anderson
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

#ifndef	TESLA_MACROS_H
#define	TESLA_MACROS_H

#include <limits.h>
#include <tesla.h>

/*
 * Macros to make TESLA assertions a little easier to read.
 */

/** An inline assertion. */
#define	TESLA_ASSERT(locality, predicate)				\
	__tesla_inline_assertion(					\
		__FILE__, __LINE__, __COUNTER__,			\
		locality, predicate					\
	)

/** An assertion in the global TESLA context. */
#define	TESLA_GLOBAL(pred)	TESLA_ASSERT(__tesla_global, pred)

/** An assertion in a thread's TESLA context. */
#define	TESLA_PERTHREAD(pred)	TESLA_ASSERT(__tesla_perthread, pred)

/** A strictly-ordered sequence of events. */
#define	TSEQUENCE(...)	__tesla_sequence(__tesla_ignore, __VA_ARGS__)

#define	entered(f)	__tesla_entered(f)
#define	leaving(f)	__tesla_leaving(f)
#define	TESLA_NOW &__tesla_now


#define	TESLA_STRUCT_AUTOMATON(fn_name)	__tesla_struct_automaton(fn_name)

#define automaton(name, ...)    __tesla_automaton(name, __VA_ARGS__)

#define	done return (1)

#define	optional(...)	__tesla_optional(__tesla_ignore, __VA_ARGS__)
#define	ANY_REP	INT_MAX
#define	REPEAT(m, n, ...)	__tesla_repeat(m, n, __VA_ARGS__)
#define	UPTO(n, ...)		__tesla_repeat(0, n, __VA_ARGS__)
#define	ATLEAST(n, ...)		__tesla_repeat(n, ANY_REP, __VA_ARGS__)
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

#endif	/* !TESLA_MACROS_H */


