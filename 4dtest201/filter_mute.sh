#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/4dtest201/data/output
inputfile=line201h.su
outputfile=line201filter.su

sufilter  < $basefolder/$inputfile f=5,15,70,80 amps=0,1,1,0 |
sumute key=offset \
       ntaper=10 \
       xmute=-5000,-2500,-1700,0,1700,2500,5000 \
       tmute=1.4,1,0.8,0.01,0.8,1.0,1.4 |
sumute key=offset \
       mode=2 \
       ntaper=10 \
       linvel=440 \
       xmute=-5000,-1700,-1000,-100,100,1000,1700,5000 \
       tmute=1.0,1.0,1.0,0.2,0.2,1.0,1.0,1.0 \
       verbose=1 \
> $basefolder/$outputfile
