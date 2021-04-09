#!/usr/bin/env python
##############################################################################
#
# GRAPHHISTORAM.PY 
#
# Graph data binned by Hai Lin's script histogram.pl using matplotlib
#
# Num bins read from input file
# Bins are assumed to be of the same size
#
# Usage: ./graphHistogram.py [his file]
#
##############################################################################

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.style as gstyle
import sys

gstyle.use('ggplot')
# Variables
x = []
count = []
nbins = 0
binsize = 0.000
start0 = 'infinity'

# Begin Data munging
ifpath = sys.argv[1]
ifi = open(ifpath, 'r')
# First Step Read: Bin size, frequency of bin
while True:
    line = ifi.readline()
    if not line: break
    words = line.split()
    if words[0] == '[':
        if nbins == 0:
            if words[1] == start0:
                continue
#            elif words[3] == start0:
#                continue
            else:
                binstart = float(words[1])
            binfin = float(words[3])
            binsize = binfin - binstart
        else:
            binstart = float(words[1])
        x.append(binstart)
        count.append(int(words[6]))
        nbins = nbins + 1
    else:
        break

plt.bar(x, count, width=binsize, alpha=0.5, align='center')
plt.show()



ifi.close()
