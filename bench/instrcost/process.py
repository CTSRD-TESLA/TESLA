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
			label = line.strip()[:-1].replace("# CFLAGS = '", "")
			print(label)

			if len(all_data) > 0:
				pylab.plot(averages, 'g-.')
				pylab.boxplot(all_data,
					positions = range(len(all_data)))
				all_data = []
				averages = []

			pylab.figure()
			pylab.suptitle(label)
			pylab.xlabel('Assertions')
			pylab.ylabel('Overhead [%]')

			baseline = None
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

	if baseline is None:
		baseline = avg

	overhead = [ 100 * (t - baseline) / t for t in trials ]
	overhead_avg = numpy.average(overhead)

	all_data.append(overhead)
	averages.append(overhead_avg)

	summary = (
		assertions,
		avg,
		numpy.std(trials),
		min(trials),
		max(trials),
		overhead_avg,
	)

	print('%d assertions: %12.4g ± %10.4g    [%.4g-%.4g] (%d%%)' % summary)

pylab.plot(averages, 'g-.')
pylab.boxplot(all_data, positions = range(len(all_data)))

pylab.show()
