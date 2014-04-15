#include "sslContext.h"

OSStatus SSLDecodeSignedServerKeyExchange(SSLBuffer message, SSLContext *ctx);
OSStatus SSLVerifySignedServerKeyExchange(SSLContext *ctx, bool isRsa,
                                          SSLBuffer signedParams,
                                          uint8_t *signature,
                                          UInt16 signatureLen);
