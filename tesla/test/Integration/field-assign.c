//! @file Integration/field-assign.c   Tests instrumentating field assignment.
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
 *
 * Commands for llvm-lit:
 * RUN: clang %cflags -c -S -emit-llvm %s -o %t.ll
 * RUN: tesla analyse %s -o %t.tesla -- %cflags
 * RUN: tesla instrument -S -tesla-manifest %t.tesla %t.ll -o %t.instr.ll
 * RUN: FileCheck -input-file=%t.instr.ll %s
 * RUN: clang -g %ldflags %t.instr.ll -o %t
 * RUN: %t
 */

#include <sys/types.h>
#include <tesla-macros.h>

#define	DIGITS_OF_PI	31415926

// CHECK: [[TYPE:%struct.some_structure]] = type { i64, i32 }
struct some_structure {
	int64_t field0 __attribute__((annotate("field:some_structure.field0")));
	int32_t field1 __attribute__((annotate("field:some_structure.field1")));
};

/*
 * CHECK: [[FIELD0:@[_a-zA-Z0-9\.]+]] = {{.*}}some_structure.field0
 * CHECK: [[FIELD1:@[_a-zA-Z0-9\.]+]] = {{.*}}some_structure.field1
 * CHECK: [[FILEVAR:@[_a-zA-Z0-9\.]+]] = {{.*}}c"[[FILENAME:.*field-assign.c]]
 */


int main(int argc, char *argv[]) {
	// CHECK: call void @__tesla_instr{{.*}}_callee_enter_main
	struct some_structure s;

	// TODO: handle this without the pointer
	struct some_structure *sp = &s;

	/*
	 * CHECK: call
	 * CHECK: [[STORE:void @__tesla_instrumentation_struct_field_store_struct.some_structure]].field0(
	 * CHECK: [[STRUCT:%struct.some_structure\* %[_a-zA-Z0-9]+]],
	 * CHECK: i64 31415926, i64* %{{[_a-z0-9]+}})
	 */
	s.field0 = DIGITS_OF_PI;

	// the initialisation shouldn't be instrumented: it is a bad idea to
	// mix simple and compound assignments, as they can alias
	s.field1 = 42;

	// CHECK: call [[STORE]].field1([[STRUCT]],
	// CHECK:     i32 %{{[_a-zA-Z0-9]+}}, i32* %{{[_a-zA-Z0-9]+}})
	s.field1++;

	// CHECK: call [[STORE]].field1([[STRUCT]],
	// CHECK:     i32 %{{[_a-zA-Z0-9]+}}, i32* %{{[_a-zA-Z0-9]+}})
	s.field1--;

	TESLA_WITHIN(main, strict(TSEQUENCE(
		sp->field0 = DIGITS_OF_PI,
		// initialisation not described; bad idea to mix '=' with '+='
		sp->field1++,
		sp->field1--,
		TESLA_ASSERTION_SITE,
		sp->field1--
	)));

	// CHECK: call [[STORE]].field1([[STRUCT]],
	// CHECK:     i32 %{{[_a-zA-Z0-9]+}}, i32* %{{[_a-zA-Z0-9]+}})
	--s.field1;

	// CHECK: call void @__tesla_instr{{.*}}_callee_return_main
	return 0;
}

/*
 * CHECK: define private [[STORE]].field0([[TYPE]]*, i64, i64*){{.*}} {
 * CHECK: preamble:
 * CHECK: entry:
 *
 * CHECK: "[[FILENAME]]:{{[0-9]+}}#{{[0-9]+}}":
 *
 * CHECK: match:
 * CHECK:   icmp {{.*}} 31415926
 *
 * TODO: this should actually read DIGITS_OF_PI:
 * CHECK: "sp.field0 = 31415926":
 * CHECK:   [[UPDATE_STATE:call void @tesla_update_state]]
 *
 * CHECK: "[[FILENAME]]:{{[0-9]+}}#{{[0-9]+}}:end":
 *
 * CHECK: exit:
 * CHECK: }
 */

/*
 * CHECK: define private [[STORE]].field1([[TYPE]]*, i32, i32*){{.*}} {
 * CHECK: preamble:
 * CHECK: entry:
 *
 * CHECK: "[[FILENAME]]:{{[0-9]+}}#{{[0-9]+}}":
 *
 * CHECK: match:
 * CHECK:   [[NEW:%[_a-zA-Z0-9]+]] = add i32 %{{[_a-zA-Z0-9]+}}, 1
 * CHECK:   icmp {{.*}} [[NEW]]
 * CHECK: "sp.field1 += 1":
 * CHECK:   [[UPDATE_STATE]]
 *
 * CHECK: match:
 * CHECK:   [[NEW:%[_a-zA-Z0-9]+]] = sub i32 %{{[_a-zA-Z0-9]+}}, 1
 * CHECK:   icmp {{.*}} [[NEW]]
 * CHECK: "sp.field1 -= 1":
 * CHECK:   [[UPDATE_STATE]]
 *
 * CHECK: "[[FILENAME]]:{{[0-9]+}}#{{[0-9]+}}:end":
 *
 * CHECK: exit:
 * CHECK: }
 */
