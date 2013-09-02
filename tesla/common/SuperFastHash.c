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
 */

#include "SuperFastHash.h"

#include <unistd.h>

#undef get16bits
#if (defined(__GNUC__) && defined(__i386__)) || defined(__WATCOMC__) \
  || defined(_MSC_VER) || defined (__BORLANDC__) || defined (__TURBOC__)
#define get16bits(d) (*((const uint16_t *) (d)))
#endif

#if !defined (get16bits)
#define get16bits(d) ((((uint32_t)(((const uint8_t *)(d))[1])) << 8)\
                       +(uint32_t)(((const uint8_t *)(d))[0]) )
#endif

uint32_t SuperFastHash (const char * data, int len) {
uint32_t hash = 0, tmp;
int rem;

	if (len <= 0 || data == NULL) return 0;

	rem = len & 3;
	len >>= 2;

	/* Main loop */
	for (;len > 0; len--) {
		hash  += get16bits (data);
		tmp    = (get16bits (data+2) << 11) ^ hash;
		hash   = (hash << 16) ^ tmp;
		data  += 2*sizeof (uint16_t);
		hash  += hash >> 11;
	}

	/* Handle end cases */
	switch (rem) {
		case 3:	hash += get16bits (data);
				hash ^= hash << 16;
				hash ^= data[sizeof (uint16_t)] << 18;
				hash += hash >> 11;
				break;
		case 2:	hash += get16bits (data);
				hash ^= hash << 11;
				hash += hash >> 17;
				break;
		case 1: hash += *data;
				hash ^= hash << 10;
				hash += hash >> 1;
	}

	/* Force "avalanching" of final 127 bits */
	hash ^= hash << 3;
	hash += hash >> 5;
	hash ^= hash << 4;
	hash += hash >> 17;
	hash ^= hash << 25;
	hash += hash >> 6;

	return hash;
}

uint32_t SuperFastHashAsm (const char * data, int len) {
uint32_t hash = 0;

	if (len <= 0 || data == NULL) return 0;

#if defined(__WATCOMC__) || defined(_MSC_VER)
	__asm {
		xor   ebx, ebx
		mov   esi, data
		mov   edi, len
		mov   eax, edi
		mov   ecx, edi
		and   edi, 3
		shr   ecx, 2
		jz    L2

		L1:
		movzx ebx, word ptr [esi]   ; 0
		add   eax, ebx              ; 1
		movzx ebx, word ptr [esi+2] ; 0

		shl   ebx, 11               ; 1
		xor   ebx, eax              ; 2
		shl   eax, 16               ; 2

		add   esi, 4                ; 0
		xor   eax, ebx              ; 3
		mov   edx, eax              ; 4

		shr   eax, 11               ; 4
		add   eax, edx              ; 5
		dec   ecx                   ; 2
		jnz   L1

		L2:

		mov   ecx, edi
		cmp   ecx, 1
		jz    lcase1
		cmp   ecx, 2
		jz    lcase2
		cmp   ecx, 3
		jnz   L3

		mov    bx, word ptr [esi]
		add   eax, ebx
		xor   ebx, ebx
		mov   edx, eax
		shl   eax, 16
		xor   eax, edx
		movsx ebx, byte ptr [esi+2]
		shl   ebx, 18
		xor   eax, ebx
		mov   edx, eax
		shr   eax, 11
		add   eax, edx
		jmp   L3

		lcase2:
		mov    bx, word ptr [esi]
		add   eax, ebx
		mov   edx, eax
		shl   eax, 11
		xor   eax, edx
		mov   edx, eax
		shr   eax, 17
		add   eax, edx
		jmp   L3

		lcase1:
		movsx ebx, byte ptr [esi]
		add   eax, ebx
		mov   edx, eax
		shl   eax, 10
		xor   eax, edx
		mov   edx, eax
		shr   eax, 1
		add   eax, edx

		L3:

		mov   ebx, eax
		shl   eax, 3
		xor   eax, ebx
		mov   ebx, eax
		shr   eax, 5
		add   eax, ebx
		mov   ebx, eax
		shl   eax, 4
		xor   eax, ebx
		mov   ebx, eax
		shr   eax, 17
		add   eax, ebx
		mov   ebx, eax
		shl   eax, 25
		xor   eax, ebx
		mov   ebx, eax
		shr   eax, 6
		add   eax, ebx

		mov   hash, eax
	}
#endif

	return hash;
}
