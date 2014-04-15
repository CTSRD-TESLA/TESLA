#include "ssl-demo.h"
#include "sslDigests.h"

#include <tesla-macros.h>
#include <stdio.h>


static OSStatus SSLSession();
static OSStatus	SetupSession(SSLContext *);
static OSStatus	DoSensitiveThings(SSLContext *);

OSStatus HashSHA1Init(SSLBuffer *, SSLContext *);
OSStatus HashSHA1Update(SSLBuffer *, const SSLBuffer *);
OSStatus HashSHA1Final(SSLBuffer *, SSLBuffer *);


int
main(int argc, char *argv[])
{
	printf("'goto fail' demo\n");
	if (SSLSession() == 0)
		printf("success\n");
	else
		printf("failure\n");

	return (0);
}


static OSStatus
SSLSession()
{
	SSLContext ctx;
	OSStatus err;

	if ((err = SetupSession(&ctx)))
		return (err);

	if ((err = DoSensitiveThings(&ctx)))
		return (err);

	return (0);
}


static OSStatus
SetupSession(SSLContext *ctx)
{
	// handshake with the server, get signed KEX parameters

	uint8_t rawKeyExchangeSignatureData[] =
	{
		0, 2,				// length (2B): 8
		0, 0, 0, 0, 0, 0, 0, 0,		// signature (8B)
	};

	SSLBuffer keyExchangeMessage =
	{
		.data = rawKeyExchangeSignatureData,
		.length = sizeof(rawKeyExchangeSignatureData),
	};

	return SSLDecodeSignedServerKeyExchange(keyExchangeMessage, ctx);
}


static OSStatus
DoSensitiveThings(SSLContext *ctx)
{
#ifdef TESLA
	/*
	TESLA_WITHIN(SSLSession,
		previously(HashSHA1Final(ANY(ptr), ANY(ptr)) == 0));
	*/

	TESLA_WITHIN(SSLSession,
		previously(({
			SSLBuffer signedParams;

			call(SSLVerifySignedServerKeyExchange(
				ctx, ANY(int), signedParams,
				ANY(ptr), ANY(int)));

			HashSHA1Update(ANY(ptr), ANY(ptr)) == 0;
			HashSHA1Final(ANY(ptr), ANY(ptr)) == 0;

			SSLVerifySignedServerKeyExchange(
				ctx, ANY(int), signedParams,
				ANY(ptr), ANY(int))
				== 0;
		}))
	);
#endif

	return (0);
}
