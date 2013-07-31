#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import numpy

args = argparse.ArgumentParser()
args.add_argument('filename', help = 'raw data file')
args = args.parse_args()

for line in open(args.filename, 'r'):
	if line.startswith('#'):
		if 'CFLAGS' in line:
			print(line.strip())
		continue

	cols = line.split()
	if len(cols) == 0:
		continue

	(assertions, runs) = cols[:2]
	trials = cols[2:]

	assertions = int(assertions)
	runs = int(runs)
	trials = [ float(t) / runs for t in trials ]

	print('%d assertions: %12.4g ± %10.4g    [%.4g-%.4g]' % (
		assertions,
		numpy.average(trials),
		numpy.std(trials),
		min(trials),
		max(trials))
	)
