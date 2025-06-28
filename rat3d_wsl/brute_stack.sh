#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl/data/output
inputfile=line1cdp_muted.su
outputfile=line1_stack.su

sunmo < $basefolder/$inputfile \
	cdp=1150,1280,1450 \
	tnmo=0.119471,0.555539,1.23652 \
	vnmo=1762.5,2313.75,3250 \
	tnmo=0.0716824,0.525671,1.09316,1.3769 \
	vnmo=1885,2305,2742.5,3538.75 \
	tnmo=0.0746692,0.555539,0.863176,1.10212,1.37391 \
	vnmo=1745,2340,2900,3180,3381.25 |
	# cdp=1286 \
	# tnmo=0.0806427,0.495803,0.940832,1.38885 \
	# vnmo=1611.96,2330.36,2662.95,2769.38 |
	# cdp=1150,1280,1400 \
	# tnmo=0.0119471,0.492817,0.719811,1.48741 \
	# vnmo=1851.79,2189.29,2510.71,3025 \
	# tnmo=0.0209074,0.519697,0.869149,1.4904 \
	# vnmo=1851.79,2165.18,2671.43,3097.32 \
	# tnmo=0.050775,0.49879,0.925898,1.47248 \
	# vnmo=1827.68,2133.04,2679.46,3129.46 |

sugain \
	agc=2 \
	wagc=0.5 |
sustack |
suwind key=cdp min=1135 max=1435 > $basefolder/$outputfile

suximage e< $basefolder/$outputfile verbose=0 f2=1135 d2=1.0 wbox=1400 hbox=700 title="Brute stack V0" cmap=grey clip=0.4
# for collor add: cmap=hsv4
