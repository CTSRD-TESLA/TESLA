/*-
 * Copyright (c) 2011 Anil Madhavapeddy
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
#include <stdlib.h>
#include <err.h>
#include <sys/time.h>

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "tcpc_userspace.h"
#include "tcpc_defs.h"

void
tcp_free(struct tcpcb *cb)
{
	free(cb);
	cb = NULL;
	return;
}

void
connect(void)
{
	struct tcpcb *cb = malloc(sizeof (struct tcpcb));
	if (!cb)
		err(1, "malloc");
	cb->t_state = TCPS_CLOSED;
	cb->t_state = TCPS_SYN_SENT;
        cb->t_state = TCPS_SYN_RECEIVED;
	cb->t_state = TCPS_ESTABLISHED;
	cb->t_state = TCPS_CLOSE_WAIT;
        cb->t_state = TCPS_LAST_ACK;
	cb->t_state = TCPS_CLOSED;
	tcp_free(cb);
}

int
main(int argc, char **argv)
{
	int i;
	struct timeval tv1, tv2, tv3;
	tcpc_init(TESLA_SCOPE_GLOBAL);
	gettimeofday(&tv1, NULL);
	for (i=0; i < 1000000; i++)
		connect();
	gettimeofday(&tv2, NULL);
	timersub(&tv2, &tv1, &tv3);
	float res = tv3.tv_sec;
	res += tv3.tv_usec / 1000000.0;
	printf("%f", res);
	return 0;
}

