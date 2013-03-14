/*
 * Copyright (c) 2012-2013 Jonathan Anderson
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

#include "demo.h"
#include "tcp.h"
#include "tesla-macros.h"

#include <assert.h>
#include <openssl/des.h>

#define previously_in_syscall(x)    since(called(example_syscall), x)
#define eventually_in_syscall(x)    before(returned(example_syscall), x)

int
perform_operation(int op, struct object *o)
{
#ifdef TESLA
	/* A very simple TESLA assertion. */
	TESLA_PERTHREAD(previously_in_syscall(security_check(ANY(ptr), o, op) == 0));

	/* An even simpler assertion! */
	TESLA_PERTHREAD(previously_in_syscall(called(security_check)));

	/* More simple assertions. */
	TESLA_PERTHREAD(previously_in_syscall(called(hold, o)));
	TESLA_PERTHREAD(previously_in_syscall(returned(hold, o)));
	TESLA_PERTHREAD(eventually_in_syscall(called(release, o)));

	/* A simple assertion about struct manipulation. */
	TESLA_PERTHREAD(previously_in_syscall(o->refcount += 1));

#ifdef NOTYET
	/* An example of using high-level TESLA macros. */
	TESLA_PERTHREAD(
		previously_in_syscall(security_check(ANY(ptr), o, op) == 0)
		||
		eventually_in_syscall(log_audit_record(o, op) == 0)
	);

	/* An example of using the lower-level TESLA interface. */
	TESLA_GLOBAL(
		TSEQUENCE(
			called(example_syscall),
			get_object(ANY(int), ANY(ptr)) == 0,
			security_check(ANY(ptr), o, op) == 0,
			some_helper(op) == 0 || called(never_actually_called),
			optional(called(void_helper, o)),
			returned(release, o),
			returned(example_syscall)
		)
		||
		eventually_in_syscall(log_audit_record(o, op) == 0)
	);
#endif
#endif

	return 0;
}


int
example_syscall(struct credential *cred, int index, int op)
{
	struct object *o;
	int error = get_object(index, &o);
	if (error != 0)
		return (error);

	des_cblock		des_key;
	des_key_schedule	key_schedule;

	crypto_setup(&des_key, &key_schedule);

	if ((error = security_check(cred, o, op))) return error;
	some_helper(op);
	void_helper(o);
	perform_operation(op, o);

	crypto_encrypt(&des_key, &key_schedule);

	release(o);

	return 0;
}

/* TODO: instrument a varargs function */

void
caller_with_literals()
{
	perform_operation(3, 0);
}

