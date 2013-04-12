/*
 * Test that tesla-cat can put multiple .tesla files together.
 *
 * Commands for llvm-lit (abusing the C preprocessor a bit):
 * RUN: clang -E -D FILE_A %s -o %t.a.tesla
 * RUN: clang -E -D FILE_B %s -o %t.b.tesla
 * RUN: tesla cat %t.a.tesla %t.b.tesla -o %t.tesla
 * RUN: FileCheck %s -input-file %t.tesla
 */


#ifdef FILE_A
automaton {
  identifier {
  // CHECK: name: "assertion_a"
    name: "assertion_a"
  }
  context: Global
  expression {
    type: FIELD_ASSIGN
    fieldAssign {
      type: "tcpcb"
      index: 5
      base {
        type: Variable
        index: 0
        name: "tp"
      }
      operation: SimpleAssign
      value {
        type: Constant
        name: "TCPS_CLOSED"
        value: 0
      }
      fieldName: "t_state"
    }
  }
  argument {
    type: Variable
    index: 0
    name: "tp"
  }
}
root {
  name: "assertion_a"
}
#endif


#ifdef FILE_B
automaton {
  identifier {
  // CHECK: name: "assertion_b"
    name: "assertion_b"
  }
  context: Global
  expression {
    type: FIELD_ASSIGN
    fieldAssign {
      type: "tcpcb"
      index: 5
      base {
        type: Variable
        index: 0
        name: "tp"
      }
      operation: SimpleAssign
      value {
        type: Constant
        name: "TCPS_ESTABLISHED"
        value: 4
      }
      fieldName: "t_state"
    }
  }
  argument {
    type: Variable
    index: 0
    name: "tp"
  }
}
root {
  name: "assertion_b"
}
#endif

/*
 * CHECK: root {
 * CHECK-NEXT: name: "assertion_a"
 * CHECK-NEXT: }
 *
 * CHECK: root {
 * CHECK-NEXT: name: "assertion_b"
 * CHECK-NEXT: }
 */

