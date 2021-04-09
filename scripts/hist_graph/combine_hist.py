#!/usr/bin/env python
##############################################################################
#
# ./combine_hist.py
# Combine Histographs with same lengths and bins
#
# There cannot be any blank lines in or at end of the histograph...
# Created by Adam Duster on 1 Aug 2016
#
# Usage ./combine_hist [file1] [file2] [file3]
##############################################################################

import sys

ifpaths = sys.argv[1:]

if len(ifpaths) == 1:
    print("Please run with multiple files")
    exit()
nfiles = len(ifpaths)
sys.stderr.write("Combining {0:d} files\n".format(nfiles))

#First file stores bins:
bins = []
nbins = 0
fnum = 0
ifi = open(ifpaths[fnum], 'r')
lines = ifi.readlines()
for line in lines:
    bins.append(line.split())
nbins = len(bins)
ifi.close()
fnum = fnum + 1

counts = [0] * nbins
i = 0
while i < nbins:
    counts[i] += int(bins[i][6])
    i = i + 1

# Cycle through rest of files
while fnum < len(ifpaths):
    ifi = open(ifpaths[fnum], 'r')
    linenum = 0
    while True:
        line = ifi.readline()
        if not line: break
        words = line.split()
        counts[linenum] += int(words[6])
        linenum += 1
        if linenum > nbins:
            print("The histograms are not of the same length!!!")
            exit()
    ifi.close()
    fnum += 1
# Print out the new histograph
i = 0
prtstr = "{0} {1} {2} {3} {4} {5} {6:d}"
while i < nbins:
    print(prtstr.format(bins[i][0],bins[i][1],bins[i][2],
                        bins[i][3],bins[i][4],bins[i][5],counts[i])) 
    i = i + 1
