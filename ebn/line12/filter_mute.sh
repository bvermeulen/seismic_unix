#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfile=line12_geom.su
outputfile=line12_filter_1751_1922.su

sufilter f=2,10,70,80 amps=0,1,1,0 < $basefolder/$inputfile |
suwind key=fldr min=1751 max=1922 |
sumute \
       key=offset \
       ntaper=10 \
       xmute=-7000,0,7000 \
       tmute=4.0,0.0,4.0 |
sudipfilt \
       slopes=-0.0025,-0.0015,0.0015,0.0025 \
       amps=0,1,1,0 \
       bias=0 \
       > $basefolder/$outputfile
