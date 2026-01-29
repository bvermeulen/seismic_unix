#!/bin/bash
basefolder="/home/bvermeulen/seismic_unix/ebn/line12/data/output"
ntraces=2428881
nrcv=11599
nsrc=922

gawk '{print ($2+$7)/2,($3+$8)/2}'<$basefolder/line12_geometry.txt | head -n $ntraces | a2b > $basefolder/cmploc.bin
a2b < $basefolder/line12_coords_rcv.txt n1=2 > $basefolder/rcvloc.bin
a2b < $basefolder/line12_coords_src.txt n1=2 > $basefolder/srcloc.bin

cat $basefolder/cmploc.bin $basefolder/srcloc.bin $basefolder/rcvloc.bin |
    psgraph n=$ntraces,$nsrc,$nrcv linecolor=green,red,blue wbox=4 hbox=8 d1num=10000 d2num=10000 labelsize=9 \
    x2beg=449500 x2end=509500 x1beg=190500 x1end=220500 \
    grid1=solid grid2=solid gridcolor=gray marksize=0.5,1,1 gridwidth=0 linewidth=0,0 \
    title="Source Receiver and CMPs locations" label1=Easting label2=Northing \
    > $basefolder/sp_rp_locmap.ps
gv $basefolder/sp_rp_locmap.ps
