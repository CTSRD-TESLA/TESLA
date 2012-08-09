#!/bin/sh

REV=`git log --pretty=format:'%h' -n 1`

DIFF=`git diff HEAD`
if [ "${DIFF}" != "" ]; then
	REV="${REV} (dirty)"
fi

echo ${REV}

