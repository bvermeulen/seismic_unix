#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output
inputfile=line1cdp_muted.su
outputfile=line1_stack.su

sunmo < $basefolder/$inputfile \
	cdp=1150,1280,1400 \
	tnmo=0.0119471,0.492817,0.719811,1.48741 \
	vnmo=1851.79,2189.29,2510.71,3025 \
	tnmo=0.0209074,0.519697,0.869149,1.4904 \
	vnmo=1851.79,2165.18,2671.43,3097.32 \
	tnmo=0.050775,0.49879,0.925898,1.47248 \
	vnmo=1827.68,2133.04,2679.46,3129.46 |

sugain \
	agc=2 \
	wagc=0.5 |
sustack |
suwind key=cdp min=1135 max=1435 > $basefolder/$outputfile

suximage < $basefolder/$outputfile verbose=0 key=cdp d2=1.0 wbox=1400 hbox=700 title="Brute stack V0" cmap=grey clip=0.4
# for collor add: cmap=hsv4
