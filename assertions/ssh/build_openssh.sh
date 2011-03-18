#!/bin/sh
# Build OpenSSH with clang
set -x
V="5.8p1"

if [ ! -e openssh-${V}.tar.gz ]; then
  ftp ftp://www.mirrorservice.org/sites/ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${V}.tar.gz
fi

if [ ! -d openssh-${V}-with-gcc ]; then
  tar -zxf openssh-${V}.tar.gz
  mv openssh-${V} openssh-${V}-with-gcc
  cd openssh-${V}-with-gcc && ./configure && make
  cd ..
fi


if [ ! -d openssh-${V}-with-clang-tesla ]; then
  tar -zxf openssh-${V}.tar.gz
  mv openssh-${V} openssh-${V}-with-clang-tesla
  cd openssh-${V}-with-clang-tesla
  cp ../instrumentation.spec .
  patch -p0 < ../openssh-teal.patch
  CC=`python -c 'import os,sys;print os.path.realpath(sys.argv[1])' ../tesla-clang`
  export CC
  LIBS=-lteslassh LDFLAGS=-L.. ./configure && make
  cd ..
fi

if [ ! -d openssh-${V}-with-clang-faketesla ]; then
  tar -zxf openssh-${V}.tar.gz
  mv openssh-${V} openssh-${V}-with-clang-faketesla
  cd openssh-${V}-with-clang-faketesla
  cp ../instrumentation.spec .
  patch -p0 < ../openssh-teal.patch
  CC=`python -c 'import os,sys;print os.path.realpath(sys.argv[1])' ../tesla-clang`
  LIBS=-lfaketeslassh LDFLAGS=-L.. ./configure && make
  cd ..
fi
