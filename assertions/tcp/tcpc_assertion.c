/*-
 * Copyright (c) 2011 Robert N. M. Watson
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

#include <sys/types.h>

#ifdef _KERNEL
#include <sys/param.h>
#include <sys/kernel.h>
#include <sys/socket.h>
#include <sys/socketvar.h>
#include <sys/systm.h>
#include <netinet/tcp_fsm.h>
#include <netinet/tcp.h>
#include <netinet/tcp_var.h>
#else
#include <assert.h>
#include <stdio.h>
#include "tcpc_userspace.h"
#endif

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "tcpc_defs.h"

/*
 * State associated with this assertion in flight.
 */
static struct tesla_state	*tcpc_state;

/*
 * Define the maximum number of instances of the assertion to implement
 * per-thread.  Should be prime, and must be at least 2 so that the system
 * call automata works.
 */
#define	TCPC_LIMIT	11

/*
 * Strings used when printing assertion failures.
 */
#define	TCPC_NAME		"TCP connect tstate"
#define	TCPC_DESCRIPTION	"Ensure TCP connect assignments to tstate are valid"

/*
 * When an assertion is initialised, register state management with the TESLA
 * state framework. This assertion uses per-thread state, since assertions are
 * relative to specific threads.  Later use of tesla_instance will return
 * per-thread instances, and synchronisation is avoided.
 */
#ifdef _KERNEL
static
#endif
void
tcpc_init(int scope)
{
	int error;

	error = tesla_state_new(&tcpc_state, scope, TCPC_LIMIT, TCPC_NAME,
	    TCPC_DESCRIPTION);
#ifdef _KERNEL
	if (error)
		panic("tcpc_init: tesla_state_new failed due to %s",
		    tesla_strerror(error));
#else
	assert(error == 0);
#endif
#if 0
	/*
	 * In the future, this will somehow register instrumentation?  How to
	 * ensure this is (relatively) atomic?
	 */
	TESLA_INSTRUMENTATION(tcpc_state, tesla_syscall_enter,
	    tcpc_event_syscall_enter);
	TESLA_INSTRUMENTATION(tcpc_state, tesla_syscall_return,
	    tcpc_event_syscall_return);
	TESLA_INSTRUMENTATION(tcpc_state, tesla_mac_vnode_check_write,
	    tcpc_event_mac_vnode_check_write);
	TESLA_INSTRUMENTATION(tcpc_state, tesla_214872348923_assertion,
	    tcpc_event_assertion);
#endif
}

#ifdef _KERNEL
static void
tcpc_sysinit(__unused void *arg)
{

	tcpc_init(TESLA_SCOPE_GLOBAL);
}
SYSINIT(tcpc_init, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY, tcpc_sysinit, NULL);
#endif /* _KERNEL */

/*
 * When the checker is unloaded, GC its state.  Hopefully also un-instruments.
 */
#ifdef _KERNEL
static
#endif
void
tcpc_destroy(void)
{

	tesla_state_destroy(tcpc_state);
}

#ifdef _KERNEL
static void
tcpc_sysuninit(__unused void *arg)
{

	tcpc_destroy();
}
SYSUNINIT(tcpc_destroy, SI_SUB_TESLA_ASSERTION, SI_ORDER_ANY, tcpc_sysuninit,
    NULL);
#endif /* _KERNEL */

void
__tesla_event_assertion_tcp_newtcpcb_0(struct tcpcb *tcpcb)
{

	/* XXXRW: TODO: explicit initial state. */
}

void
__tesla_event_function_prologue_tcp_free(void **tesla_data,
    struct tcpcb *tcpcb)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tcpc_state, (register_t)tcpcb, &tip, &alloc);
	if (error)
		return;
	/* If we need to initialise before doing a free, something is very wrong
	   but do this anyway as we want to catch the error */
	if (alloc == 1)
		tcpc_automata_init(tip);
	
	if (tcpc_automata_prod(tip, TCPC_EVENT_FUNC_PROLOGUE_TCP_FREE))
		tesla_assert_fail(tcpc_state, tip);

	tesla_instance_destroy(tcpc_state, tip);
}

void
__tesla_event_function_return_tcp_free(void **tesla_data)
{

	/*
	 * No-op.  Required because we can't request just prologue or
	 * epilogue instrumentation yet.
	 */
}

/*
* An assignment event to a (struct tcpcb->t_state)
*/
void
__tesla_event_field_assign_struct_tcpcb_t_state(struct tcpcb *tcpcb,
    u_int t_state)
{
	struct tesla_instance *tip;
	u_int event;
	int error, alloc=0;

	error = tesla_instance_get1(tcpc_state, (register_t)tcpcb, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		tcpc_automata_init(tip);
	/* TODO This conversion from t_state -> event will be done via an
	   'event mapping script */
        switch (t_state) {
          case TCPS_CLOSED:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_CLOSED;
            break;
          case TCPS_LISTEN:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_LISTEN;
            break;
          case TCPS_SYN_SENT:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_SYN_SENT;
            break;
          case TCPS_SYN_RECEIVED:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_SYN_RECEIVED;
            break;
          case TCPS_CLOSE_WAIT:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_CLOSE_WAIT;
            break;
          case TCPS_FIN_WAIT_1:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_FIN_WAIT_1;
            break;
          case TCPS_CLOSING:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_CLOSING;
            break;
          case TCPS_LAST_ACK:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_LAST_ACK;
            break;
          case TCPS_FIN_WAIT_2:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_FIN_WAIT_2;
            break;
          case TCPS_TIME_WAIT:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_TIME_WAIT;
            break;
          case TCPS_ESTABLISHED:
            event = TCPC_EVENT_TP_T_STATE_ASSIGN_TCPS_ESTABLISHED;
            break;
          default:
            /* Do not deliver an event the automaton cannot ever handle */
		tesla_instance_put(tcpc_state, tip);
            return;
        }
	if (tcpc_automata_prod(tip, event))
		tesla_assert_fail(tcpc_state, tip);
	tesla_instance_put(tcpc_state, tip);
}

#ifndef _KERNEL
static void
tcpc_debug_callback(struct tesla_instance *tip)
{

	printf("%s: assertion %s failed, tcbcb %p\n", TCPC_NAME,
	    TCPC_DESCRIPTION, (void *)tip->ti_keys[0]);
}

void
tcpc_setaction_debug(void)
{

	tesla_state_setaction(tcpc_state, tcpc_debug_callback);
}
#endif
