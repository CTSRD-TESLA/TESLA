/*
 * Commands for llvm-lit:
 * RUN: clang %cflags %s -o %t
 * RUN: %t | tee %t.out
 * RUN: FileCheck -input-file %t.out %s
 *
 * I have *no* idea why this fails on my laptop but not other machines:
 * XFAIL: darwin
 */

#include <stdint.h>
#include <stdio.h>

struct tesla_transition {
 uint32_t from;
 uint32_t mask;
 uint32_t to;
 int flags;
};

struct tesla_transitions {
 uint32_t length;
 struct tesla_transition *transitions;
};

char* sprint_transitions(char *buffer, const char *end,
    const struct tesla_transitions *);


int main(int argc, char *argv[])
{
	struct tesla_transition trans = {
		.from = 0,
		.mask = 0,
		.flags = 0
	};

	struct tesla_transition *t = &trans;

	struct tesla_transitions transss = { .length = 1, .transitions = t };
	struct tesla_transitions *tp = &transss;

	char buffer[1024];
	const char *end = buffer + sizeof(buffer);
	char *c = buffer;

	c = sprint_transitions(c, end, tp);

	// CHECK: 0:0x0) ]
	printf("%s\n", buffer);

	return 0;
}



char*
sprint_transitions(char *buffer, const char *end,
    const struct tesla_transitions *tp)
{
	char *c = buffer;
	int written;

	for (size_t i = 0; i < tp->length; i++) {
		const struct tesla_transition *t = tp->transitions + i;
		written = snprintf(c, end - c, "%d:0x%tx", t->from, t->mask);
		if (written > 0)
			c += written;

		if (t->flags & 0x01) {
			do { int written = snprintf(c, end - c, " <fork>"); if (written > 0) c += written; } while (0);
		}

		if (t->flags & 0x02) {
			do { int written = snprintf(c, end - c, " <init>"); if (written > 0) c += written; } while (0);
		}

		if (t->flags & 0x04) {
			do { int written = snprintf(c, end - c, " <clean>"); if (written > 0) c += written; } while (0);
		}

		do { int written = snprintf(c, end - c, ") "); if (written > 0) c += written; } while (0);
	}

	do { int written = snprintf(c, end - c, "]"); if (written > 0) c += written; } while (0);

	return c;
}
