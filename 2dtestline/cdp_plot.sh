#!/bin/bash

basefolder="/home/bvermeulen/seismic_unix/2dtestline/data"
ntraces=40401
nrcv=201
nsrc=201

gawk '{print ($2+$7)/2,($3+$8)/2}'<$basefolder/output/20250804_geometry.txt | head -n $ntraces | a2b > $basefolder/output/cmploc.bin
a2b < $basefolder/output/20250804_coords_rcv.txt n1=2 > $basefolder/output/rcvloc.bin
a2b < $basefolder/output/20250804_coords_src.txt n1=2 > $basefolder/output/srcloc.bin

cat $basefolder/output/cmploc.bin $basefolder/output/srcloc.bin $basefolder/output/rcvloc.bin |
    psgraph n=$ntraces,$nsrc,$nrcv linecolor=green,red,blue wbox=16 hbox=3.5 d1num=1000 d2num=1000 labelsize=9 \
    x2beg=3390000 x2end=3391000 x1beg=701000 x1end=707000 \
    grid1=solid grid2=solid gridcolor=gray marksize=0.5,1,1 gridwidth=0 linewidth=0,0 \
    title="Source Receiver and CMPs locations" label1=Easting label2=Northing \
    > $basefolder/output/sp_rp_locmap.ps
gv $basefolder/output/sp_rp_locmap.ps
