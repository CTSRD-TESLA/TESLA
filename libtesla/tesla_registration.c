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

#ifdef _KERNEL
#include <sys/param.h>
#include <sys/eventhandler.h>
#include <sys/systm.h>
#endif

#include <tesla/tesla_registration.h>

/*
 * Event handlers for the most commonly shared instrumentation points.
 *
 * This needs to be generalised, as in practice any instrumentation point
 * might be shared.  It also needs to be made to work in userspace in some
 * form.
 */
#ifdef _KERNEL
void
__tesla_event_function_prologue_syscallenter(void **tesla_data,
    struct thread *td, struct syscall_args *sa)
{

	EVENTHANDLER_INVOKE(tesla_event_function_prologue_syscallenter,
	    tesla_data, td, sa);
}

void
__tesla_event_function_return_syscallenter(void **tesla_data)
{

	/*
	 * No-op; required as we instrument in prologue/return pairs
	 * currently.
	 */
}

void
__tesla_event_function_prologue_syscallret(void **tesla_data,
    struct thread *td, int error, struct syscall_args *sa)
{

	EVENTHANDLER_INVOKE(tesla_event_function_prologue_syscallret,
	    tesla_data, td, error, sa);
}

void
__tesla_event_function_return_syscallret(void **tesla_data)
{

	/*
	 * No-op; required as we instrument in prologue/return pairs
	 * currently.
	 */
}

#endif /* _KERNEL */
