/** @file SuperFastHash.h   Hash function used by WebKit and others. */
/*
 * Copyright (c) 2010, Paul Hsieh
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * Neither my name, Paul Hsieh, nor the names of any other contributors to the
 * code use may not be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The SuperFastHash function is used by WebKit and many others; it
 * outperforms FNV and other hash functions.
 *
 * Obtained from:
 * http://www.azillionmonkeys.com/qed/hash.html
 *
 * See licensing details at:
 * http://www.azillionmonkeys.com/qed/weblicense.html
 */

#ifndef SUPER_FAST_HASH_H
#define SUPER_FAST_HASH_H

#include <sys/cdefs.h>
#include <stdint.h>

__BEGIN_DECLS

uint32_t SuperFastHash (const char * data, int len);
uint32_t SuperFastHashAsm (const char * data, int len);

__END_DECLS

#endif
