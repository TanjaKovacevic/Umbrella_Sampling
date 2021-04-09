#!/usr/bin/env python
#a script for wrapping colvars.traj files for WHAM 

#call specific row for which I want to pull data
import sys
ifpath = sys.argv[1]
f = open(ifpath, 'r')
#f1 = open('us0_f17_wrapped.colvars.traj', 'w')
for line in f:
    words = line.split()
    angle = float(words[1])
#wraps the file
    if angle > 0.0:
         angle = angle - 180
    new_line = words[0] + ' ' + str(angle)
    print(new_line)
f.close()
