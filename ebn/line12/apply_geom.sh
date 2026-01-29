#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfile=line12.su
outputfile=line12_geom.su

a2b < $basefolder/line12_geometry.txt n1=12 > $basefolder/line12_headers.bin
sushw < $basefolder/$inputfile infile=$basefolder/line12_headers.bin key=ep,sx,sy,selev,sstat,gstat,gx,gy,gelev,gstat,offset,cdp > $basefolder/tmp1.su
sushw < $basefolder/tmp1.su key=scalco,scalel,d2 a=1,1,5 > $basefolder/$outputfile

rm $basefolder/tmp?.*
