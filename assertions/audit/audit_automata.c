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

#include "audit_defs.h"

/*
 * This is a hand-crafted automata implementing the TESLA assertion:
 *
 * (assertion in VOP_WRITE) -> eventually(invoked(audit_submit()))
 *
 * Many instances of the automata may be in flight at once during a system
 * call, instantiated by invocations of tesla_assert().
 *
 * The automata recognizes !(assertion), so has a "reject" state rather than
 * an "accept" state.  The assertion matches as soon as we hit a reject
 * state.  This is a simple, one-clause previously assertion, so there is
 * just one automata, no composition required.
 *
 * (0) --tesla_assert-> (1) --audit_submit()-> (2) (loop)
 *  \                    \
 *   \                    tesla_syscall_return() --> (reject (3)) --> (4) (loop)
 *     --*-> (0)
 *
 * Note that the assertion will fire once in state 3 and then move onto state
 * 4, where it lives indefinitely.  This ensures that if firing the assertion
 * is non-fatal, such as when using assertions to trigger DTrace probes, we
 * fire only once.
 */
static struct audit_automata_state {
	int	aas_reject;
} audit_automata_states[] = {
	/* 0 */	{ 0 },	/* Awaiting tesla_assert() */
	/* 1 */	{ 0 },	/* Awaiting audit_submit() */
	/* 2 */ { 0 },	/* Termination state */
	/* 3 */	{ 1 },	/* Reject */
	/* 4 */ { 0 },	/* Loop after reject */
};
static int audit_automata_state_count = sizeof(audit_automata_states) /
    sizeof(audit_automata_states[0]);

static struct audit_automata_rule {
	u_int	aar_fromstate;
	u_int	aar_input;
	u_int	aar_tostate;
} audit_automata_rules[] = {
	{ 0, AUDIT_EVENT_ASSERTION, 1 },		/* Assertion. */
	{ 0, AUDIT_EVENT_AUDIT_SUBMIT, 0 },		/* Loop in 0. */
	{ 0, AUDIT_EVENT_TESLA_SYSCALL_RETURN, 0 },	/* Loop in 0. */
	{ 1, AUDIT_EVENT_AUDIT_SUBMIT, 2 },		/* Satisfied. */
	{ 1, AUDIT_EVENT_ASSERTION, 1 },		/* Double assertion. */
	{ 1, AUDIT_EVENT_TESLA_SYSCALL_RETURN, 3 },	/* Submit missed! */
	{ 2, AUDIT_EVENT_ASSERTION, 1 },		/* Restart. */
	{ 2, AUDIT_EVENT_AUDIT_SUBMIT, 2 },		/* Double submit. */
	{ 2, AUDIT_EVENT_TESLA_SYSCALL_RETURN, 2 },	/* Loop in 2. */
	{ 3, AUDIT_EVENT_ASSERTION, 1 },		/* Fire, Restart. */
	{ 3, AUDIT_EVENT_AUDIT_SUBMIT, 4 },		/* Loop in 4. */
	{ 3, AUDIT_EVENT_TESLA_SYSCALL_RETURN, 4 },	/* Loop in 4. */
	{ 4, AUDIT_EVENT_ASSERTION, 4 },		/* Loop in 4. */
	{ 4, AUDIT_EVENT_AUDIT_SUBMIT, 4},		/* Loop in 4. */
	{ 4, AUDIT_EVENT_TESLA_SYSCALL_RETURN, 4},	/* Loop in 4. */
};
static int audit_automata_rule_count = sizeof(audit_automata_rules) /
    sizeof(audit_automata_rules[0]);

/*
 * This automata uses only ti_state[0].
 */
#define	STATE(tip)	((tip)->ti_state[0])

static __inline struct audit_automata_rule *
audit_automata_lookup_rule(u_int state, u_int event)
{
	u_int i;

	for (i = 0; i < audit_automata_rule_count; i++) {
		if (audit_automata_rules[i].aar_fromstate == state &&
		    audit_automata_rules[i].aar_input == event)
			return (&(audit_automata_rules[i]));
	}
	return (NULL);
}

/*
 * Prod an instance of the AUDIT automata, return (1) if an assertion should
 * fire, or to let things continue gliding along.
 */
int
audit_automata_prod(struct tesla_instance *tip, u_int event)
{
	struct audit_automata_rule *aarp;
	u_int newstate;

#ifdef _KERNEL
	KASSERT(STATE(tip) < audit_automata_state_count,
	    ("audit_automata_prod: invalid state %d", STATE(tip)));
#else
	assert(STATE(tip) < audit_automata_state_count);
#endif
	aarp = audit_automata_lookup_rule(STATE(tip), event);
#ifdef _KERNEL
	KASSERT(aarp != NULL,
	    ("audit_automata_prod: event %d not accepted", event));
#else
	assert(aarp != NULL);
#endif
	STATE(tip) = newstate = aarp->aar_tostate;
	if (audit_automata_states[newstate].aas_reject)
		return (1);
	return (0);
}
