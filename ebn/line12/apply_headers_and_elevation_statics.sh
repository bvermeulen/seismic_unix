#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
tmpfolder=/home/bvermeulen/seismic_unix/ebn/line12/data/tmp
inputfile=line12_filter.su
outputfile=line12_filter_static.su

suchw \
    < $basefolder/$inputfile \
    key1=sdepth key2=sdepth b=0.01 > $tmpfolder/tmp1.su

suchw \
    < $tmpfolder/tmp1.su \
    key1=sut key2=sut b=0.1 > $tmpfolder/tmp2.su

sushw  \
    < $tmpfolder/tmp2.su \
    key=swevel,wevel \
    a=800,800 | 
sustatic \
    hdrs=0 \
    > $basefolder/$outputfile 

rm -f $tmpfolder/*
