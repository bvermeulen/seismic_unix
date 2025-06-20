#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output
inputfile=line1h.su
outputfile=line1filtered.su

# sudipfilt < $basefolder/line1h.su verbose=0 slopes=-0.0016,-0.0014,0.0014,0.0016 amps=0,1,1,0 bias=0 > $basefolder/tmp.dipfilter
sufilter  < $basefolder/line1h.su f=10,15,55,60 amps=0,1,1,0 > $basefolder/tmp.filtered
supef < $basefolder/tmp.filtered minlag=0.01 maxlag=0.2 pnoise=0.001 > $basefolder/$outputfile

rm $basefolder/tmp.*
