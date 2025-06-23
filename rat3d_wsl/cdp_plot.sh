#!/bin/bash

basefolder="/home/bvermeulen/Python/seismic_unix/rat3d/data"
ntraces=78680
nrcv=281
nsrc=280

gawk '{print ($2+$6)/2,($3+$7)/2}'<$basefolder/output/202505_geometry.txt | head -n $ntraces | a2b > $basefolder/output/cmploc.bin
a2b < $basefolder/output/202505_coords_rcv.txt n1=2 > $basefolder/output/rcvloc.bin
a2b < $basefolder/output/202505_coords_src.txt n1=2 > $basefolder/output/srcloc.bin

cat $basefolder/output/cmploc.bin $basefolder/output/srcloc.bin $basefolder/output/rcvloc.bin |
    psgraph n=$ntraces,$nsrc,$nrcv linecolor=green,red,blue wbox=16 hbox=3.5 d1num=1000 d2num=1000 labelsize=9 \
    grid1=solid grid2=solid gridcolor=gray marksize=0.5,1,1 gridwidth=0 linewidth=0,0 \
    title="Source Receiver and CMPs locations" label1=Easting label2=Northing \
    > $basefolder/output/sp_rp_locmap.ps
gv $basefolder/output/sp_rp_locmap.ps
