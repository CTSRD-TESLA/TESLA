#!/bin/sh
# Build OpenSSH with clang
#
# If any options need to be passed to ./configure, put them in the
# CONFIGFLAGS environment variable, e.g.
#  CONFIGFLAGS=--without-openssl-header-check ./build_openssh.sh

set -x
V="5.8p1"

# Download OpenSSH if needed

if [ ! -e openssh-${V}.tar.gz ]; then
  ftp ftp://www.mirrorservice.org/sites/ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${V}.tar.gz
fi

# Extract and build with GCC

if [ ! -d openssh-${V}-with-gcc ]; then
  tar -zxf openssh-${V}.tar.gz
  mv openssh-${V} openssh-${V}-with-gcc
fi

if [ ! -e openssh-${V}-with-gcc/.build_complete ]; then
  cd openssh-${V}-with-gcc
  (./configure $CONFIGFLAGS && make) || exit $?
  touch .build_complete
  cd ..
fi

# Extract and build with clang, using TESLA

if [ ! -d openssh-${V}-with-clang-tesla ]; then
  tar -zxf openssh-${V}.tar.gz
  mv openssh-${V} openssh-${V}-with-clang-tesla
  cd openssh-${V}-with-clang-tesla
  cp ../instrumentation.spec .
  patch -p0 < ../openssh-teal.patch
  cd ..
fi

if [ ! -e openssh-${V}-with-clang-tesla/.build_complete ]; then
  cd openssh-${V}-with-clang-tesla
  CC=`python -c 'import os,sys;print os.path.realpath(sys.argv[1])' ../../../kernel/tesla-clang`
  export CC
  (LIBS=-lteslassh LDFLAGS=-L.. ./configure $CONFIGFLAGS && make) || exit $?
  touch .build_complete
  cd ..
fi

# Extract and build with clang, using a fake TESLA

if [ ! -d openssh-${V}-with-clang-faketesla ]; then
  tar -zxf openssh-${V}.tar.gz
  mv openssh-${V} openssh-${V}-with-clang-faketesla
  cd openssh-${V}-with-clang-faketesla
  cp ../instrumentation.spec .
  patch -p0 < ../openssh-teal.patch
  cd ..
fi

if [ ! -e openssh-${V}-with-clang-faketesla/.build_complete ]; then
  cd openssh-${V}-with-clang-faketesla
  CC=`python -c 'import os,sys;print os.path.realpath(sys.argv[1])' ../../../kernel/tesla-clang`
  (LIBS=-lfaketeslassh LDFLAGS=-L.. ./configure $CONFIGFLAGS && make) || exit $?
  touch .build_complete
  cd ..
fi

echo "Build of OpenSSH completed successfully"
