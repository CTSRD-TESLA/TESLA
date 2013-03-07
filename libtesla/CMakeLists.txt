cmake_minimum_required(VERSION 2.6)
project(libtesla)

# More warnings (used in the FreeBSD "buildworld" step).
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wmissing-prototypes -Wpointer-arith")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wreturn-type -Wcast-qual")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wwrite-strings -Wswitch -Wshadow")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wunused-parameter -Wcast-align")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wchar-subscripts -Winline")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wnested-externs -Wredundant-decls")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wold-style-definition")

add_subdirectory(src)
add_subdirectory(test)

