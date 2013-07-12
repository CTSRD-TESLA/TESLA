#!/usr/bin/env python

import argparse
import collections
import re

args = argparse.ArgumentParser()
args.add_argument('dot')
args.add_argument('transitions')

args = args.parse_args()

automata = collections.defaultdict(dict)
max_count = 0

for line in open(args.transitions, 'r'):
	(name, transition, count) = line.split()
	assert re.match('\([0-9]+->[0-9]+\)', transition)
	transition = tuple([ int(i) for i in transition[1:-1].split('->') ])

	count = int(count)

	automata[name][transition] = count

current_automaton = {}
for line in open(args.dot, 'r'):
	if re.match(' \* .*[\/a-zA-Z0-9\.]+:[0-9]+#[0-9]+', line):
		name = line.strip()[2:]
		current_automaton = automata[name]
		max_count = max(current_automaton.values())

	if re.match('\t[0-9]+ -> [0-9]+;', line):
		(source,dest) = tuple([
			int(i) for i in line.strip()[:-1].split(' -> ')
		])

		if (source,dest) in current_automaton:
			count = current_automaton[(source,dest)]
			width = float(count) / max_count
			attrs = { 'penwidth': 10 * width }

		else:
			attrs = { 'color': '"#00000011"' }

		attrs = ', '.join([ '%s = %s' % a for a in attrs.items() ])
		print '\t%d -> %d [ %s ];' % (source, dest, attrs)

	else:
		print line,
