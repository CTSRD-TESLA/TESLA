/** @file openssl-api.c   Demo of how TESLA can help with OpenSSL API usage. */
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

#include <openssl/bio.h>
#include <openssl/err.h>
#include <openssl/pem.h>
#include <openssl/x509.h>
#include <openssl/x509_vfy.h>

#include <tesla-macros.h>

#include <err.h>
#include <stdbool.h>

#pragma clang diagnostic ignored "-Wdeprecated-declarations"


bool	init(void);
bool	load_cert(const char *filename, X509**, const char* *error);
bool	load_ca_cert(const char *filename, X509_STORE**, const char* *err);
bool	verify(X509 *cert, X509_STORE *trusted_certs, const char* *error);
void	use_cert(X509*);
void	cleanup(X509 *cert, X509_STORE *trusted_certs);


int
main(int argc, char *argv[]) {
	if (argc < 3) {
		printf("OpenSSL API demo\n\n");
		printf("Usage: %s <certificate> <CA certificate>\n", argv[0]);
		return 1;
	}
	const char *filename = argv[1];
	const char *ca = argv[2];

	//! The certificate we want to verify.
	X509 *cert = NULL;

	//! A store of trusted (CA) certificates.
	X509_STORE *ca_store = NULL;

	const char *error = "<unknown error>";

	if (! (
		init()
		&& load_cert(filename, &cert, &error)
		&& load_ca_cert(ca, &ca_store, &error))
		)
		fprintf(stderr, "ERROR: %s\n", error);

	else {
		if (verify(cert, ca_store, &error))
			printf("'%s' is signed by '%s'.\n", filename, ca);
		else
			printf("'%s' is NOT signed by '%s'\n", filename, ca);
	}

	use_cert(cert);
	cleanup(cert, ca_store);

	return 0;
}


bool
init()
{
	OpenSSL_add_all_algorithms();
	ERR_load_BIO_strings();
	ERR_load_crypto_strings();

	return true;
}


bool
load_cert(const char *filename, X509 **cert, const char* *error)
{
	bool success = false;

	BIO *bio = BIO_new(BIO_s_file());
	if (!bio) {
		*error = "error in BIO_new";
		return success;
	}

	if (BIO_read_filename(bio, filename) != 1) {
		*error = "error in BIO_read_filename";
		return success;
	}

	if ((*cert = PEM_read_bio_X509(bio, NULL, 0, NULL)))
		success = true;

	else
		*error = "error in PEM_read_bio_X509";

	BIO_free_all(bio);
	return success;
}


bool
load_ca_cert(const char *filename, X509_STORE* *store, const char* *error)
{
	X509_STORE *s;

	s = X509_STORE_new();
	if (!s) {
		*error = "error creating X509_STORE";
		return false;
	}

	if (X509_STORE_load_locations(s, filename, NULL) != 1) {
		*error = "error loading CA certificate [chain]";
		X509_STORE_free(s);
		return false;
	}

	*store = s;
	return true;
}


/*
 * ==========================================================================
 * This is where all of the interesting work happens, and where bugs like
 * CVE-2008-5077 can creep in:
 * ==========================================================================
 */
bool
verify(X509 *cert, X509_STORE *trusted, const char* *error)
{
	bool success = false;

	/**
	 * A "verification context"; owns memory required to do verification.
	 */
	X509_STORE_CTX *ctx = X509_STORE_CTX_new();
	if (!ctx) {
		*error = "error creating X509_STORE_CTX";
		return false;
	}

	/*
	 * ERROR: this call to X509_STORE_CTX_init() doesn't pass in the
	 *        certificate to be verified!
	 */
	if (X509_STORE_CTX_init(ctx, trusted, NULL, NULL) != 1)
	//if (X509_STORE_CTX_init(ctx, trusted, cert, NULL) != 1)
		*error = "error initialising verification context";

	else {
		int result = X509_verify_cert(ctx);

		/*
		 * ERROR: X509_verify_cert() can return three values:
		 *          1 for success
		 *          0 for failure
		 *         -1 for exceptional errors
		 */
		if (result)
		//if (result == 1)
			success = true;

		else
			*error = X509_verify_cert_error_string(ctx->error);
	}

	X509_STORE_CTX_free(ctx);
	return success;
}
/* ========================================================================== */


void
use_cert(X509 *cert)
{
#ifdef TESLA
	TESLA_WITHIN(main, previously(
		X509_STORE_CTX_init(ANY(ptr), ANY(ptr), cert, ANY(ptr)) == 1,
		X509_verify_cert(ANY(ptr)) == 1
	));
#endif

	/*
	 * Do something that actually uses the certificate, assuming that it
	 * has been correctly verified...
	 */
}


void
cleanup(X509 *cert, X509_STORE *trusted_certs)
{
	X509_STORE_free(trusted_certs);
	X509_free(cert);
}
