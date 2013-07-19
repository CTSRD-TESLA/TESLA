/**
 * @file failures.d
 * DTrace script to print information about TESLA failures.
 */
/*
 * Copyright (c) 2013 Jonathan Anderson
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

tesla::fail:bad-transition
{
	name = stringof(args[0]->tc_name);
	inst = args[1];
	transitions = args[2];

	printf("%s:%s", execname, name);
	@bad_transition[execname, name,
	                inst->ti_key.tk_mask, inst->ti_state,
	                stringof(transitions->description), stack()] = count();
}

tesla::fail:no-instance-match
{
	name = stringof(args[0]->tc_name);
	instances = args[1];
	key = args[2];
	transitions = args[3];

	printf("%s:%s", execname, name);
	@no_instance[execname, name, stringof(key),
	             stringof(transitions->description), stringof(instances),
	             stack()] = count();
}

tesla::fail:other-error
{
	name = stringof(args[0]->tc_name);
	errnum = args[1];
	message = stringof(args[2]);

	printf("%s:%s - error %d; %s", execname, name, errnum, message);
	@other[execname, name, errnum, message, stack()] = count();
}

END
{
	printf("\n");
        printf("=======================================");
	printf("=======================================\n");
	printf("Bad transition:\n");
	printf("---------------------------------------");
	printf("---------------------------------------\n");
	printa("%@6u:%-12s  %s\n%6d:0x%-10x  %s%k\n", @bad_transition);
	printf("=======================================");
	printf("=======================================\n");

	printf("\n");
        printf("=======================================");
	printf("=======================================\n");
	printf("No instance:\n");
	printf("---------------------------------------");
	printf("---------------------------------------\n");
	printa("%@6u:%-12s  %s\n%-20s %s\n%s%k\n", @no_instance);
	printf("=======================================");
	printf("=======================================\n");

	printf("\n");
        printf("=======================================");
	printf("=======================================\n");
	printf("Other TESLA errors:\n");
	printf("---------------------------------------");
	printf("---------------------------------------\n");
	printa("%10s    %55s    %3d   %s  %@u%k\n", @other);
	printf("=======================================");
	printf("=======================================\n");
}
