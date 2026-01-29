#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfile=line12.su
outputfile=line12r.su

# resample to 4 ms and max time 4 seconds (1000 samples)
suwind tmax=5.0 < $basefolder/$inputfile > $basefolder/tmp1.su
sushw < $basefolder/tmp1.su key=d2 a=5 > $basefolder/tmp2.su
sufilter  < $basefolder/tmp2.su f=0,85,95,250 amps=1,1,0,0 |
suresamp dt=0.004 nt=1000 |
suramp tmax=3.9 > $basefolder/$outputfile
rm $basefolder/tmp?.su

