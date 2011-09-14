/*-
 * Copyright (c) 2011 Robert N. M. Watson
 * Copyright (c) 2011 Anil Madhavapeddy
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
/*-
 * Copyright (c) 2011 Bjoern A. Zeeb
 * All rights reserved.
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
/*
 * This sample implemenation is based on assertions/tcp/tcpc_assertion.c.
 */

#include <tesla/tesla_state.h>

#include <assert.h>
#ifndef _KERNEL
#include <stdio.h>
#endif

#include "foo.h"
#include "foo_defs.h"

/*
 * State associated with this assertion in flight.
 */
static struct tesla_state	*foo_state;

/*
 * Define the maximum number of instances of the assertion to implement
 * per-thread.  Should be prime, and must be at least 2 so that the system
 * call automata works.
 */
#define	FOO_LIMIT		11

/*
 * Strings used when printing assertion failures.
 */
#define	FOO_NAME		"FOO sample state"
#define	FOO_DESCRIPTION		"FOO assignments to i"

/*
 * When an assertion is initialised, register state management with the TESLA
 * state framework. This assertion uses per-thread state, since assertions are
 * relative to specific threads.  Later use of tesla_instance will return
 * per-thread instances, and synchronisation is avoided.
 */
#ifdef _KERNEL
static
#endif
void
foo_init(int scope)
{
	int error;

	error = tesla_state_new(&foo_state, scope, FOO_LIMIT, FOO_NAME,
	    FOO_DESCRIPTION);
#ifdef _KERNEL
	if (error)
		panic("%s: tesla_state_new failed due to %s", __func__,
		    tesla_strerror(error));
#else
	assert(error == 0);
#endif
}

void
__tesla_event_field_assign_struct_g_i(struct g *g, int i)
{
	struct tesla_instance *tip;
	u_int event;
	int error, alloc;

	alloc = 0;
	error = tesla_instance_get1(foo_state, (register_t)g, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		foo_automata_init(tip);

	switch (i) {
	case FOO_0:
		event = FOO_EVENT_G_I_ASSIGN_FOO_0;
		break;
	case FOO_1:
		event = FOO_EVENT_G_I_ASSIGN_FOO_1;
		break;
	case FOO_2:
		event = FOO_EVENT_G_I_ASSIGN_FOO_2;
		break;
	case FOO_3:
		event = FOO_EVENT_G_I_ASSIGN_FOO_3;
		break;
	case FOO_4:
		event = FOO_EVENT_G_I_ASSIGN_FOO_4;
		break;
	default:
		/* Do not deliver an event the automaton cannot ever handle. */
		tesla_instance_put(foo_state, tip);
		return;
	}
	if (foo_automata_prod(tip, event))
		tesla_assert_fail(foo_state, tip);
	tesla_instance_put(foo_state, tip);
}

#ifndef _KERNEL
/* Optional enhanced error reporting. */
static void
foo_debug_callback(struct tesla_instance *tip, struct tesla_state *tes)
{

	printf("%s: assertion %s failed, *g=%p %d %u\n", FOO_NAME,
	    FOO_DESCRIPTION, (void *)tip->ti_keys[0],
	    ((struct g *)tip->ti_keys[0])->i, tip->ti_state[0]);
	/*
	 * XXX-BZ Ticket #2: how do I get the real input and state transisiton
	 * in a meaning full way?
	 */
}

void
foo_setaction_debug(void)
{

	tesla_state_setaction(foo_state, foo_debug_callback);
}
#endif
