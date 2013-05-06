/*-
 * Copyright (c) 1982, 1986, 1989, 1993
 *	The Regents of the University of California.  All rights reserved.
 * (c) UNIX System Laboratories, Inc.
 * All or some portions of this file are derived from material licensed
 * to the University of California by American Telephone and Telegraph
 * Co. or Unix System Laboratories, Inc. and are reproduced herein with
 * the permission of UNIX System Laboratories, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)vfs_lookup.c	8.4 (Berkeley) 2/16/94
 */

#include "mac-demo.h"

#include <stdio.h>
#include <string.h>


/*
 * Convert a pathname into a pointer to a locked vnode.
 *
 * The FOLLOW flag is set when symbolic links are to be followed
 * when they occur at the end of the name translation process.
 * Symbolic links are always followed for all other pathname
 * components other than the last.
 *
 * The segflg defines whether the name is to be copied from user
 * space or kernel space.
 *
 * Overall outline of namei:
 *
 *	copy in name
 *	get starting directory
 *	while (!done && !error) {
 *		call lookup to search path.
 *		if symbolic link, massage name in buffer and continue
 *	}
 */
int
namei(struct nameidata *ndp)
{
	int error = 0;
	struct componentname *cnp = &ndp->ni_cnd;
	struct thread *td = cnp->cn_thread;

	printf("-- looking up name '%s'\n", ndp->ni_dirp);

	static struct vnode my_vnode;
	my_vnode.v_tag = "found_by_namei";

	/*
	 * set up for long and complex lookup procedure
	 */
	char buf[MAXPATHLEN];
	size_t len = strnlen(ndp->ni_dirp, MAXPATHLEN - 1);
	cnp->cn_pnbuf = strncpy(buf, ndp->ni_dirp, len);
	buf[len] = '\0';

	/*
	 * If we are auditing the kernel pathname, save the user pathname.
	 */
	if (cnp->cn_flags & AUDITVNODE1)
		AUDIT_ARG_UPATH1(td, ndp->ni_dirfd, cnp->cn_pnbuf);
	if (cnp->cn_flags & AUDITVNODE2)
		AUDIT_ARG_UPATH2(td, ndp->ni_dirfd, cnp->cn_pnbuf);

	/*
	 * long and complex lookup procedure
	 */

	ndp->ni_vp = &my_vnode;

	return (error);
}
