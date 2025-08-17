#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/2dtestline/data/output
inputfile=line1h.su
outputfile=line1filtered.su


cat $basefolder/$inputfile > $basefolder/tmp.dipfilter
# sudipfilt < $basefolder/line1h.su verbose=0 slopes=-0.0020,-0.0018,0.0018,0.0020 amps=0,1,1,0 bias=0 > $basefolder/tmp.dipfilter
supef < $basefolder/tmp.dipfilter minlag=0.0 maxlag=0.1 pnoise=0.001 > $basefolder/tmp.filtered
sufilter  < $basefolder/tmp.dipfilter f=5,15,70,80 amps=0,1,1,0 |
# cat $basefolder/tmp.filtered > $basefolder/$outputfile
sumute key=offset \
       xmute=-5000,-2500,-1700,0,1700,2500,5000 \
       tmute=1.2,1,0.8,0.05,0.8,1.0,1.2 \
> $basefolder/$outputfile

rm $basefolder/tmp.*
