/*-
 * Copyright (c) 2013 Robert N. M. Watson
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

#include "tesla_internal.h"

#ifdef _KERNEL
#include "opt_kdtrace.h"
#include <sys/sdt.h>

SDT_PROVIDER_DEFINE(tesla);

SDT_PROBE_DEFINE2(tesla, automata, lifetime, sunrise, sunrise,
    "enum tesla_context context", "struct tesla_lifetime *");
SDT_PROBE_DEFINE2(tesla, automata, lifetime, sunset, sunset,
    "enum tesla_context context", "struct tesla_lifetime *");
SDT_PROBE_DEFINE2(tesla, automata, instance, create, create,
    "struct tesla_class *", "struct tesla_instance *");
SDT_PROBE_DEFINE3(tesla, automata, event, transition, state-transition,
    "struct tesla_class *", "struct tesla_instance *",
    "struct tesla_transition *");
SDT_PROBE_DEFINE4(tesla, automata, instance, clone, clone,
    "struct tesla_class *", "struct tesla_instance *",
    "struct tesla_instance *", "struct tesla_transition *");
SDT_PROBE_DEFINE4(tesla, automata, fail, no_instance, no-instance-match,
    "struct tesla_class *", "const char *", "uint32_t",
    "struct tesla_transitions *");
SDT_PROBE_DEFINE3(tesla, automata, fail, bad_transition, bad-transition,
    "struct tesla_class *", "struct tesla_instance *",
    "uint32_t");
SDT_PROBE_DEFINE4(tesla, automata, fail, other_err, other-error,
    "struct tesla_class *", "uint32_t", "int32_t", "const char *");
SDT_PROBE_DEFINE2(tesla, automata, success, accept, accept,
    "struct tesla_class *", "struct tesla_instance *");
SDT_PROBE_DEFINE3(tesla, automata, event, ignored, ignored-event,
    "struct tesla_class *", "uint32_t", "struct tesla_key *");

static void
sunrise(enum tesla_context c, const struct tesla_lifetime *tl)
{

	SDT_PROBE(tesla, automata, lifetime, sunrise, c, tl, 0, 0, 0);
}

static void
sunset(enum tesla_context c, const struct tesla_lifetime *tl)
{

	SDT_PROBE(tesla, automata, lifetime, sunset, c, tl, 0, 0, 0);
}

static void
new_instance(struct tesla_class *tcp, struct tesla_instance *tip)
{

	SDT_PROBE(tesla, automata, instance, create, tcp, tip, 0, 0, 0);
}

static void
transition(struct tesla_class *tcp, struct tesla_instance *tip,
    const struct tesla_transition *ttp)
{

	SDT_PROBE(tesla, automata, event, transition, tcp, tip, ttp, 0, 0);
}

static void
clone(struct tesla_class *tcp, struct tesla_instance *origp,
    struct tesla_instance *copyp, const struct tesla_transition *ttp)
{

	SDT_PROBE(tesla, automata, instance, clone, tcp, origp, copyp, ttp, 0);
}

static void
no_instance(struct tesla_class *tcp, uint32_t symbol,
    const struct tesla_key *tkp)
{
	char instbuf[200];
	char *c = instbuf;
	const char *end = instbuf + sizeof(instbuf);

	SAFE_SPRINTF(c, end, "%d/%d instances\n",
		tcp->tc_limit - tcp->tc_free, tcp->tc_limit);

	for (uint32_t i = 0; i < tcp->tc_limit; i++) {
		const struct tesla_instance *inst = tcp->tc_instances + i;
		if (!tesla_instance_active(inst))
			continue;

		SAFE_SPRINTF(c, end, "    %2u: state %d, ", i, inst->ti_state);
		c = key_string(c, end, &inst->ti_key);
		SAFE_SPRINTF(c, end, "\n");
	}

	char keybuf[20];
	key_string(keybuf, keybuf + sizeof(keybuf), tkp);

	SDT_PROBE(tesla, automata, fail, no_instance,
		tcp, instbuf, symbol, keybuf, 0);
}

static void
bad_transition(struct tesla_class *tcp, struct tesla_instance *tip,
    uint32_t symbol)
{

	SDT_PROBE(tesla, automata, fail, bad_transition, tcp, tip, symbol,
		0, 0);
}

static void
err(const struct tesla_automaton *tap, uint32_t symbol, int32_t errnum,
    const char *message)
{

	SDT_PROBE(tesla, automata, fail, other_err,
		tap, symbol, errnum, message, 0);
}

static void
accept(struct tesla_class *tcp, struct tesla_instance *tip)
{

	SDT_PROBE(tesla, automata, success, accept, tcp, tip, 0, 0, 0);
}

static void
ignored(const struct tesla_class *tcp, uint32_t symbol,
    const struct tesla_key *tkp)
{

	SDT_PROBE(tesla, automata, event, ignored, tcp, symbol, tkp, 0, 0);
}

const struct tesla_event_handlers dtrace_handlers = {
	.teh_sunrise			= sunrise,
	.teh_sunset			= sunset,
	.teh_init			= new_instance,
	.teh_transition			= transition,
	.teh_clone			= clone,
	.teh_fail_no_instance		= no_instance,
	.teh_bad_transition		= bad_transition,
	.teh_err			= err,
	.teh_accept			= accept,
	.teh_ignored			= ignored,
};

#endif /* _KERNEL */
