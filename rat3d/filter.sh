#!/bin/bash

basefolder=/home/bvermeulen/Development/seismic_unix/rat3d/data/output
inputfile=line1h.su
outputfile=line1filtered.su

sudipfilt < $basefolder/line1h.su verbose=0 slopes=-0.0020,-0.0018,0.0018,0.0020 amps=0,1,1,0 bias=0 > $basefolder/tmp.dipfilter
sufilter  < $basefolder/tmp.dipfilter f=10,15,55,60 amps=0,1,1,0 > $basefolder/tmp.filtered
supef < $basefolder/tmp.filtered minlag=0.01 maxlag=0.2 pnoise=0.001 |
sumute key=offset xmute=-1400,-25,25,1400 tmute=0.6,0.05,0.05,0.6 > $basefolder/$outputfile

rm $basefolder/tmp.*
