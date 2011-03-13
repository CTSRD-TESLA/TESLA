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

#include <stdio.h>

#include <tesla/tesla_util.h>
#include <tesla/tesla_state.h>

#include "audit_defs.h"

/*
 * Test program for the 'audit' assertion.  Run a number of times with various
 * event sequences and see how it works out.
 */

void
test(int scope)
{

	printf("\nScope: %s\n", scope == TESLA_SCOPE_GLOBAL ? "global" :
	    "per-thread");

	audit_init(scope);
	audit_setaction_debug();	/* Use printf(), not assert(). */

	printf("Simulating syscall without assertion or use; should pass\n");
	audit_event_tesla_syscall_enter();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with audit_submit; should pass\n");
	audit_event_tesla_syscall_enter();
	audit_event_audit_submit();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with assertion, no submit; should fail\n");
	audit_event_tesla_syscall_enter();
	audit_event_assertion();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with assertion, submit; should pass\n");
	audit_event_tesla_syscall_enter();
	audit_event_assertion();
	audit_event_audit_submit();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with submit, assertion in wrong order; "
	    "should fail\n");
	audit_event_tesla_syscall_enter();
	audit_event_audit_submit();
	audit_event_assertion();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with double submit, assertion; should "
	    "pass\n");
	audit_event_tesla_syscall_enter();
	audit_event_assertion();
	audit_event_audit_submit();
	audit_event_audit_submit();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with double assertion, submit; should "
	    "pass\n");
	audit_event_tesla_syscall_enter();
	audit_event_assertion();
	audit_event_assertion();
	audit_event_audit_submit();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with assert/submit/assert/submit; should "
	    "pass\n");
	audit_event_tesla_syscall_enter();
	audit_event_assertion();
	audit_event_audit_submit();
	audit_event_assertion();
	audit_event_audit_submit();
	audit_event_tesla_syscall_return();

	printf("Simulating syscall with assert/submit/assert; should fail\n");
	audit_event_tesla_syscall_enter();
	audit_event_assertion();
	audit_event_audit_submit();
	audit_event_assertion();
	audit_event_tesla_syscall_return();

	audit_destroy();
}

int
main(int argc, char *argv[])
{

	test(TESLA_SCOPE_GLOBAL);
	test(TESLA_SCOPE_PERTHREAD);

	return (0);
}
