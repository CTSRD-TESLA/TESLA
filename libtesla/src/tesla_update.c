/*-
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
 *
 * $Id$
 */

#include "tesla_internal.h"

#ifndef _KERNEL
#include <stdbool.h>
#include <inttypes.h>
#endif

#define	CHECK(fn, ...) do { \
	int err = fn(__VA_ARGS__); \
	if (err != TESLA_SUCCESS) { \
		PRINT("error in " #fn ": %s\n", tesla_strerror(err)); \
		return (err); \
	} \
} while(0)

#define	DEBUG_NAME	"libtesla.state.update"
#define PRINT(...) DEBUG(libtesla.state.update, __VA_ARGS__)

int32_t
tesla_update_state(uint32_t tesla_context, uint32_t class_id,
	const struct tesla_key *pattern,
	const char *name, const char *description,
	const struct tesla_transitions *trans)
{
	if (debugging(DEBUG_NAME)) {
		/* We should never see with multiple <<init>> transitions. */
		int init_count = 0;
		for (uint32_t i = 0; i < trans->length; i++)
			if (trans->transitions[i].flags & TESLA_TRANS_INIT)
				init_count++;

		assert(init_count < 2);
	}

	PRINT("\n====\n%s()\n", __func__);
	PRINT("  context:      %s\n",
	            (tesla_context == TESLA_SCOPE_GLOBAL
		     ? "global"
		     : "per-thread"));
	PRINT("  class:        %d ('%s')\n", class_id, name);

	PRINT("  transitions:  ");
	print_transitions(DEBUG_NAME, trans);
	PRINT("\n");
	PRINT("  key:          ");
	print_key(DEBUG_NAME, pattern);
	PRINT("\n----\n");

	struct tesla_store *store;
	CHECK(tesla_store_get, tesla_context, TESLA_MAX_CLASSES,
	    TESLA_MAX_INSTANCES, &store);
	PRINT("store: 0x%tx\n", (intptr_t) store);

	struct tesla_class *class;
	CHECK(tesla_class_get, store, class_id, &class, name, description);

	print_class(class);

	// Did we match any instances?
	bool matched_something = false;

	// When we're done, do we need to clean up the class?
	bool cleanup_required = false;

	// Make space for cloning existing instances.
	size_t cloned = 0;
	struct clone_info {
		tesla_instance *old;
		tesla_instance new;
		const tesla_transition *transition;
	} clones[class->tc_free];

	// Update existing instances, forking/specialising if necessary.
	for (uint32_t i = 0; i < class->tc_limit; i++) {
		tesla_instance *inst = class->tc_instances + i;
		if (!tesla_instance_active(inst))
			continue;

		// Is this instance required to take a transition?
		bool transition_required = false;

		// Has this instance actually taken a transition?
		bool transition_taken = false;

		for (uint32_t j = 0; j < trans->length; j++) {
			tesla_transition *t = trans->transitions + j;
			const tesla_key *inst_key = &inst->ti_key;

			// Check whether or not the instance matches the
			// provided key, masked by what the transition says to
			// expect from its 'previous' state.
			tesla_key masked = *pattern;
			masked.tk_mask &= t->mask;

			if (!tesla_key_matches(&masked, inst_key))
				continue;

			if (inst_key->tk_mask != t->mask)
				continue;

			if (inst->ti_state != t->from) {
				// If the instance matches everything but the
				// state, so there had better be a transition
				// somewhere in 'trans' that can be taken!
				if (inst_key->tk_mask == masked.tk_mask)
					transition_required = true;

				continue;
			}

			// The match has succeeded: we are either going to
			// update or clone an existing state.
			transition_taken = true;
			matched_something = true;

			if (t->flags & TESLA_TRANS_CLEANUP)
				cleanup_required = true;

			// If the keys just match, just update the state.
			if (SUBSET(pattern->tk_mask, inst_key->tk_mask)) {
				tesla_notify_transition(class, inst, t);

				inst->ti_state = t->to;
				break;
			}

			// If the keys weren't an exact match, we need to fork
			// a new (more specific) automaton instance.
			struct clone_info *clone = clones + cloned++;
			clone->old = inst;
			clone->new = *inst;
			clone->new.ti_state = t->to;

			CHECK(tesla_key_union, &clone->new.ti_key, pattern);

			clone->transition = t;
			break;
		}

		if (transition_required && !transition_taken)
			tesla_notify_assert_fail(class, inst, trans);
	}

	// Move any clones into the class.
	for (size_t i = 0; i < cloned; i++) {
		struct clone_info *c = clones + i;
		struct tesla_instance *copied_in_place;

		CHECK(tesla_clone, class, &c->new, &copied_in_place);
		tesla_notify_clone(class, c->old, copied_in_place,
			c->transition);
	}


	// Does this transition cause class instance initialisation?
	for (uint32_t i = 0; i < trans->length; i++) {
		const tesla_transition *t = trans->transitions + i;
		if (t->flags & TESLA_TRANS_INIT) {
			struct tesla_instance *inst;
			CHECK(tesla_instance_new, class, pattern, t->to, &inst);
			assert(tesla_instance_active(inst));

			matched_something = true;
			tesla_notify_new_instance(class, inst);
		}
	}

	// Does it cause class cleanup?
	if (cleanup_required)
		tesla_class_reset(class);

	print_class(class);
	PRINT("\n====\n\n");

	if (!matched_something)
		tesla_notify_match_fail(class, pattern, trans);

	tesla_class_put(class);

	return (TESLA_SUCCESS);
}

enum tesla_action_t
tesla_action(const tesla_instance *inst, const tesla_key *pattern,
	const tesla_transitions *trans, const tesla_transition* *trigger)
{
	assert(trigger != NULL);

	if (!tesla_instance_active(inst))
		return IGNORE;

	/*
	 * We allowed to ignore this instance if its name doesn't match
	 * any of the given transitions.
	 */
	bool ignore = true;

	for (size_t i = 0; i < trans->length; i++) {
		const tesla_transition *t = trans->transitions + i;

		if (t->from == inst->ti_state) {
			/*
			 * Sanity check: does the transition (or the instance)
			 *               have the wrong mask value?
			 */
			if (inst->ti_key.tk_mask != t->mask)
				return PANIC;

			/*
			 * If the instance's current (masked) name matches the
			 * pattern exactly, we simply need to update the
			 * instance's state.
			 */
			tesla_key masked_name = inst->ti_key;
			masked_name.tk_mask &= pattern->tk_mask;

			if (tesla_key_matches(pattern, &masked_name)) {
				*trigger = t;
				return UPDATE;
			}

			/*
			 * Otherwise, the instance's name may be a subset of
			 * the pattern: it may match the pattern as masked
			 * by the transition's mask.
			 */
			tesla_key masked_pattern = *pattern;
			masked_pattern.tk_mask &= t->mask;

			if (tesla_key_matches(&masked_pattern, &inst->ti_key)) {
				/*
				 * If so, we need to fork a more-specific
				 * instance from this too-general one.
				 */
				*trigger = t;
				return FORK;
			}

			/*
			 * If we are in the right state but don't match on
			 * the pattern, even with a mask, move on to the
			 * next transition.
			 */
			continue;
		}

		/*
		 * We are not in the correct state for this transition, so
		 * we can't take it.
		 *
		 * If we match the pattern, however, it means that *some*
		 * transition must match; we are no longer allowed to ignore
		 * this instance.
		 */
		if (tesla_key_matches(pattern, &inst->ti_key))
			ignore = false;
	}

	if (ignore)
		return IGNORE;

	else
		return FAIL;
}
