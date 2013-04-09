/*-
 * Copyright (c) 2011, 2013 Robert N. M. Watson
 * Copyright (c) 2011 Anil Madhavapeddy
 * Copyright (c) 2012-2013 Jonathan Anderson
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
MALLOC_DEFINE(M_TESLA, "tesla", "TESLA internal state");
#else
#include <inttypes.h>
#include <stdio.h>
#endif


int
tesla_class_init(struct tesla_class *tclass,
                 uint32_t context, uint32_t instances)
{
	assert(tclass != NULL);
	// TODO: write a TESLA assertion about locking here.

	tclass->tc_limit = instances;

#ifdef _KERNEL
	tclass->tc_action = TESLA_ACTION_PRINTF;
#else
	tclass->tc_action = TESLA_ACTION_FAILSTOP;
#endif

	tclass->tc_scope = context;
	tclass->tc_table = tesla_malloc(
		sizeof(struct tesla_table)
		+ instances * sizeof(struct tesla_instance)
	);

	tclass->tc_limit = instances;
	tclass->tc_table->tt_length = instances;
	tclass->tc_table->tt_free = instances;

	switch (context) {
	case TESLA_SCOPE_GLOBAL:
		return tesla_class_global_postinit(tclass);

	case TESLA_SCOPE_PERTHREAD:
		return tesla_class_perthread_postinit(tclass);

	default:
		assert(0 && "unhandled TESLA context");
		return (TESLA_ERROR_UNKNOWN);
	}
}


void
tesla_class_free(struct tesla_class *class)
{
	tesla_free(class->tc_table);
	tesla_free(class);
}


int
tesla_match(struct tesla_class *tclass, const struct tesla_key *pattern,
	    struct tesla_instance **array, uint32_t *size)
{
	assert(tclass != NULL);
	assert(pattern != NULL);
	assert(array != NULL);
	assert(size != NULL);

	struct tesla_table *table = tclass->tc_table;

	// Assume that any and every instance could match.
	if (*size < table->tt_length) {
		*size = table->tt_length;
		return (TESLA_ERROR_ENOMEM);
	}

	// Copy matches into the array.
	*size = 0;
	for (uint32_t i = 0; i < table->tt_length; i++) {
		struct tesla_instance *inst = table->tt_instances + i;
		if (tesla_instance_active(inst)
		    && tesla_key_matches(pattern, &inst->ti_key)) {
			array[*size] = inst;
			*size += 1;
		}
	}

	return (TESLA_SUCCESS);
}


int
tesla_instance_active(const struct tesla_instance *i)
{
	assert(i != NULL);

	return ((i->ti_state != 0) || (i->ti_key.tk_mask != 0));
}


int32_t
tesla_instance_new(struct tesla_class *tclass, const struct tesla_key *name,
	uint32_t state, struct tesla_instance **out)
{
	assert(tclass != NULL);
	assert(name != NULL);
	assert(out != NULL);

	// A new instance must not look inactive.
	if ((state == 0) && (name->tk_mask == 0))
		return (TESLA_ERROR_EINVAL);

	struct tesla_table *ttp = tclass->tc_table;
	assert(ttp != NULL);
	tesla_assert(ttp->tt_length != 0, ("Uninitialized tesla_table"));

	if (ttp->tt_free == 0)
		return (TESLA_ERROR_ENOMEM);

	for (uint32_t i = 0; i < ttp->tt_length; i++) {
		struct tesla_instance *inst = &ttp->tt_instances[i];
		if (tesla_instance_active(inst))
			continue;

		// Initialise the new instance.
		inst->ti_key = *name;
		inst->ti_state = state;

		ttp->tt_free--;
		*out = inst;
		break;
	}

	tesla_assert(*out != NULL, ("no free instances but tt_free was > 0"));

	return (TESLA_SUCCESS);
}

int
tesla_clone(struct tesla_class *tclass, const struct tesla_instance *orig,
	struct tesla_instance **copy)
{
	return tesla_instance_new(tclass, &orig->ti_key, orig->ti_state, copy);
}

void
tesla_class_put(struct tesla_class *tsp)
{
	switch (tsp->tc_scope) {
	case TESLA_SCOPE_GLOBAL:
		return tesla_class_global_release(tsp);

	case TESLA_SCOPE_PERTHREAD:
		return tesla_class_perthread_release(tsp);

	default:
		assert(0 && "unhandled TESLA context");
	}
}

void
tesla_class_reset(struct tesla_class *c)
{

	DEBUG_PRINT("tesla_class_reset %s\n", c->tc_name);

	struct tesla_table *t = c->tc_table;
	bzero(&t->tt_instances, sizeof(struct tesla_instance) * t->tt_length);
	t->tt_free = t->tt_length;

	switch (c->tc_scope) {
	case TESLA_SCOPE_GLOBAL:
		return tesla_class_global_release(c);

	case TESLA_SCOPE_PERTHREAD:
		return tesla_class_perthread_release(c);

	default:
		assert(0 && "unhandled TESLA context");
	}
}
