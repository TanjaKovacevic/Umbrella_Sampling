#!/usr/bin/env bash

for i in *.traj
do
  hist_graph/histogram.pl -i $i -col 2 -n 1 -l -180 -u 180 -bin 76  > ${i}.hist
done
