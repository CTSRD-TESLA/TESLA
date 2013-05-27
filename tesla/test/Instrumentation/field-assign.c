/*! @file callee.ll   Tests instrumentation of field assignment. */
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
 * RUN: FileCheck -input-file=%t.instr.ll %s
 * RUN: clang %ldflags %t.instr.ll -o %t
 * RUN: %t
 */

/*
 * CHECK-DAG: @.[[FIELD0:[_a-zA-Z0-9\.]+]] = {{.*}}some_structure.field0
 * CHECK-DAG: @.[[FIELD1:[_a-zA-Z0-9\.]+]] = {{.*}}some_structure.field1
 * CHECK-DAG: @.[[FILENAME:[_a-zA-Z0-9\.]+]] = {{.*}} c"{{.*}}field-assign.c
 */

#include <sys/types.h>

struct some_structure {
	int64_t field0 __attribute__((annotate("field:some_structure.field0")));
	int32_t field1 __attribute__((annotate("field:some_structure.field1")));
};


int main(int argc, char *argv[]) {
	struct some_structure s;

	// CHECK: call [[STORE:void @__tesla_instrumentation_struct_field_store_some_structure]]_field0(i64 314159265358979
	s.field0 = 314159265358979;

	// CHECK: call [[STORE]]_field1(i32 0
	s.field1 = 0;

	// CHECK: call [[STORE]]_field1(i32 %
	s.field1++;

	// CHECK: call [[STORE]]_field1(i32 %
	return --s.field1;
}

/*
 * CHECK: define private [[STORE]]_field0(i64, i64*){{.*}} {
 * CHECK: }
 */

/*
 * CHECK: define private [[STORE]]_field1(i32, i32*){{.*}} {
 * CHECK: }
 */
