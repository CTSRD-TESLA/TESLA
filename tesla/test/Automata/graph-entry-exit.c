/*
 * Abuse the C preprocessor to produce a .tesla file that we can graph.
 *
 * Commands for llvm-lit:
 *
 * RUN: clang -E %cflags -D TESLA_FILE %s -o %t.tesla
 * RUN: tesla graph %t.tesla -o %t.dot
 * RUN: FileCheck -input-file %t.dot %s
 */

#ifdef TESLA_FILE
automaton {
  identifier {
    location {
      filename: "threading.c"
      line: 56
      counter: 0
    }
  }
  context: ThreadLocal
  expression {
    type: SEQUENCE
    sequence {
      expression {
        type: NULL_EXPR
      }
      expression {
        type: FUNCTION
        function {
          function {
            name: "hold"
          }
          direction: Entry
          context: Callee
          argument {
            type: Variable
            index: 0
            name: "obj"
          }
        }
      }
      expression {
        type: NOW
        now {
          location {
            filename: "threading.c"
            line: 56
            counter: 0
          }
        }
      }
    }
  }
  argument {
    type: Variable
    index: 0
    name: "obj"
  }
  beginning {
    type: FUNCTION
    function {
      // CHECK: {{[0-9]+}} -> {{[0-9]+}} [ label = "worker{{.*}}Entry
      function {
        name: "worker"
      }
      direction: Entry
      context: Callee
      argument {
        type: Any
        name: "index"
      }
    }
  }
  end {
    type: FUNCTION
    function {
      // CHECK: {{[0-9]+}} -> {{[0-9]+}} [ label = "worker{{.*}}Exit
      function {
        name: "worker"
      }
      direction: Exit
      context: Callee
      argument {
        type: Any
        name: "index"
      }
    }
  }
}
automaton {
  identifier {
    location {
      filename: "threading.c"
      line: 57
      counter: 1
    }
  }
  context: ThreadLocal
  expression {
    type: SEQUENCE
    sequence {
      expression {
        type: NULL_EXPR
      }
      expression {
        type: NOW
        now {
          location {
            filename: "threading.c"
            line: 57
            counter: 1
          }
        }
      }
      expression {
        type: FUNCTION
        function {
          function {
            name: "release"
          }
          direction: Entry
          context: Callee
          argument {
            type: Variable
            index: 0
            name: "obj"
          }
        }
      }
    }
  }
  argument {
    type: Variable
    index: 0
    name: "obj"
  }
  beginning {
    type: FUNCTION
    function {
      // CHECK: {{[0-9]+}} -> {{[0-9]+}} [ label = "worker{{.*}}Entry
      function {
        name: "worker"
      }
      direction: Entry
      context: Callee
      argument {
        type: Any
        name: "index"
      }
    }
  }
  end {
    type: FUNCTION
    function {
      // CHECK: {{[0-9]+}} -> {{[0-9]+}} [ label = "worker{{.*}}Exit
      function {
        name: "worker"
      }
      direction: Exit
      context: Callee
      argument {
        type: Any
        name: "index"
      }
    }
  }
}
#endif
