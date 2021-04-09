#!/usr/bin/env python
##################
#
# Process Histogram file so that it can be graphed
#
#################
import sys
ifpath = sys.argv[1]
ifi = open(ifpath, 'r')
while True:
    line = ifi.readline()
    if not line: break
    if 'infinity' in line: continue
    if 'Number' in line: break
    sys.stdout.write(line)
ifi.close()
