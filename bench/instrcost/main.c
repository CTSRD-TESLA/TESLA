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

#include <sys/time.h>

#include <err.h>
#include <stdio.h>

#include <tesla-macros.h>

#ifndef RUNS
#error Must define RUNS=integer
#endif

void	demo(void);

int
main(int argc, char *argv[])
{
	const int ONE_MILLION = 1000000;

	struct timeval start, end;
	struct timezone tz;

	if (gettimeofday(&start, &tz) != 0)
		err(-1, "gettimeofday() failed");

	for (size_t i = 0; i < RUNS; i++)
		demo();

	if (gettimeofday(&end, &tz) != 0)
		err(-1, "gettimeofday() failed");

	struct timeval diff;
	diff.tv_sec = end.tv_sec - start.tv_sec;
	diff.tv_usec = end.tv_usec - start.tv_usec;

	while (diff.tv_usec < 0) {
		diff.tv_sec -= 1;
		diff.tv_usec += ONE_MILLION;
	}

	while (diff.tv_usec > ONE_MILLION) {
		diff.tv_sec += 1;
		diff.tv_usec -= ONE_MILLION;
	}

	float total = diff.tv_sec + ((float) diff.tv_usec) / ONE_MILLION;

	printf("%.5g", total);

	return 0;
}

void demo()
{
#ifdef DO_WORK
	const int LEN = 1000;
	int data[LEN];

	for (size_t i = 0; i < LEN; i++)
		data[i] = i;

	for (size_t i = 0; i < LEN; i++)
		data[i] = i * (LEN - i);
#else
	/*
	 * This function does literally nothing; it simply provides a place
	 * to put instrumentation and measure the cost.
	 */
#endif
}

int
foo()
{
#if (TESLA > 0)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 1)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 2)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 3)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 4)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 5)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 6)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 7)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 8)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

#if (TESLA > 9)
	TESLA_WITHIN(demo, previously(foo() == 0));
#endif

	return 0;
}
