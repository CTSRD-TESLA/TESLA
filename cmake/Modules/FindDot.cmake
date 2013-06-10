## Copyright (c) 2011, David Pineau
## Copyright (c) 2013 Jonathan Anderson
## All rights reserved.

## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##  * Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
##  * Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimer in the
##    documentation and/or other materials provided with the distribution.
##  * Neither the name of the copyright holder nor the names of its contributors
##    may be used to endorse or promote products derived from this software
##    without specific prior written permission.

## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER AND CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.

if (NOT DOT_EXECUTABLE_FOUND)
  FIND_PROGRAM(DOT_EXECUTABLE
    NAMES dot
    PATHS
      # UNIX paths
      "/bin"
      "/usr/bin"
      "/usr/local/bin"
      "/opt/bin"
      "/opt/local/bin"
      # Windows paths
      "$ENV{ProgramFiles}/Graphviz 2.21/bin"
      "C:/Program Files/Graphviz 2.21/bin"
      "$ENV{ProgramFiles}/ATT/Graphviz/bin"
      "C:/Program Files/ATT/Graphviz/bin"
      [HKEY_LOCAL_MACHINE\\SOFTWARE\\ATT\\Graphviz;InstallPath]/bin
      # Mac OS X Bundle paths
      /Applications/Graphviz.app/Contents/MacOS
      /Applications/Doxygen.app/Contents/Resources
      /Applications/Doxygen.app/Contents/MacOS
    DOC "Graphviz Dot tool for generating image graph from dot file"
  )

  if (DOT_EXECUTABLE)
    message(STATUS "Dot executable found : ${DOT_EXECUTABLE}")
    set(ERR 0)

    #
    # Test that the 'dot' we found actually does the right thing.
    #
    set(F "${CMAKE_CURRENT_BINARY_DIR}/CMakeTmp/test.dot")
    file(WRITE ${F} "digraph foo { a -> b; } digraph bar { c -> d; }")

    #
    # First, make sure it doesn't blat its output to stdout.
    #
    execute_process(
      COMMAND ${DOT_EXECUTABLE} -Tpdf ${F} -o ${F}.pdf
      OUTPUT_VARIABLE STDOUT)

    file(READ ${F}.pdf PDF HEX)

    if (NOT "${STDOUT}" STREQUAL "")
      set(ERR 1)
      message(WARNING "dot ignored -o, emitted PDF output to stdout")
    endif ()

    if ("${PDF}" STREQUAL "")
      set(ERR 1)
      message(WARNING "dot -Tpdf produced an empty file")
    endif ()

    #
    # Next, make sure we can produce PNG output.
    #
    execute_process(
      COMMAND ${DOT_EXECUTABLE} -Tpng ${F} -o ${F}.png
      OUTPUT_VARIABLE STDOUT)

    file(READ ${F}.png PNG HEX)

    if ("${PNG}" STREQUAL "")
      set(ERR 1)
      message(WARNING "dot -Tpng produced an empty file")
    endif ()

    #
    # All checks complete.
    #
    if (NOT ERR)
      message(STATUS "'dot' executable works as expected")

      set (DOT_EXECUTABLE_FOUND TRUE CACHE BOOL "'dot' command found, works")
      set (DOT_EXECUTABLE ${DOT_EXECUTABLE} CACHE FILEPATH "'dot' location")
    endif ()
  endif (DOT_EXECUTABLE)

endif (NOT DOT_EXECUTABLE_FOUND)
