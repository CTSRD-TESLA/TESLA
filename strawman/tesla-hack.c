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

#include "demo.h"
#include "tesla.h"

#include <stdio.h>

/*
 * This file contains stubs to make the demo compile without actually
 * finishing the TESLA instrumenter (which will strip out calls to
 * TESLA pseudo-functions like __tesla_inline_assertion).
 *
 * As the TESLA instrumenter becomes more real, this file should shrink to
 * nothing.
 */

/* TESLA localities (per-thread vs global). */
__tesla_locality *__tesla_global;
__tesla_locality *__tesla_perthread;

/* Inline assertions and events. */
void
__tesla_inline_assertion(const char *filename, int line, int count,
		__tesla_locality *loc, bool predicate)
{
}

bool __tesla_sequence(__tesla_event ev, ...) { return false; }

__tesla_event __tesla_now;

__tesla_event __tesla_entered(void *x) { return __tesla_now; }
__tesla_event __tesla_leaving(void *x) { return __tesla_now; }
__tesla_event __tesla_call(bool b) { return __tesla_now; }
__tesla_event __tesla_repeat(__tesla_count min, __tesla_count max,
	__tesla_event ev, ...) { return __tesla_now; }

void* __tesla_any() { return 0; }

/* Stub instrumentation functions. */
void
__tesla_callee_enter_example_syscall(
	struct credential *cred, int index, int op)
{
	printf("[STUB] called %s(0x%lx, %d, %d)\n",
			 __func__, (unsigned long) cred, index, op);
}

void
__tesla_callee_return_example_syscall(
	int retval, struct credential *cred, int index, int op)
{
	printf("[STUB] %s(0x%lx, %d, %d) == %d\n",
			 __func__, (unsigned long) cred, index, op, retval);
}

