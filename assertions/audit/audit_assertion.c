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

#include <sys/types.h>

#ifdef _KERNEL
#include <sys/param.h>
#include <sys/eventhandler.h>
#include <sys/kernel.h>
#include <sys/systm.h>
#else
#include <assert.h>
#include <stdio.h>

#include "syscalls.h"
#endif

#include <tesla/tesla.h>
#include <tesla/tesla_registration.h>
#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "audit_defs.h"

/*
 * State associated with this assertion in flight.
 */
static struct tesla_state	*audit_state;

/*
 * This assertion has two automata: an implied system call automata, and the
 * explicit autaomata described by audit_automata_states and
 * audit_automata_rules.  For more complex (multi-clause) assertions, there
 * would be an additional automata for each clause.
 *
 * Note: non-zero constants.
 */
#define	AUDIT_AUTOMATA_SYSCALL		1	/* In a system call. */
#define	AUDIT_AUTOMATA_ASSERTION	2	/* Assertion clause. */

/*
 * Define the maximum number of instances of the assertion to implement
 * per-thread.  Should be prime, and must be at least 2 so that the system
 * call automata works.
 */
#define	AUDIT_LIMIT	3

/*
 * Strings used when printing assertion failures.
 */
#define	AUDIT_NAME		"audit_submit_check"
#define	AUDIT_DESCRIPTION	"VOP_WRITE without eventual audit_submit"

#ifdef _KERNEL
static eventhandler_tag	audit_event_function_prologue_syscallenter_tag;
static eventhandler_tag	audit_event_function_prologue_syscallret_tag;
#endif

void	audit_event_function_prologue_syscallenter(void **tesla_data,
	    struct thread *td, struct syscall_args *sa);
void	audit_event_function_prologue_syscallret(void **tesla_data,
	    struct thread *td, int error, struct syscall_args *sa);

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
audit_init(int scope)
{
	int error;

	error = tesla_state_new(&audit_state, scope, AUDIT_LIMIT, AUDIT_NAME,
	    AUDIT_DESCRIPTION);
#ifdef _KERNEL
	if (error)
		panic("audit_init: tesla_state_new failed due to %s",
		    tesla_strerror(error));
#else
	assert(error == 0);
#endif

	/*
	 * Comment from MWC regarding atomicity also applies here.
	 */
#ifdef _KERNEL
	audit_event_function_prologue_syscallenter_tag =
	    EVENTHANDLER_REGISTER(tesla_event_function_prologue_syscallenter,
	    audit_event_function_prologue_syscallenter, NULL,
	    EVENTHANDLER_PRI_ANY);
	audit_event_function_prologue_syscallret_tag =
	    EVENTHANDLER_REGISTER(tesla_event_function_prologue_syscallret,
	    audit_event_function_prologue_syscallret, NULL,
	    EVENTHANDLER_PRI_ANY);
#endif
}

#ifdef _KERNEL
static void
audit_sysinit(__unused void *arg)
{

	audit_init(TESLA_SCOPE_PERTHREAD);
}
SYSINIT(audit_init, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY, audit_sysinit,
    NULL);
#endif /* _KERNEL */

/*
 * When the checker is unloaded, GC its state.  Hopefully also un-instruments.
 */
#ifdef _KERNEL
static
#endif
void
audit_destroy(void)
{

	tesla_state_destroy(audit_state);
#ifdef _KERNEL
	EVENTHANDLER_DEREGISTER(tesla_event_function_prologue_syscallenter,
	   audit_event_function_prologue_syscallenter_tag);
	EVENTHANDLER_DEREGISTER(tesla_event_function_prologue_syscallret,
	   audit_event_function_prologue_syscallret_tag);
#endif
}

#ifdef _KERNEL
static void
audit_sysuninit(__unused void *arg)
{

	audit_destroy();
}
SYSUNINIT(audit_destroy, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY,
    audit_sysuninit, NULL);
#endif /* _KERNEL */

/*
 * System call enters: prod implicit system call lifespan state machine.
 */
#ifndef _KERNEL
void
__tesla_event_function_prologue_syscallenter(void **tesla_data,
    struct thread *td, struct syscall_args *sa)
{

