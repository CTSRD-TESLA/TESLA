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

#warning Compiling TESLA hacks; instrumenter unfinished?

/* Inline assertions and events. */
void
__tesla_inline_assertion(const char *filename, int line, int count,
		__tesla_locality *loc, bool predicate)
{
}

/* Stub instrumentation functions. */
void
__tesla_callee_enter_example_syscall(
	struct credential *cred, int index, int op)
{
	printf("[STUB] %s(0x%lx, %d, %d)\n",
			 __func__, (unsigned long) cred, index, op);
}

void
__tesla_callee_return_example_syscall(
	int retval, struct credential *cred, int index, int op)
{
	printf("[STUB] %s(0x%lx, %d, %d) == %d\n",
			 __func__, (unsigned long) cred, index, op, retval);
}

void
__tesla_caller_call_example_syscall(
	struct credential *cred, int index, int op)
{
	printf("[STUB] %s(0x%lx, %d, %d)\n",
			 __func__, (unsigned long) cred, index, op);
}

void
__tesla_caller_return_example_syscall(
	int retval, struct credential *cred, int index, int op)
{
	printf("[STUB] %s(0x%lx, %d, %d) == %d\n",
			 __func__, (unsigned long) cred, index, op, retval);
}

void
__tesla_callee_enter_some_helper(int op)
{
	printf("[STUB] %s(%d)\n", __func__, op);
}

void
__tesla_callee_return_some_helper(int retval, int op)
{
	printf("[STUB] %s(%d) == %d\n", __func__, op, retval);
}

void
__tesla_caller_call_some_helper(int op)
{
	printf("[STUB] %s(%d)\n", __func__, op);
}

void
__tesla_caller_return_some_helper(int retval, int op)
{
	printf("[STUB] %s(%d) == %d\n", __func__, op, retval);
}

void
__tesla_callee_enter_void_helper(struct object *o)
{
	printf("[STUB] %s(0x%lx)\n", __func__, (unsigned long) o);
}

void
__tesla_callee_return_void_helper(struct object *o)
{
	printf("[STUB] %s(0x%lx) returned\n", __func__, (unsigned long) o);
}

void
__tesla_caller_call_void_helper(struct object *o)
{
	printf("[STUB] %s(0x%lx)\n", __func__, (unsigned long) o);
}

void
__tesla_caller_return_void_helper(struct object *o)
{
	printf("[STUB] %s(0x%lx) returned\n", __func__, (unsigned long) o);
}

