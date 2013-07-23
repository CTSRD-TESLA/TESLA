#!/bin/sh
rm -f /tmp/man.all
find /usr/share/man -name '*.gz' -exec gzcat '{}' \; > /tmp/man.all
sort /tmp/man.all | uniq | wc -l
