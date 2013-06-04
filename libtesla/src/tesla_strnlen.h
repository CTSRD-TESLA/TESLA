#include "config.h"

#ifdef HAVE_STRNLEN
#ifndef _KERNEL
#include <string.h>
#endif

#else
/* If we don't have strnlen(), fake it. */
#warning Platform does not supply strnlen(); faking it with strlen().
#define strnlen(s, len) strlen(s)
#endif
