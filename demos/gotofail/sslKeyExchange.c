/*
 * Copyright (c) 1999-2001,2005-2012 Apple Inc. All Rights Reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

/*
 * sslKeyExchange.c - Support for key exchange and server key exchange
 */

#include "integer-types.h"

#include "sslCrypto.h"
#include "sslDigests.h"
#include "sslMemory.h"
#include "sslUtils.h"

#include <assert.h>
#include <stdio.h>
#define sslErrorLog(...) fprintf(stderr, __VA_ARGS__)

static OSStatus
SSLVerifySignedServerKeyExchange(SSLContext *ctx, bool isRsa, SSLBuffer signedParams,
                                 uint8_t *signature, UInt16 signatureLen)
{
    OSStatus        err;
    SSLBuffer       hashOut, hashCtx, clientRandom, serverRandom;
    uint8_t         hashes[SSL_SHA1_DIGEST_LEN + SSL_MD5_DIGEST_LEN];
    SSLBuffer       signedHashes;
    uint8_t			*dataToSign;
	size_t			dataToSignLen;

	signedHashes.data = 0;
    hashCtx.data = 0;

    clientRandom.data = ctx->clientRandom;
    clientRandom.length = SSL_CLIENT_SRVR_RAND_SIZE;
    serverRandom.data = ctx->serverRandom;
    serverRandom.length = SSL_CLIENT_SRVR_RAND_SIZE;


	if(isRsa) {
		/* skip this if signing with DSA */
		dataToSign = hashes;
		dataToSignLen = SSL_SHA1_DIGEST_LEN + SSL_MD5_DIGEST_LEN;
		hashOut.data = hashes;
		hashOut.length = SSL_MD5_DIGEST_LEN;

		if ((err = ReadyHash(&SSLHashMD5, &hashCtx, ctx)) != 0)
			goto fail;
		if ((err = SSLHashMD5.update(&hashCtx, &clientRandom)) != 0)
			goto fail;
		if ((err = SSLHashMD5.update(&hashCtx, &serverRandom)) != 0)
			goto fail;
		if ((err = SSLHashMD5.update(&hashCtx, &signedParams)) != 0)
			goto fail;
		if ((err = SSLHashMD5.final(&hashCtx, &hashOut)) != 0)
			goto fail;
	}
	else {
		/* DSA, ECDSA - just use the SHA1 hash */
		dataToSign = &hashes[SSL_MD5_DIGEST_LEN];
		dataToSignLen = SSL_SHA1_DIGEST_LEN;
	}

	hashOut.data = hashes + SSL_MD5_DIGEST_LEN;
    hashOut.length = SSL_SHA1_DIGEST_LEN;
    if ((err = SSLFreeBuffer(&hashCtx, ctx)) != 0)
        goto fail;

    if ((err = ReadyHash(&SSLHashSHA1, &hashCtx, ctx)) != 0)
        goto fail;
    if ((err = SSLHashSHA1.update(&hashCtx, &clientRandom)) != 0)
        goto fail;
    if ((err = SSLHashSHA1.update(&hashCtx, &serverRandom)) != 0)
        goto fail;
    if ((err = SSLHashSHA1.update(&hashCtx, &signedParams)) != 0)
        goto fail;
        goto fail;
    if ((err = SSLHashSHA1.final(&hashCtx, &hashOut)) != 0)
        goto fail;

#if 0
	err = sslRawVerify(ctx,
                       ctx->peerPubKey,
                       dataToSign,				/* plaintext */
                       dataToSignLen,			/* plaintext length */
                       signature,
                       signatureLen);
#endif
	if(err) {
		sslErrorLog("SSLDecodeSignedServerKeyExchange: sslRawVerify "
                    "returned %d\n", (int)err);
		goto fail;
	}

fail:
    SSLFreeBuffer(&signedHashes, ctx);
    SSLFreeBuffer(&hashCtx, ctx);
    return err;

}

/*
 * Decode and verify a server key exchange message signed by server's
 * public key.
 */