	audit_event_function_prologue_syscallenter(tesla_data, td, sa);
}

void
__tesla_event_function_return_syscallenter(void **tesla_data, int retval)
{

}
#endif

void
audit_event_function_prologue_syscallenter(void **tesla_data,
    struct thread *td, struct syscall_args *sa)
{
	struct tesla_instance *tip;
	int error;

	error = tesla_instance_get1(audit_state, AUDIT_AUTOMATA_SYSCALL,
	    &tip, NULL);
	if (error)
		return;
	tip->ti_state[0] = 1;		/* In syscall. */
	tesla_instance_put(audit_state, tip);
}

/*
 * Used when iterating over eventually expressions in system call return.
 */
static void
audit_iterator_callback(struct tesla_instance *tip, void *arg)
{
	u_int event = *(u_int *)arg;

	if (audit_automata_prod(tip, event))
		tesla_assert_fail(audit_state, tip);
}

/*
 * System call returns: prod implicit system call lifespan state machine,
 * prod eventually clauses, and flush all assertions.
 */
#ifndef _KERNEL
void
__tesla_event_function_prologue_syscallret(void **tesla_data,
    struct thread *td, int error, struct syscall_args *sa)
{

	audit_event_function_prologue_syscallret(tesla_data, td, error, sa);
}

void
__tesla_event_function_return_syscallret(void **tesla_data)
{

}
#endif

void
audit_event_function_prologue_syscallret(void **tesla_data, struct thread *td,
    int err, struct syscall_args *sa)
{
	struct tesla_instance *tip;
	u_int event;
	int error;

	error = tesla_instance_get1(audit_state, AUDIT_AUTOMATA_SYSCALL,
	    &tip, NULL);
	if (error)
		goto out;
	if (tip->ti_state[0] == 1)
		tip->ti_state[0] = 0;
	tesla_instance_put(audit_state, tip);

	/* Prod each eventually automata. */
	event = AUDIT_EVENT_TESLA_SYSCALL_RETURN;
	tesla_instance_foreach1(audit_state, AUDIT_AUTOMATA_ASSERTION,
	    audit_iterator_callback, &event);
out:
	tesla_state_flush(audit_state);
}

/*
 * Invocation of audit_submit(): prod the state machine.
 */
void
__tesla_event_function_prologue_audit_submit(void **tesla_data)
{
	struct tesla_instance *tip;
	u_int state;
	int error;

	error = tesla_instance_get1(audit_state, AUDIT_AUTOMATA_SYSCALL,
	    &tip, NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(audit_state, tip);
	if (state != 1)
		return;

	error = tesla_instance_get1(audit_state, AUDIT_AUTOMATA_ASSERTION,
	    &tip, NULL);
	if (error)
		return;
	if (audit_automata_prod(tip, AUDIT_EVENT_AUDIT_SUBMIT))
		tesla_assert_fail(audit_state, tip);
	tesla_instance_put(audit_state, tip);
}

/*
 * Return from audit_submit(): did we return the correct value?
 */
void
__tesla_event_function_return_audit_submit(void **tesla_data, int retval)
{
	/* TODO */
}

/*
* The event implied by the assertion; executes at that point in VOP_WRITE.
*/
void
__tesla_event_assertion_helper_which_asserts_0(void)
{
	struct tesla_instance *tip;
	int error, state;

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(audit_state, AUDIT_AUTOMATA_SYSCALL,
	    &tip, NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(audit_state, tip);
	if (state != 1)
		return;

	error = tesla_instance_get1(audit_state, AUDIT_AUTOMATA_ASSERTION,
	    &tip, NULL);
	if (error)
		return;
	if (audit_automata_prod(tip, AUDIT_EVENT_ASSERTION))
		tesla_assert_fail(audit_state, tip);
	tesla_instance_put(audit_state, tip);
}

static void
audit_debug_callback(struct tesla_instance *tip)
{

	printf("%s: assertion %s failed\n", AUDIT_NAME, AUDIT_DESCRIPTION);
}

void
audit_setaction_debug(void)
{

	tesla_state_setaction(audit_state, audit_debug_callback);
}
