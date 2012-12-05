/** @file  tesla_debug.c    Debugging helpers for TESLA state. */
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

#ifndef NDEBUG

#include "tesla_internal.h"

#include <stdio.h>

void
assert_instanceof(struct tesla_instance *instance, struct tesla_class *tclass)
{
	assert(instance != NULL);
	assert(tclass != NULL);

	struct tesla_table *ttp = tclass->ts_table;
	assert(ttp != NULL);

	int instance_belongs_to_class = 0;
	for (size_t i = 0; i < ttp->tt_length; i++) {
		if (instance == &ttp->tt_instances[i]) {
			instance_belongs_to_class = 1;
			break;
		}
	}

	tesla_assert(instance_belongs_to_class,
		("tesla_instance %llx not of class '%s'",
		 (register_t) instance, tclass->ts_name)
	       );

	if (tclass->ts_scope == TESLA_SCOPE_GLOBAL)
		tesla_class_global_unlock(tclass);
}

void
print_key(struct tesla_key *key)
{
	fprintf(stderr, "%llx [ ", key->tk_mask);

	for (int i = 0; i < TESLA_KEY_SIZE; i++) {
		if (key->tk_mask & (1 << i)) {
			fprintf(stderr, "%llx ", key->tk_keys[i]);
		} else {
			fprintf(stderr, "X ");
		}
	}

	fprintf(stderr, "]");
}

#endif /* !NDEBUG */