OSStatus
SSLDecodeSignedServerKeyExchange(SSLBuffer message, SSLContext *ctx)
{
	OSStatus        err;
    UInt16          signatureLen;
    uint8_t         *signature;
	bool			isRsa = true;

#if 0
	assert(ctx->protocolSide == kSSLClientSide);
#endif

    if (message.length < 2) {
    	sslErrorLog("SSLDecodeSignedServerKeyExchange: msg len error 1\n");
        return errSSLProtocol;
    }

	/* first extract the key-exchange-method-specific parameters */
    uint8_t *charPtr = message.data;
	uint8_t *endCp = charPtr + message.length;

	charPtr += 8;
#if 0
	switch(ctx->selectedCipherSpecParams.keyExchangeMethod) {
		case SSL_RSA:
        case SSL_RSA_EXPORT:
			modulusLen = SSLDecodeInt(charPtr, 2);
			charPtr += 2;
			if((charPtr + modulusLen) > endCp) {
				sslErrorLog("signedServerKeyExchange: msg len error 2\n");
				return errSSLProtocol;
			}
			modulus = charPtr;
			charPtr += modulusLen;

			exponentLen = SSLDecodeInt(charPtr, 2);
			charPtr += 2;
			if((charPtr + exponentLen) > endCp) {
				sslErrorLog("signedServerKeyExchange: msg len error 3\n");
				return errSSLProtocol;
			}
			exponent = charPtr;
			charPtr += exponentLen;
			break;
#if APPLE_DH
		case SSL_DHE_DSS:
		case SSL_DHE_DSS_EXPORT:
			isRsa = false;
			/* and fall through */
		case SSL_DHE_RSA:
		case SSL_DHE_RSA_EXPORT:
			err = SSLDecodeDHKeyParams(ctx, &charPtr, message.length);
			if(err) {
				return err;
			}
			break;
		#endif	/* APPLE_DH */

		case SSL_ECDHE_ECDSA:
			isRsa = false;
			/* and fall through */
		case SSL_ECDHE_RSA:
			err = SSLDecodeECDHKeyParams(ctx, &charPtr, message.length);
			if(err) {
				return err;
			}
			break;
		default:
			assert(0);
			return errSSLInternal;
	}
#endif

	/* this is what's hashed */
	SSLBuffer signedParams;
	signedParams.data = message.data;
	signedParams.length = charPtr - message.data;

#if 0
    SSLSignatureAndHashAlgorithm sigAlg;

    if (sslVersionIsLikeTls12(ctx)) {
        /* Parse the algorithm field added in TLS1.2 */
        if((charPtr + 2) > endCp) {
            sslErrorLog("signedServerKeyExchange: msg len error 499\n");
            return errSSLProtocol;
        }
        sigAlg.hash = *charPtr++;
        sigAlg.signature = *charPtr++;
    }
#endif

	signatureLen = SSLDecodeInt(charPtr, 2);
	charPtr += 2;
	if((charPtr + signatureLen) != endCp) {
		sslErrorLog("signedServerKeyExchange: msg len error 4\n");
		return errSSLProtocol;
	}
	signature = charPtr;

#if 0
    if (sslVersionIsLikeTls12(ctx))
    {
        err = SSLVerifySignedServerKeyExchangeTls12(ctx, sigAlg, signedParams,
                                                    signature, signatureLen);
    } else {
#endif
        err = SSLVerifySignedServerKeyExchange(ctx, isRsa, signedParams,
                                               signature, signatureLen);
#if 0
    }
#endif

    if(err)
        goto fail;

#if 0
	/* Signature matches; now replace server key with new key (RSA only) */
	switch(ctx->selectedCipherSpecParams.keyExchangeMethod) {
		case SSL_RSA:
        case SSL_RSA_EXPORT:
		{
			SSLBuffer modBuf;
			SSLBuffer expBuf;

			/* first free existing peerKey */
			sslFreePubKey(&ctx->peerPubKey);					/* no KCItem */

			/* and cook up a new one from raw bits */
			modBuf.data = modulus;
			modBuf.length = modulusLen;
			expBuf.data = exponent;
			expBuf.length = exponentLen;
			err = sslGetPubKeyFromBits(ctx,
				&modBuf,
				&expBuf,
				&ctx->peerPubKey);
			break;
		}
		case SSL_DHE_RSA:
		case SSL_DHE_RSA_EXPORT:
		case SSL_DHE_DSS:
		case SSL_DHE_DSS_EXPORT:
		case SSL_ECDHE_ECDSA:
		case SSL_ECDHE_RSA:
			break;					/* handled above */
		default:
			assert(0);
	}
#endif
fail:
    return err;
}
