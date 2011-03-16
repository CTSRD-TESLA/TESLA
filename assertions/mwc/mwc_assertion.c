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
#include <sys/kernel.h>
#include <sys/systm.h>
#else
#include <assert.h>
#include <stdio.h>
#endif

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "mwc_defs.h"

#include "syscalls.c-tesla.h"

/*
 * State associated with this assertion in flight.
 */
static struct tesla_state	*mwc_state;

/*
 * This assertion has three automata: an implied system call automata, an
 * implicit automata linking call and return for mac_vnode_check_write(), and
 * the explicit autaomata described by mwc_automata_states and
 * mwc_automata_rules.  For more complex (multi-clause) assertions, there
 * would be an additional automata for each clause.
 *
 * Note: non-zero constants.
 */
#define	MWC_AUTOMATA_SYSCALL	1	/* In a system call. */
#define	MWC_AUTOMATA_MAC_VNODE_CHECK_WRITE	2 /* Call to return automata. */
#define	MWC_AUTOMATA_ASSERTION	3	/* Assertion clause. */

/*
 * Define the maximum number of instances of the assertion to implement
 * per-thread.  Should be prime, and must be at least 2 so that the system
 * call automata works.  Recursion is not used in the kernel, but if
 * non-trivial recursion was likely, setting this to a significantly higher
 * value might make sense.
 */
#define	MWC_LIMIT	11

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
#ifdef _KERNEL
static
#endif
void
mwc_init(int scope)
{
	int error;

	error = tesla_state_new(&mwc_state, scope, MWC_LIMIT, MWC_NAME,
	    MWC_DESCRIPTION);
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
	TESLA_INSTRUMENTATION(mwc_state, tesla_call_mac_vnode_check_write,
	    mwc_call_event_mac_vnode_check_write);
	TESLA_INSTRUMENTATION(mwc_state, tesla_return_mac_vnode_check_write,
	    mwc_return_event_mac_vnode_check_write);
	TESLA_INSTRUMENTATION(mwc_state, tesla_214872348923_assertion,
	    mwc_event_assertion);
#endif
}

#ifdef _KERNEL
static void
mwc_sysinit(__unused void *arg)
{

	mwc_init(TESLA_SCOPE_PERTHREAD);
}
SYSINIT(mwc_init, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY, mwc_sysinit, NULL);
#endif /* _KERNEL */

/*
 * When the checker is unloaded, GC its state.  Hopefully also un-instruments.
 */
#ifdef _KERNEL
static
#endif
void
mwc_destroy(void)
{

	tesla_state_destroy(mwc_state);
}

#ifdef _KERNEL
static void
mwc_sysuninit(__unused void *arg)
{

	mwc_destroy();
}
SYSUNINIT(mwc_destroy, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY, mwc_sysuninit,
    NULL);
#endif /* _KERNEL */

/*
* System call enters: prod implicit system call lifespan state machine.
*/
void
__tesla_event_function_prologue_syscall(void **tesla_data, int action)
{
	struct tesla_instance *tip;
	int error;

	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip, NULL);
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
__tesla_event_function_return_syscall(void **tesla_data, int retval)
{
	struct tesla_instance *tip;
	int error;

	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip, NULL);
	if (error)
		goto out;
	if (tip->ti_state[0] == 1)
		tip->ti_state[0] = 0;
	tesla_instance_put(mwc_state, tip);
out:
	tesla_state_flush(mwc_state);
}

/*
 * Prologue of mac_vnode_check_write() is an event.
 */
void
__tesla_event_function_prologue_mac_vnode_check_write(
    void **tesla_data, struct ucred *cred, struct vnode *vp)
{
	struct tesla_instance *tip;
	u_int state;
	int error;

	/*
	 * There's no pattern matching on the arguments, so don't check them.
	 * If there were, here is the place to do it, so that the matching
	 * on, for example, call-by-reference values occurs against
	 * call-time, rather than return-time, state.
	 */
	/* No-op. */

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip,
	    NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(mwc_state, tip);
	if (state != 1)
		return;

	/*
	 * Create an automata for this frame, capturing the cred and vp
	 * parameters to our actual automata.  This allows us to look up
	 * whether the call matched when we process the return later.
	 *
	 * XXXRW: Possibly, we shouldn't create an automata if there isn't a
	 * match on arguments, but for now this is simpler.
	 */
	error = tesla_instance_get2(mwc_state,
	    MWC_AUTOMATA_MAC_VNODE_CHECK_WRITE, (register_t)tesla_data, &tip, NULL);
	if (error)
		return;
	tip->ti_state[0] = 1;
	tip->ti_state[1] = (register_t)cred;
	tip->ti_state[2] = (register_t)vp;
	tesla_instance_put(mwc_state, tip);
}

/*
 * Epilogue of mac_vnode_check_write is an event.
 */
void
__tesla_event_function_return_mac_vnode_check_write(void **tesla, int retval)
{
	struct tesla_instance *tip;
	register_t cred, vp;
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
	if (retval != 0) {
		/*
		 * Even if this isn't a match, we need to GC frame pointer
		 * state.
		 */
		error = tesla_instance_get2(mwc_state,
		    MWC_AUTOMATA_MAC_VNODE_CHECK_WRITE, (register_t)tesla, &tip,
		    NULL);
		if (error == 0)
			tesla_instance_destroy(mwc_state, tip);
		return;
	}

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip, NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(mwc_state, tip);
	if (state != 1)
		return;

	/*
	 * Look up the automata for this frame pointer, which will allow us
	 * to retrieve the parameters.  Destroy when done to avoid confusing
	 * the next guy when fp is reused.
	 */
	error = tesla_instance_get2(mwc_state,
	    MWC_AUTOMATA_MAC_VNODE_CHECK_WRITE, (register_t)tesla, &tip, NULL);
	if (error)
		return;
	if (tip->ti_state[0] == 0) {
		tesla_instance_destroy(mwc_state, tip);
		return;
	}
	cred = tip->ti_state[1];
	vp = tip->ti_state[2];
	tesla_instance_destroy(mwc_state, tip);

	/*
	 * No wildcards here; if there were, we'd use tesla_instance_foreach.
	 */
	error = tesla_instance_get3(mwc_state, MWC_AUTOMATA_ASSERTION,
	    cred, vp, &tip, NULL);
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
__tesla_event_assertion_mws_assert_0(struct ucred *cred, struct vnode *vp)
{
	struct tesla_instance *tip;
	int error, state;

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(mwc_state, MWC_AUTOMATA_SYSCALL, &tip, NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(mwc_state, tip);
	if (state != 1)
		return;

	/* No argument checking for this event, they were free variables. */
	error = tesla_instance_get3(mwc_state, MWC_AUTOMATA_ASSERTION,
	    (register_t)cred, (register_t)vp, &tip, NULL);
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
