#include "sslDigests.h"
#include "sslMemory.h"

#include <assert.h>
#include <stdlib.h>


uint32_t
SSLDecodeInt(const uint8_t *p, size_t length)
{
    unsigned int val = 0;
    assert(length > 0 && length <= 4); //anything else would be an internal error.
    while (length--)
        val = (val << 8) | *p++;
    return val;
}

uint8_t *
SSLEncodeInt(uint8_t *p, unsigned int value, size_t length)
{
    unsigned char *retVal = p + length; /* Return pointer to char after int */
    assert(length > 0 && length <= 4);  //anything else would be an internal error.
    while (length--)                    /* Assemble backwards */
    {   p[length] = (uint8_t)value;     /* Implicit masking to low byte */
        value >>= 8;
    }
    return retVal;
}


OSStatus
CloneHashState(const HashReference *ref, const SSLBuffer *state,
               SSLBuffer *newState, SSLContext *ctx)
{
	return (0);
}


OSStatus
ReadyHash(const HashReference *ref, SSLBuffer *state, SSLContext *ctx)
{
	return (0);
}

OSStatus
CloseHash(const HashReference *ref, SSLBuffer *state, SSLContext *ctx)
{
	return (0);
}


OSStatus
SSLAllocBuffer(SSLBuffer *buf, size_t length, const SSLContext *ctx)
{
	buf->data = malloc(length);
	buf->length = length;

	return (0);
}

OSStatus
SSLFreeBuffer(SSLBuffer *buf, const SSLContext *ctx)
{
	free(buf->data);
	buf->data = NULL;
	buf->length = 0;

	return (0);
}


static OSStatus
NullHashInit(SSLBuffer *digestCtx, SSLContext *sslCtx)
{
	return (0);
}

static OSStatus NullHashUpdate(SSLBuffer *digestCtx, const SSLBuffer *data)
{
	return (0);
}

/* HashFinal also does HashClose */
static OSStatus NullHashFinal(SSLBuffer *digestCtx, SSLBuffer *digest)
{
	return (0);
}

static OSStatus NullHashClose(SSLBuffer *digestCtx, SSLContext *sslCtx)
{
	return (0);
}

static OSStatus NullHashClone(const SSLBuffer *src, SSLBuffer *dest)
{
	return (0);
}



static OSStatus HashSHA1Init(SSLBuffer *digestCtx, SSLContext *sslCtx)
{
    return (0);
}

static OSStatus HashSHA1Update(SSLBuffer *digestCtx, const SSLBuffer *data)
{
    return (0);
}

static OSStatus HashSHA1Final(SSLBuffer *digestCtx, SSLBuffer *digest)
{
    return (0);
}

static OSStatus HashSHA1Close(SSLBuffer *digestCtx, SSLContext *sslCtx)
{
    return (0);
}

static OSStatus HashSHA1Clone(const SSLBuffer *src, SSLBuffer *dst)
{
	return (0);
}


const HashReference SSLHashNull = {
	.contextSize = 0,
	.digestSize = 0,
	.macPadSize = 0,
	.init = NullHashInit,
	.update = NullHashUpdate,
	.final = NullHashFinal,
	.close = NullHashClose,
	.clone = NullHashClone,
};

const HashReference SSLHashMD5 = {
	.contextSize = 0,
	.digestSize = 0,
	.macPadSize = 0,
	.init = NullHashInit,
	.update = NullHashUpdate,
	.final = NullHashFinal,
	.close = NullHashClose,
	.clone = NullHashClone,
};

const HashReference SSLHashSHA1 = {
	.contextSize = 0,
	.digestSize = 0,
	.macPadSize = 0,
	.init = HashSHA1Init,
	.update = HashSHA1Update,
	.final = HashSHA1Final,
	.close = HashSHA1Close,
	.clone = HashSHA1Clone,
};

const HashReference SSLHashSHA256 = {
	.contextSize = 0,
	.digestSize = 0,
	.macPadSize = 0,
	.init = NullHashInit,
	.update = NullHashUpdate,
	.final = NullHashFinal,
	.close = NullHashClose,
	.clone = NullHashClone,
};

const HashReference SSLHashSHA384 = {
	.contextSize = 0,
	.digestSize = 0,
	.macPadSize = 0,
	.init = NullHashInit,
	.update = NullHashUpdate,
	.final = NullHashFinal,
	.close = NullHashClose,
	.clone = NullHashClone,
};
