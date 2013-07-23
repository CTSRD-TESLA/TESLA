#!/bin/sh
for I in `seq 5000` ; do
	quota > /dev/null
done
