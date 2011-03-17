/*-
 * Copyright (c) 2011 Anil Madhavapeddy
 * Copyright (c) 2011 Robert Watson
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

#include <stdio.h>

#include <tesla/tesla_util.h>
#include <tesla/tesla_state.h>

#include "tcpc_userspace.h"
#include "tcpc_defs.h"

/*
 * Test program for the 'tcpc' assignment assertions.
 */


static int test1[7] = { TCPS_CLOSED, TCPS_SYN_SENT,
	TCPS_SYN_RECEIVED, TCPS_ESTABLISHED, TCPS_CLOSE_WAIT,
	TCPS_LAST_ACK, TCPS_CLOSED };

static int test2[3] = { TCPS_CLOSED, TCPS_SYN_SENT, TCPS_LAST_ACK };

static int test3[2] = { TCPS_CLOSED, TCPS_CLOSED };

static int test4[5] = { TCPS_CLOSED, TCPS_SYN_SENT, TCPS_ESTABLISHED,
	TCPS_CLOSE_WAIT, TCPS_LAST_ACK };

static void
test(int scope)
{
	struct tcpcb tcb1, tcb2, tcb3, tcb4;
	int i;

	tcpc_init(scope);
	printf("\nScope: %s\n", scope == TESLA_SCOPE_GLOBAL ? "global" :
	    "per-thread");

	tcpc_setaction_debug();	/* Use printf(), not assert(). */

        printf("Sending valid sequence...");
	for (i=0; i< 7; i++)
	    __tesla_event_field_assign_struct_tcpcb_t_state(&tcb1, test1[i]);
	__tesla_event_function_prologue_tcp_free(&tcb1);
	printf(" OK\n");

	printf("Sending invalid sequence...error follows:\n");
	for (i=0; i< 3; i++)
	    __tesla_event_field_assign_struct_tcpcb_t_state(&tcb2, test2[i]);
	__tesla_event_function_prologue_tcp_free(&tcb2);
	printf(" OK\n");

	printf("Initial closed to closed:\n");
	for (i=0; i< 2; i++)
	    __tesla_event_field_assign_struct_tcpcb_t_state(&tcb3, test3[i]);
	__tesla_event_function_prologue_tcp_free(&tcb3);
	printf(" OK\n");

	printf("Free directly from TCPS_LAST_ACK\n");
	for (i=0; i< 5; i++)
	    __tesla_event_field_assign_struct_tcpcb_t_state(&tcb4, test4[i]);
	__tesla_event_function_prologue_tcp_free(&tcb4);
	printf(" OK\n");
}     

int
main(int argc, char *argv[])
{

	test(TESLA_SCOPE_GLOBAL);
	test(TESLA_SCOPE_PERTHREAD);

	return (0);
}
