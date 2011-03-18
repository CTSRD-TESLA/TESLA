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

typedef void Kex;
void tesla_ssh_init(int scope) { return; }
void tesla_ssh_destroy(void) { return; }

void __tesla_event_function_prologue_packet_set_connection(void **tesla_data, int fd1, int fd2) { }
void __tesla_event_function_prologue_packet_start(void **tesla_data) { }
void __tesla_event_function_prologue_packet_send(void **tesla_data) { }
void __tesla_event_function_prologue_kex_setup(void **tesla_data, char **unused) {}
void __tesla_event_function_prologue_kex_finish(void **tesla_data, Kex *unused) {} 
void __tesla_event_function_prologue_kex_send_kexinit(void **tesla_data, Kex *unused) {}
void __tesla_event_function_prologue_kex_input_kexinit(void **tesla_data, int i1, u_int32_t i2, void *i3) {}
void __tesla_event_function_prologue_kex_choose_conf(void **tesla_data, Kex *unused) {} 

#define STUBFN(fn) void __tesla_event_function_return_##fn(void **tesla_data) { }
STUBFN(packet_start);
STUBFN(packet_send);
STUBFN(packet_set_connection);
STUBFN(kex_setup);
STUBFN(kex_send_kexinit);
STUBFN(kex_input_kexinit);
STUBFN(kex_choose_conf);
STUBFN(kex_finish);


void tesla_ssh_setaction_debug(void) { }
void tesla_FAKE(void) { }
