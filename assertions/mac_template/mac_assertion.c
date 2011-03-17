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
#endif

#include <tesla/tesla_registration.h>
#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

/*
 * This checker is modeled on an abstract "check-before-use" (CBU) checker
 * template.  The goal is to establish at the time of use whether, previously,
 * an appropriate access control check occurred using the same credential and
 * pertinent arguments.
 */

/*
 * State associated with this assertion in flight.
 */
static struct tesla_state	*cbu_state;

/*
 * This assertion has three automata: an implied system call automata, an
 * implicit automata linking call and return for %MACCHECK%() so that we can
 * confirm that the right arguments correspond to the right return value, and
 * the explicit autaomata described by automata_states and
 * cbu_%MACCHECK%_automata_rules.  For more complex (multi-clause)
 * assertions, there would be an additional automata for each clause.
 *
 * Note: non-zero constants.
 */
#define	CBU_AUTOMATA_SYSCALL	1	/* In a system call. */
#define	CBU_AUTOMATA_MACCHECK	2	/* Call to return automata. */
#define	CBU_AUTOMATA_ASSERTION	3	/* Assertion clause. */

/*
 * Define the maximum number of instances of the assertion to implement
 * per-thread.  Should be prime, and must be at least 2 so that the system
 * call automata works.  Recursion is not used in the kernel, but if
 * non-trivial recursion was likely, setting this to a significantly higher
 * value might make sense.
 */
#define	CBU_LIMIT	11

/*
 * Strings used when printing assertion failures.
 */
#define	CBU_NAME		"cbu-%MACCHECK%"
#define	CBU_DESCRIPTION		"%ASSERT_FN% without previous %MACCHECK%"

#ifdef _KERNEL
static eventhandler_tag	cbu_event_function_prologue_syscallenter_tag;
static eventhandler_tag	cbu_event_function_prologue_syscallret_tag;
#endif

static void	cbu_event_function_prologue_syscallenter(void **tesla_data,
		    struct thread *td, struct syscall_args *sa);
static void	cbu_event_function_prologue_syscallret(void **tesla_data,
		    struct thread *td, int error, struct syscall_args *sa);

/*
 * Names for events that will trigger MAC check rules.
 */
#define	CBU_EVENT_MACCHECK	1
#define	CBU_EVENT_ASSERTION	2

/*
 * This is a hand-crafted automata implementing the TESLA assertion:
 *
 * (assertion in %ASSERT_FN%)(vp, ..., cred) ->
 *     previously(returned(%MACCHECK%(cred, vp), 0))
 *
 * Many instances of the automata may be in flight at once during a system
 * call, instantiated by invocations of tesla_assert().
 *
 * The automata recognizes !(assertion), so has a "reject" state rather than
 * an "accept" state.  The assertion matches as soon as we hit a reject
 * state.  This is a simple, one-clause previously assertion, so there is
 * just one automata, no composition required.
 *
 * (0)  --%MACCHECK%()--> (1) --tesla_assert--> (2) (loop)
 *      \
 *        tesla_assert--> (reject 3) --*--> ((4)) (loop)
 *
 * Note that the assertion will fire once in state 3 and then move onto state
 * 4, where it lives indefinitely.  This ensures that if firing the assertion
 * is non-fatal, such as when using assertions to trigger DTrace probes, we
 * fire only once.
 */
static struct automata_state {
	int	as_reject;
} automata_states[] = {
	/* 0 */	{ 0 },
	/* 1 */	{ 0 },
	/* 2 */	{ 0 },	/* Termination state */
	/* 3 */	{ 1 },	/* Reject */
	/* 4 */ { 0 },	/* Termination state */
};
static int automata_state_count = sizeof(automata_states) /
    sizeof(automata_states[0]);

static struct automata_rule {
	u_int	ar_fromstate;
	u_int	ar_input;
	u_int	ar_tostate;
} automata_rules[] = {
	{ 0, CBU_EVENT_MACCHECK, 1 },	/* Good check. */
	{ 0, CBU_EVENT_ASSERTION, 3 },	/* Missing check. */
	{ 1, CBU_EVENT_MACCHECK, 1 },	/* Multiple OK. */
	{ 1, CBU_EVENT_ASSERTION, 2 },	/* Exit state. */
	{ 2, CBU_EVENT_MACCHECK, 2 },	/* Exit state. */
	{ 2, CBU_EVENT_ASSERTION, 2 },	/* Exit state. */
	{ 3, CBU_EVENT_MACCHECK, 4 },	/* Go to exit. */
	{ 3, CBU_EVENT_ASSERTION, 4 },	/* Go to exit. */
	{ 4, CBU_EVENT_MACCHECK, 4 },	/* Exit state. */
	{ 4, CBU_EVENT_ASSERTION, 4 },	/* Exit state. */
};
static int automata_rule_count = sizeof(automata_rules) /
    sizeof(automata_rules[0]);

