#!/bin/bash
tmpfolder=/home/bvermeulen/seismic_unix/ebn/line12/data/tmp
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfile=line12.su
outputfile=line12_geom.su
geom_file=line12_geometry_2.txt

a2b \
    < $basefolder/$geom_file \
    n1=12 \
    > $basefolder/line12_headers.bin

sushw \
    < $basefolder/$inputfile \
    infile=$basefolder/line12_headers.bin \
    key=ep,sx,sy,selev,sstat,gstat,gx,gy,gelev,gstat,offset,cdp \
    > $tmpfolder/tmp1.su

sushw \
    < $tmpfolder/tmp1.su \
    key=scalco,scalel,d2,swevel,wevel \
    a=1,1,5,800,800 |
suchw \
    key1=sdepth \
    key2=sdepth \
    b=0.01 |
suchw \
    key1=sut \
    key2=sut \
    b=0.1 \
    > $basefolder/$outputfile

rm $tmpfolder/*
