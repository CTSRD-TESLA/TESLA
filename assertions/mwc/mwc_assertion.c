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
#else
#include <assert.h>
#include <stdio.h>
#endif

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "mwc_defs.h"

/*
 * State associated with this assertion in flight.
 */
static struct tesla_state	*mwc_state;

/*
 * This assertion has two automata: an implied system call automata, and the
 * explicit autaomata described by mwc_automata_states and
 * mwc_automata_rules.  For more complex (multi-clause) assertions, there
 * would be an additional automata for each clause.
 *
 * Note: non-zero constants.
 */
#define	MWC_AUTOMATA_SYSCALL	1	/* In a system call. */
#define	MWC_AUTOMATA_ASSERTION	2	/* Assertion clause. */

/*
 * Define the maximum number of instances of the assertion to implement
 * per-thread.  Should be prime, and must be at least 2 so that the system
 * call automata works.
 */
#define	MWC_LIMIT	3

/*
 * Strings used when printing assertion failures.
 */
#define	MWC_NAME	"mac_write_check"
#define	MWC_DESCRIPTION	"VOP_WRITE without previous mac_check_vnode_write"

/*
 * When an assertion is initialised, register state management with the TESLA
 * state framework. This assertion uses per-thread state, since assertions are
 * relative to specific threads.  Later use of tesla_instance will return
 * per-thread instances, and synchronisation is avoided.
 */
void
mwc_init(void)
{
	int error;

	/*
	 * XXXRW: More realistically, would be TESLA_SCOPE_PERTHREAD, but
	 * that doesn't work yet.
	 */
	error = tesla_state_new(&mwc_state, TESLA_SCOPE_GLOBAL, MWC_LIMIT,
	    MWC_NAME, MWC_DESCRIPTION);
#ifdef _KERNEL
	if (error)
		panic("mwc_init: tesla_state_new failed due to %s",
		    tesla_strerror(error));
#else
	assert(error == 0);
#endif
#if 0
	/*
	 * In the future, this will somehow register instrumentation?  How to
	 * ensure this is (relatively) atomic?
	 */
	TESLA_INSTRUMENTATION(mwc_state, tesla_syscall_enter,
	    mwc_event_syscall_enter);
	TESLA_INSTRUMENTATION(mwc_state, tesla_syscall_return,
	    mwc_event_syscall_return);
	TESLA_INSTRUMENTATION(mwc_state, tesla_mac_vnode_check_write,
	    mwc_event_mac_vnode_check_write);
	TESLA_INSTRUMENTATION(mwc_state, tesla_214872348923_assertion,
	    mwc_event_assertion);
#endif
}
/* SYSINIT(..., mwc_init, ...); */

/*
 * When the checker is unloaded, GC its state.  Hopefully also un-instruments.
 */
void
mwc_destroy(void)
{

	tesla_state_destroy(mwc_state);
}
/* SYSUNINIT(..., mwc_destroy, ...); */

/*
* System call enters: prod implicit system call lifespan state machine.
*/
void
mwc_event_tesla_syscall_enter(void)
{
	struct tesla_instance *tip;
	int error;

	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip);
	if (error)
		return;
	tip->ti_state[0] = 1;		/* In syscall. */
	tesla_instance_put(mwc_state, tip);
}

/*
 * System call returns: prod implicit system call lifespan state machine,
 * flush all assertions.  If we had eventually clauses, we would do a
 * tesla_instance_foreach() here to iterate over them, proding each.
 */
void
mwc_event_tesla_syscall_return(void)
{
	struct tesla_instance *tip;
	int error;

	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip);
	if (error)
		goto out;
	if (tip->ti_state[0] == 1)
		tip->ti_state[0] = 0;
	tesla_instance_put(mwc_state, tip);
out:
	tesla_state_flush(mwc_state);
}

/*
* Epilogue of mac_vnode_check_write is an event.
*/
void
mwc_event_mac_vnode_check_write(register_t cred, register_t vp,
    register_t retval)
{
	struct tesla_instance *tip;
	u_int state;
	int error;

	/*
	 * Assertion accepts only checks that succeeded.  Because pattern
	 * matching on return values may be more complicated than a simple
	 * comparison, perhaps doing bitmask operations, gt/lt, etc, we do
	 * this as explicit code here rather than matching keys later.
	 *
	 * XXX: Same argument might apply to arguments?
	 *
	 * XXX: If more than one clause in the assertion, then we might prod
	 * more than one automata here.
	 */
	if (retval != 0)
		return;

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(mwc_state, tip);
	if (state != 1)
		return;

	/*
	 * No wildcards here; if there were, we'd use tesla_instance_foreach.
	 */
	error = tesla_instance_get3(mwc_state, MWC_AUTOMATA_ASSERTION, cred,
	    vp, &tip);
	if (error)
		return;
	if (mwc_automata_prod(tip, MWC_EVENT_MAC_VNODE_CHECK_WRITE))
		tesla_assert_fail(mwc_state, tip);
	tesla_instance_put(mwc_state, tip);
}

/*
* The event implied by the assertion; executes at that point in VOP_WRITE.
*/
void
mwc_event_assertion(register_t vp, register_t cred)
{
	struct tesla_instance *tip;
	int error, state;

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(mwc_state, tip);
	if (state != 1)
		return;

	/* No argument checking for this event, they were free variables. */
	error = tesla_instance_get3(mwc_state, MWC_AUTOMATA_ASSERTION, cred,
	    vp, &tip);
	if (error)
		return;
	if (mwc_automata_prod(tip, MWC_EVENT_ASSERTION))
		tesla_assert_fail(mwc_state, tip);
	tesla_instance_put(mwc_state, tip);
}

static void
mwc_debug_callback(struct tesla_instance *tip)
{

	printf("%s: assertion %s failed, cred %p vp %p\n", MWC_NAME,
	    MWC_DESCRIPTION, (void *)tip->ti_keys[1],
	    (void *)tip->ti_keys[2]);
}

void
mwc_setaction_debug(void)
{

	tesla_state_setaction(mwc_state, mwc_debug_callback);
}