/*
 * This automata uses only ti_state[0].
 */
#define	STATE(tip)	((tip)->ti_state[0])

static __inline struct automata_rule *
automata_lookup_rule(u_int state, u_int event)
{
	u_int i;

	for (i = 0; i < automata_rule_count; i++) {
		if (automata_rules[i].ar_fromstate == state &&
		    automata_rules[i].ar_input == event)
			return (&(automata_rules[i]));
	}
	return (NULL);
}

/*
 * Prod an instance of the MAC check automata, return (1) if an assertion
 * should fire, or to let things continue gliding along.
 */
static int
automata_prod(struct tesla_instance *tip, u_int event)
{
	struct automata_rule *marp;
	u_int newstate;

	KASSERT(STATE(tip) < automata_state_count,
	    ("automata_prod: invalid state %d", STATE(tip)));

	marp = automata_lookup_rule(STATE(tip), event);
	KASSERT(marp != NULL,
	    ("automata_prod: event %d not accepted", event));

	STATE(tip) = newstate = marp->ar_tostate;
	if (automata_states[newstate].as_reject)
		return (1);
	return (0);
}

/*
 * When an assertion is initialised, register state management with the TESLA
 * state framework. This assertion uses per-thread state, since assertions are
 * relative to specific threads.  Later use of tesla_instance will return
 * per-thread instances, and synchronisation is avoided.
 */
static void
cbu_%MACCHECK%_sysinit(_unused void *arg)
{
	int error;

	error = tesla_state_new(&cbu_state, %STORAGE%,
	    CBU_LIMIT, CBU_NAME, CBU_DESCRIPTION);
	if (error)
		panic("cbu_%MACCHECK%_init: tesla_state_new failed due to "
		    "%s", tesla_strerror(error));

	/*
	 * The synchronisation properties of registration are a bit dubious.
	 * We probably want a global flag to enable the assertion on start,
	 * with appropriate memory barriers with respect to event handler
	 * registration.
	 */
#ifdef _KERNEL
	cbu_event_function_prologue_syscallenter_tag =
	    EVENTHANDLER_REGISTER(tesla_event_function_prologue_syscallenter,
	    cbu_event_function_prologue_syscallenter, NULL,
	    EVENTHANDLER_PRI_ANY);
	cbu_event_function_prologue_syscallret_tag =
	    EVENTHANDLER_REGISTER(tesla_event_function_prologue_syscallret,
	    cbu_event_function_prologue_syscallret, NULL,
	    EVENTHANDLER_PRI_ANY);
#endif

}
SYSINIT(cbu_%MACCHECK%_init, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY,
    cbu_%MACCHECK%_sysinit, NULL);

/*
 * When the checker is unloaded, GC its state.  Hopefully also un-instruments.
 */
static void
cbu_%MACCHECK%_sysuninit(_unused void *arg)
{

	tesla_state_destroy(cbu_state);

#ifdef _KERNEL
	EVENTHANDLER_DEREGISTER(tesla_event_function_prologue_syscallenter,
	    cbu_event_function_prologue_syscallenter_tag);
	EVENTHANDLER_DEREGISTER(tesla_event_function_prologue_syscallret,
	    cbu_event_function_prologue_syscallret_tag);
#endif
}
SYSUNINIT(cbu_%MACCHECK%_destroy, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY,
    cbu_%MACCHECK%_sysuninit, NULL);

/*
 * System call enters: prod implicit system call lifespan state machine.
 */
static void
cbu_tesla_event_function_prologue_syscallenter(void **tesla_data,
    struct thread *td, struct syscall_args *sa)
{
	struct tesla_instance *tip;
	int error;

	error = tesla_instance_get1(cbu_state,
	    CBU_AUTOMATA_SYSCALL, &tip, NULL);
	if (error)
		return;
	tip->ti_state[0] = 1;		/* In syscall. */
	tesla_instance_put(cbu_state, tip);
}

/*
 * System call returns: prod implicit system call lifespan state machine,
 * flush all assertions.  If we had eventually clauses, we would do a
 * tesla_instance_foreach() here to iterate over them, proding each.
 */
static void
cbu_tesla_event_function_prologue_syscallret(void **tesla_data,
    struct thread *td, int err, struct syscall_args *sa)
{
	struct tesla_instance *tip;
	int error;

