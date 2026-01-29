#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/4dtest201/data/output
inputfile=line201.su
outputfile=line201h.su
max_offset=4000

a2b < $basefolder/4dtest201_geometry.txt n1=12 > $basefolder/4dtest201_headers.bin
sushw < $basefolder/$inputfile infile=$basefolder/4dtest201_headers.bin key=ep,sx,sy,selev,sstat,gstat,gx,gy,gelev,gstat,offset,cdp > $basefolder/tmp1.su
sushw < $basefolder/tmp1.su key=scalco,scalel,d2 a=1,1,50 > $basefolder/tmp2.su

# resample to 4 ms and max time 4 seconds (1000 samples)
suwind tmax=6.0 < $basefolder/tmp2.su > $basefolder/tmp3.su
sufilter  < $basefolder/tmp3.su f=0,85,95,250 amps=1,1,0,0 |
suresamp dt=0.004 nt=1000 |
suramp tmax=3.9 > $basefolder/tmp4.su

# apply maximum offset
suwind  < $basefolder/tmp4.su verbose=1 key=offset min=-$max_offset max=$max_offset > $basefolder/$outputfile

rm $basefolder/tmp?.*
