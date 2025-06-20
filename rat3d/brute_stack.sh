#!/bin/bash

	# cdp=1100,1285,1400 \
	# tnmo=0.0803403,1.12949,1.33743,1.60208,2.45747 \
	# vnmo=1914.29,2852.86,3148.57,3534.29,3920 \
	# tnmo=0.203214,0.321361,1.25709,1.63043,2.38658 \
	# vnmo=1965.71,2081.43,2814.29,3200,3804.29 \
	# tnmo=0.122873,0.751418,1.14367,2.3724 \
	# vnmo=1978.57,2814.29,3148.57,3907.14 |


basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output
inputfile=line1cdp_sorted.su
outputfile=line1_stack.su

sunmo < $basefolder/$inputfile \
	tnmo=0.00,1.0,1.4,2.4 \
	vnmo=1930,2500,2800,3500 |

sugain \
	agc=1 \
	wagc=0.400 |
sustack |
suwind key=cdp min=1135 max=1435 > $basefolder/$outputfile

suximage < $basefolder/$outputfile verbose=0 key=cdp d2=1.0 wbox=1400 hbox=700 title="Brute stack V0" perc=98
# for collor add: cmap=hsv4
