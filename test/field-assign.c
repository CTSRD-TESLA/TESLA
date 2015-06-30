//! @file Instrumentation/field-assign.c   Tests instrumentating field assigns.
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
 * RUN: tesla instrument -S -tesla-manifest %p/tesla.manifest %t.ll -o %t.instr.ll
 * RUN: %filecheck -input-file=%t.instr.ll %s
 *
 * XFAIL: *
 */

/*
 * TODO: if/when we move to LLVM 3.4, use CHECK-DAG here:
 *
 * CHECK: @.[[FIELD0:[_a-zA-Z0-9\.]+]] = {{.*}}some_structure.field0
 * CHECK: @.[[FILENAME:[_a-zA-Z0-9\.]+]] = {{.*}} c"{{.*}}field-assign.c
 * CHECK: @.[[FIELD1:[_a-zA-Z0-9\.]+]] = {{.*}}some_structure.field1
 */

#include <sys/types.h>

struct some_structure {
	int64_t field0 __attribute__((annotate("field:some_structure.field0")));
	int32_t field1 __attribute__((annotate("field:some_structure.field1")));
};


int main(int argc, char *argv[]) {
	struct some_structure s;

	// CHECK: call [[STORE:void @__tesla_instrumentation_struct_field_store_struct.some_structure]]
	// CHECK: .field0([[STRUCT:%struct.some_structure\* %[_a-zA-Z0-9]+]],
	// CHECK: i64 31415926
	s.field0 = 31415926;

	// CHECK: call [[STORE]].field1([[STRUCT]], i32 0
	s.field1 = 0;

	// CHECK: call [[STORE]].field1([[STRUCT]], i32 %
	s.field1++;

	// CHECK: call [[STORE]].field1([[STRUCT]], i32 %
	return --s.field1;
}

/*
 * CHECK: define private [[STORE]].field0([[STRUCT:%struct.some_structure\*]], i64, i64*){{.*}} {
 * CHECK:   [[UPDATE_STATE:call void @tesla_update_state]]
 * CHECK: }
 */

/*
 * CHECK: define private [[STORE]].field1([[STRUCT]], i32, i32*){{.*}} {
 * CHECK:   [[UPDATE_STATE]]
 * CHECK:   [[UPDATE_STATE]]
 * CHECK: }
 */
