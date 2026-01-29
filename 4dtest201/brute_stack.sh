#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/4dtest201/data/output
inputfile=line201_cdp.su
outputfile=line201_stack.su
fcdp=1050
lcdp=1350

sunmo < $basefolder/$inputfile \
	smute=1.40 \
	cdp=1100,1200,1300 \
	tnmo=0.00,0.60,1.0,2.8 \
	vnmo=1851.0,2250.0,3300.0,4325.0 \
	tnmo=0.00,0.60,1.0,2.8 \
	vnmo=1851.0,2250.0,3300.0,4325.0 \
	tnmo=0.00,0.60,1.0,2.8 \
	vnmo=1851.0,2250.0,3300.0,4325.0 |

	# cdp=1105,1160,1299 \
	# tnmo=-0.0394329,0.614026,1.03652,2.811 \
	# vnmo=1851.43,2144.11,3301.52,4325.89 \
	# tnmo=-0.0394329,0.614026,1.03652,2.811 \
	# vnmo=1851.43,2144.11,3301.52,4325.89 \
	# tnmo=-0.0394329,0.614026,1.03652,2.811 \
	# vnmo=1851.43,2144.11,3301.52,4325.89 |

sugain \
	agc=1 \
	wagc=0.500 |
sustack |
suwind tmax=4 key=cdp min=$fcdp max=$lcdp > $basefolder/$outputfile

suximage < $basefolder/$outputfile verbose=0 f2=$fcdp d2=1.0 wbox=1400 hbox=700 title="Brute stack (bin size 25m)" cmap=grey clip=0.3
# for collor add: cmap=hsv4
