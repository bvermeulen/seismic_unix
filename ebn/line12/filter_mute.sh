#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfile=line12_geom.su
outputfile=line12_filter_$1_$2.su

suwind \
    < $basefolder/$inputfile \
    key=fldr min=$1 max=$2 |
sugain \
    tpow=1.5 |
sudipfilt \
    slopes=-0.0025,-0.0015,0.0015,0.0025 \
    amps=0,1,1,0 \
    bias=0 |
supef \
    minlag=0.032 \
    maxlag=0.232 \
    pnoise=0.001 |
sufilter \
    f=2,10,70,80 \
    amps=0,1,1,0 |
sumute \
    key=offset \
    ntaper=25 \
    xmute=-7000,-3000,-100,100,3000,7000 \
    tmute=2.5,1.5,0,0,1.5,2.5 \
    > $basefolder/$outputfile 
