#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/2dtestline/data/output
inputfile=line1h.su
outputfile=line1filtered.su


cat $basefolder/$inputfile > $basefolder/tmp.dipfilter
# sudipfilt < $basefolder/line1h.su verbose=0 slopes=-0.0020,-0.0018,0.0018,0.0020 amps=0,1,1,0 bias=0 > $basefolder/tmp.dipfilter
supef < $basefolder/tmp.dipfilter minlag=0.0 maxlag=0.250 pnoise=0.011 > $basefolder/tmp.filtered
sufilter  < $basefolder/tmp.dipfilter f=5,15,70,80 amps=0,1,1,0 |
# cat $basefolder/tmp.filtered > $basefolder/$outputfile
sumute key=offset \
       ntaper=20 \
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

rm $basefolder/tmp.*
