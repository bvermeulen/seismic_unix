#!/bin/bash

basefolder=/home/bvermeulen/Development/seismic_unix/2dtestline_ubuntu/data/output
inputfile=line1_cdp.su
outputfile=line1_stack.su
fcdp=1040
lcdp=1360

sunmo < $basefolder/$inputfile \
	smute=1.40 \
	cdp=1105,1220,1310 \
	tnmo=-0.0112665,0.399962,0.659093,1.13792,1.89841,2.63074 \
	vnmo=1851.43,1997.77,2742.77,3540.98,3687.32,4485.54 \
	tnmo=-0.0281663,0.394329,0.642193,0.968922,1.16609,1.56605,2.25894,2.6589 \
	vnmo=1904.64,2223.93,2609.73,3314.82,3501.07,3487.77,4059.82,4538.75 \
	tnmo=0.0168998,0.625293,0.957656,1.18299,1.46465,2.5575 \
	vnmo=1878.04,2356.96,3101.96,3567.59,3700.62,4325.89 |

	# cdp=1105,1160,1299 \
	# tnmo=0.00,0.60,1.0,2.8 \
	# vnmo=1851.0,2250.0,3300.0,4325.0 \
	# tnmo=0.00,0.60,1.0,2.8 \
	# vnmo=1851.0,2250.0,3300.0,4325.0 \
	# tnmo=0.00,0.60,1.0,2.8 \
	# vnmo=1851.0,2250.0,3300.0,4325.0 |

sugain \
	agc=1 \
	wagc=0.300 |
sustack |
suwind tmax=3 key=cdp min=$fcdp max=$lcdp > $basefolder/$outputfile

suximage < $basefolder/$outputfile verbose=0 f2=$fcdp d2=1.0 wbox=1400 hbox=700 title="Brute stack V0" cmap=grey clip=0.3
# for collor add: cmap=hsv4
