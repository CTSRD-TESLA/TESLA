/** @file demo.h    Declarations of demo structs, functions. */
/*
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
 */

#ifndef	DEMO_H
#define	DEMO_H

#include <assert.h>
#include <openssl/des.h>

struct object {
	int	refcount __attribute__((annotate("field:object.refcount")));
};

struct credential {};

/*
 * Note: these examples aren't actually thread-safe!
 */
int get_object(int index, struct object **o);
void hold(struct object *o);
void release(struct object *o);

int security_check(struct credential *subject, struct object *object, int op);
int log_audit_record(struct object *object, int op);

int example_syscall(struct credential *cred, int index, int op);
int some_helper(int op);
void void_helper(struct object *object);

int crypto_setup(const_DES_cblock *key, DES_key_schedule *schedule);
int crypto_encrypt(const_DES_cblock *key, DES_key_schedule *schedule);

/**
 * Assists in testing '||':
 * previously(foo) -> previously(foo || call(never_actually_called)).
 */
void never_actually_called(void);

#endif	/* !DEMO_H */

