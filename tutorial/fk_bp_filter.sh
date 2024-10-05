#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/tutorial/data
inputfile=line_001_sorted.su
outputfile=line_001_sorted_fk_bpf.su

sudipfilt < $basefolder/$inputfile dt=0.002 dx=0.025 \
    slopes=-0.5,-0.3,0.3,0.5 amps=0,1,1,0 bias=0 |
sufilter f=10,15,55,60 > $basefolder/$outputfile
