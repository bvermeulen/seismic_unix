#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/tutorial/data
inputfile=line_001_sorted_fk_bpf_decon.su
outputfile=line_001_stack_sorted_fk_bpf_decon.su

sunmo < $basefolder/$inputfile vnmo=1700,2750,3000 tnmo=0.1,1.0,2.0 |
sugain \
	agc=1 \
	wagc=0.400 |
sustack > $basefolder/$outputfile

suximage < $basefolder/$outputfile key=cdp cmap=hsv0 title="Brute stack V0" perc=90
# for collor add: cmap=hsv4
