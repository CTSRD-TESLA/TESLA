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

#ifndef TESLA_UTIL_H
#define	TESLA_UTIL_H

#include <sys/types.h>		/* register_t */

/*
 * libtesla functions mostly return error values, and therefore return
 * pointers, etc, via call-by-reference arguments.  These errors are modeled
 * on errno(2), but a separate namespace.
 */
#define	TESLA_SUCCESS		0	/* Success. */
#define	TESLA_ERROR_ENOENT	1	/* Entry not found. */
#define	TESLA_ERROR_EEXIST	2	/* Entry already present. */
#define	TESLA_ERROR_ENOMEM	3	/* Insufficient memory. */
#define	TESLA_ERROR_EINVAL	4	/* Invalid parameters. */
#define	TESLA_ERROR_UNKNOWN	5	/* An unknown (e.g. platform) error. */

/*
 * Provide string versions of TESLA errors.
 */
const char	*tesla_strerror(int error);

#endif /* TESLA_UTIL_H */
