#!/bin/bash

# vnmo=1700,2750,3000 tnmo=0.1,1.0,2.0

tnmo="00.0283554,0.883743,1.57845,2.4811"
vnmo="1862.86,2235.71,2917.14,3302.86"
basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output
inputfile=line1cdp_fk_bp_decon.su
outputfile=line1_stack.su

sunmo < $basefolder/$inputfile vnmo=$vnmo tnmo=$tnmo |
sugain \
	agc=1 \
	wagc=0.400 |
sustack | suwind key=cdp min=1135 max=1435 > $basefolder/$outputfile

suximage < $basefolder/$outputfile key=cdp title="Brute stack V0" perc=98
# for collor add: cmap=hsv4
