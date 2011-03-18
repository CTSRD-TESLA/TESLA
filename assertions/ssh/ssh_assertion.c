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

#include <assert.h>
#include <stdio.h>
#include <err.h>

#include <tesla/tesla_state.h>
#include <tesla/tesla_util.h>

#include "ssh_defs.h"
#include "ssh_kex_defs.h"

typedef void * Kex;

/*
 * State associated with this assertion in flight.
 */
static struct tesla_state	*tesla_ssh_state;

/*
 * Define the maximum number of instances of the assertion to implement
 * per-thread.  Should be prime, and must be at least 2 so that the system
 * call automata works.
 */
#define	TESLA_SSH_LIMIT	3

#define SSH_AUTOMATA_PACKET 1
#define SSH_AUTOMATA_KEX 2

/*
 * Strings used when printing assertion failures.
 */
#define	TESLA_SSH_NAME		"SSH automata"
#define	TESLA_SSH_DESCRIPTION	"SSH packet and kex sequencing"

/*
 * When an assertion is initialised, register state management with the TESLA
 * state framework. This assertion uses per-thread state, since assertions are
 * relative to specific threads.  Later use of tesla_instance will return
 * per-thread instances, and synchronisation is avoided.
 */
void
tesla_ssh_init(int scope)
{
	int error;

	error = tesla_state_new(&tesla_ssh_state, TESLA_SCOPE_GLOBAL, TESLA_SSH_LIMIT, TESLA_SSH_NAME,
	    TESLA_SSH_DESCRIPTION);
	assert(error == 0);
}

/*
 * When the checker is unloaded, GC its state.  Hopefully also un-instruments.
 */
void
tesla_ssh_destroy(void)
{

	tesla_state_destroy(tesla_ssh_state);
}

void
__tesla_event_function_prologue_packet_set_connection(void **tesla_data, int fd1, int fd2)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_PACKET, &tip, &alloc);
	if (error)
		return;
	if (alloc == 0)
		errx(1, "set_connection must alloc a new automaton as it is first event");
	ssh_automata_init(tip);
	if (ssh_automata_prod(tip, SSH_EVENT_FUNC_PROLOGUE_PACKET_SET_CONNECTION))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

void
__tesla_event_function_prologue_packet_start(void **tesla_data)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_PACKET, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		errx(1,"pstart alloc shouldnt happen");
	if (ssh_automata_prod(tip, SSH_EVENT_FUNC_PROLOGUE_PACKET_START))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

void
__tesla_event_function_prologue_packet_send(void **tesla_data)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_PACKET, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		errx(1,"pend alloc shouldnt happen");
	
	if (ssh_automata_prod(tip, SSH_EVENT_FUNC_PROLOGUE_PACKET_SEND))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

void
__tesla_event_function_prologue_kex_setup(void **tesla_data, char **unused)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_KEX, &tip, &alloc);
	if (error)
		return;
	if (alloc == 0)
		errx(1,"noalloc");
	ssh_kex_automata_init(tip);
	if (ssh_kex_automata_prod(tip, SSH_KEX_EVENT_FUNC_PROLOGUE_KEX_SETUP))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

void
__tesla_event_function_prologue_kex_finish(void **tesla_data, Kex *unused)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_KEX, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		errx(1,"alloc");
	if (ssh_kex_automata_prod(tip, SSH_KEX_EVENT_FUNC_PROLOGUE_KEX_FINISH))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

void
__tesla_event_function_prologue_kex_send_kexinit(void **tesla_data, Kex *unused)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_KEX, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		errx(1,"alloc");
	if (ssh_kex_automata_prod(tip, SSH_KEX_EVENT_FUNC_PROLOGUE_KEX_SEND_KEXINIT))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

void
__tesla_event_function_prologue_kex_input_kexinit(void **tesla_data, int i1, u_int32_t i2, void *i3)
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_KEX, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		errx(1,"alloc");
	if (ssh_kex_automata_prod(tip, SSH_KEX_EVENT_FUNC_PROLOGUE_KEX_INPUT_KEXINIT))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

void
__tesla_event_function_prologue_kex_choose_conf(void **tesla_data, Kex *unused) 
{
	struct tesla_instance *tip;
	int error, alloc=0;

	error = tesla_instance_get1(tesla_ssh_state, SSH_AUTOMATA_KEX, &tip, &alloc);
	if (error)
		return;
	if (alloc == 1)
		errx(1,"alloc");
	if (ssh_kex_automata_prod(tip, SSH_KEX_EVENT_FUNC_PROLOGUE_KEX_CHOOSE_CONF))
		tesla_assert_fail(tesla_ssh_state, tip);
	tesla_instance_put(tesla_ssh_state, tip);
}

#define STUBFN(fn) void __tesla_event_function_return_##fn(void **tesla_data) { }
STUBFN(packet_start);
STUBFN(packet_send);
STUBFN(packet_set_connection);
STUBFN(kex_setup);
STUBFN(kex_send_kexinit);
STUBFN(kex_input_kexinit);
STUBFN(kex_choose_conf);
STUBFN(kex_finish);

static void
tesla_ssh_debug_callback(struct tesla_instance *tip)
{

	printf("%s: assertion %s failed, tcbcb %p\n", TESLA_SSH_NAME,
	    TESLA_SSH_DESCRIPTION, (void *)tip->ti_keys[0]);
}

void
tesla_ssh_setaction_debug(void)
{

	tesla_state_setaction(tesla_ssh_state, tesla_ssh_debug_callback);
}