	error = tesla_instance_get1(cbu_state,
	    CBU_AUTOMATA_SYSCALL, &tip, NULL);
	if (error)
		goto out;
	if (tip->ti_state[0] == 1)
		tip->ti_state[0] = 0;
	tesla_instance_put(cbu_state, tip);
out:
	tesla_state_flush(cbu_state);
}

/*
 * Prologue of mac_vnode_check_write() is an event.
 */
static void
cbu_tesla_event_function_prologue_mac_vnode_check_write(
    void **tesla_data, struct ucred *active_cred, struct ucred *file_cred,
    struct vnode *vp)
{
	struct tesla_instance *tip;
	u_int state;
	int error;

	/*
	 * There's no pattern matching on the arguments, so don't check them.
	 * If there were, here is the place to do it, so that the matching
	 * on, for example, call-by-reference values occurs against
	 * call-time, rather than return-time, state.  Arguments are solely
	 * used to parameterise the automata.
	 */
	/* No-op. */

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(cbu_state, CBU_AUTOMATA_SYSCALL, &tip,
	    NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(cbu_state, tip);
	if (state != 1)
		return;

	/*
	 * Create an automata for this frame, capturing the active_cred,
	 * file_cred, and vp parameters to our actual automata.  This allows
	 * us to look up whether the call matched when we process the return
	 * later.
	 *
	 * XXXRW: Possibly, we shouldn't create an automata if there isn't a
	 * match on arguments, but for now this is simpler.
	 */
	error = tesla_instance_get2(cbu_state, CBU_AUTOMATA_MACCHECK,
	    (register_t)tesla_data, &tip, NULL);
	if (error)
		return;

	tip->ti_state[0] = 1;
	%STORE_STATE%
#if 0
	tip->ti_state[1] = (register_t)active_cred;
	tip->ti_state[2] = (register_t)file_cred;
	tip->ti_state[3] = (register_t)vp;
#endif
	tesla_instance_put(cbu_state, tip);
}

/*
 * Epilogue of mac_vnode_check_write is an event.
 */
static void
_tesla_event_function_return_mac_vnode_check_write(void **tesla, int retval)
{
	struct tesla_instance *tip;
	%REGISTERARGS_DECL%
#if 0
	register_t active_cred, file_cred, vp;
#endif
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
		error = tesla_instance_get2(cbu_state, CBU_AUTOMATA_MACCHECK,
		    (register_t)tesla, &tip, NULL);
		if (error == 0)
			tesla_instance_destroy(cbu_state, tip);
		return;
	}

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(cbu_state, CBU_AUTOMATA_SYSCALL, &tip,
	    NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(cbu_state, tip);
	if (state != 1)
		return;

	/*
	 * Look up the automata for this frame pointer, which will allow us
	 * to retrieve the parameters.  Destroy when done to avoid confusing
	 * the next guy when fp is reused.
	 */
	error = tesla_instance_get2(cbu_state, CBU_AUTOMATA_MACCHECK,
	    (register_t)tesla, &tip, NULL);
	if (error)
		return;
	if (tip->ti_state[0] == 0) {
		tesla_instance_destroy(cbu_state, tip);
		return;
	}
	%EXTRACT_STATE%
#if 0
	active_cred = tip->ti_state[1];
	file_cred = tip->ti_state[2];
	vp = tip->ti_state[3];
#endif
	tesla_instance_destroy(cbu_state, tip);

	/*
	 * No wildcards here; if there were, we'd use tesla_instance_foreach.
	 */
	error = tesla_instance_get%NUMARGS%(cbu_state, CBU_AUTOMATA_ASSERTION,
	    %REGISTERARGS%, &tip, NULL);
	if (error)
		return;
	if (automata_prod(tip, CBU_EVENT_MACCHECK))
		tesla_assert_fail(cbu_state, tip);
	tesla_instance_put(cbu_state, tip);
}

/*
 * The event implied by the assertion; executes at that point in VOP_WRITE.
 */
static void
%ASSERTION_EVENT%
{
	struct tesla_instance *tip;
	int error, state;

	/*
	 * Check that we are in a system call; if not, we may have incomplete
	 * data.
	 */
	error = tesla_instance_get1(cbu_state,
	    CBU_AUTOMATA_SYSCALL, &tip, NULL);
	if (error)
		return;
	state = tip->ti_state[0];
	tesla_instance_put(cbu_state, tip);
	if (state != 1)
		return;

	/* No argument checking for this event, they were free variables. */
	error = tesla_instance_get%NUMARGS%(cbu_state, CBU_AUTOMATA_ASSERTION,
	    %KEYARGS%,
	    &tip, NULL);
	if (error)
		return;
	if (automata_prod(tip, CBU_EVENT_ASSERTION))
		tesla_assert_fail(cbu_state, tip);
	tesla_instance_put(cbu_state, tip);
}
