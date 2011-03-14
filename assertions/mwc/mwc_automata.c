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
#include <sys/systm.h>
#else
#include <assert.h>
#include <stdlib.h>
#endif

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "mwc_defs.h"

/*
 * This is a hand-crafted automata implementing the TESLA assertion:
 *
 * (assertion in VOP_WRITE)(vp, ..., cred) ->
 *     previously(returned(mac_vnode_check_write(cred, vp), 0))
 *
 * Many instances of the automata may be in flight at once during a system
 * call, instantiated by invocations of tesla_assert().
 *
 * The automata recognizes !(assertion), so has a "reject" state rather than
 * an "accept" state.  The assertion matches as soon as we hit a reject
 * state.  This is a simple, one-clause previously assertion, so there is
 * just one automata, no composition required.
 *
 * (0)  --mac_check_vnode_write()--> (1) --tesla_assert--> (2) (loop)
 *      \
 *        tesla_assert--> (reject 3) --*--> ((4)) (loop)
 *
 * Note that the assertion will fire once in state 3 and then move onto state
 * 4, where it lives indefinitely.  This ensures that if firing the assertion
 * is non-fatal, such as when using assertions to trigger DTrace probes, we
 * fire only once.
 */
static struct mwc_automata_state {
	int	mra_reject;
} mwc_automata_states[] = {
	/* 0 */	{ 0 },
	/* 1 */	{ 0 },
	/* 2 */	{ 0 },	/* Termination state */
	/* 3 */	{ 1 },	/* Reject */
	/* 4 */ { 0 },	/* Termination state */
};
static int mwc_automata_state_count = sizeof(mwc_automata_states) /
    sizeof(mwc_automata_states[0]);

static struct mwc_automata_rule {
	u_int	mra_fromstate;
	u_int	mra_input;
	u_int	mra_tostate;
} mwc_automata_rules[] = {
	{ 0, MWC_EVENT_MAC_VNODE_CHECK_WRITE, 1 },	/* Good check. */
	{ 0, MWC_EVENT_ASSERTION, 3 },			/* Missing check. */
	{ 1, MWC_EVENT_MAC_VNODE_CHECK_WRITE, 1 },	/* Multiple OK. */
	{ 1, MWC_EVENT_ASSERTION, 2 },			/* Exit state. */
	{ 2, MWC_EVENT_MAC_VNODE_CHECK_WRITE, 2 },	/* Exit state. */
	{ 2, MWC_EVENT_ASSERTION, 2 },			/* Exit state. */
	{ 3, MWC_EVENT_MAC_VNODE_CHECK_WRITE, 4 },	/* Go to exit. */
	{ 3, MWC_EVENT_ASSERTION, 4 },			/* Go to exit. */
	{ 4, MWC_EVENT_MAC_VNODE_CHECK_WRITE, 4 },	/* Exit state. */
	{ 4, MWC_EVENT_ASSERTION, 4 },			/* Exit state. */
};
static int mwc_automata_rule_count = sizeof(mwc_automata_rules) /
    sizeof(mwc_automata_rules[0]);

/*
 * This automata uses only ti_state[0].
 */
#define	STATE(tip)	((tip)->ti_state[0])

static __inline struct mwc_automata_rule *
mwc_automata_lookup_rule(u_int state, u_int event)
{
	u_int i;

	for (i = 0; i < mwc_automata_rule_count; i++) {
		if (mwc_automata_rules[i].mra_fromstate == state &&
		    mwc_automata_rules[i].mra_input == event)
			return (&(mwc_automata_rules[i]));
	}
	return (NULL);
}

/*
 * Prod an instance of the MWC automata, return (1) if an assertion should
 * fire, or to let things continue gliding along.
 */
int
mwc_automata_prod(struct tesla_instance *tip, u_int event)
{
	struct mwc_automata_rule *marp;
	u_int newstate;

#ifdef _KERNEL
	KASSERT(STATE(tip) < mwc_automata_state_count,
	    ("mwc_automata_prod: invalid state %d", STATE(tip)));
#else
	assert(STATE(tip) < mwc_automata_state_count);
#endif
	marp = mwc_automata_lookup_rule(STATE(tip), event);
#ifdef _KERNEL
	KASSERT(marp != NULL,
	    ("mwc_automata_prod: event %d not accepted", event));
#else
	assert(marp != NULL);
#endif
	STATE(tip) = newstate = marp->mra_tostate;
	if (mwc_automata_states[newstate].mra_reject)
		return (1);
	return (0);
}
