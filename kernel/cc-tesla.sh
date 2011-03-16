#/bin/sh

################################################################################
# If you set the CC environment variable to this script, symlink ~/llvmlib to  #
# the LLVM lib dir and put Clang in your path, then 'make kernel' will do      #
# mostly the right thing.                                                      #
################################################################################

TESLA_ARGS="-Xclang -load -Xclang ~/llvmlib/TeslaInstrumenter.so -Xclang -add-plugin -Xclang tesla -Xclang -plugin-arg-tesla -Xclang instrumentation.spec"

ARGS=`echo $* | sed 's/-Werror//g'`
ARGS="$TESLA_ARGS $ARGS"

~/LLVM/build/bin/clang $ARGS || exit 1
