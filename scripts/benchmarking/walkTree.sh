#!/bin/sh
cd /usr
find . > /tmp/tree 2> /dev/null
sort /tmp/tree > /tmp/tree.sorted
