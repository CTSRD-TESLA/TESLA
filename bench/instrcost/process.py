#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import numpy
import pylab

args = argparse.ArgumentParser()
args.add_argument('filename', help = 'raw data file')
args = args.parse_args()

all_data = []
averages = []

for line in open(args.filename, 'r'):
	if line.startswith('#'):
		if 'CFLAGS' in line:
			if len(all_data) > 0:
				pylab.plot(
					range(1, len(averages) + 1),
					averages,
					'-.'
				)
				pylab.boxplot(all_data)
				all_data = []
				averages = []

			pylab.figure()
			pylab.suptitle(line)
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
	avg = numpy.average(trials)

	all_data.append(trials)
	averages.append(avg)

	summary = (
		assertions, avg, numpy.std(trials), min(trials), max(trials)
	)

	print('%d assertions: %12.4g ± %10.4g    [%.4g-%.4g]' % summary)

pylab.plot(range(1, len(averages)+1), averages, '-.')
pylab.boxplot(all_data)

pylab.show()
