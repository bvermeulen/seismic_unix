#!/bin/bash
basefolder=/home/bvermeulen/Python/seismic_unix/data/forge_2d/Correlated_Shot_Gathers
fn=line1_coords
ntraces=25730
nrcv=310
nsrc=166

gawk '{print $1,$2'}<$basefolder/$fn"_src.csv" |
head -n $nsrc |
a2b > $basefolder/srcloc.bin

gawk '{print $1,$2'}<$basefolder/$fn"_rcv.csv" |
head -n $nrcv |
a2b > $basefolder/rcvloc.bin

gawk '{print ($2+$4)/2,($3+$5)/2}'<$basefolder/$fn.csv |
head -n $ntraces |
a2b > $basefolder/cmploc.bin

cat $basefolder/cmploc.bin $basefolder/srcloc.bin $basefolder/rcvloc.bin|
psgraph n=$ntraces,$nsrc,$nrcv \
  linecolor=green,red,blue wbox=16 hbox=3.5 d1num=1000 d2num=1000 labelsize=9 \
  grid1=solid grid2=solid gridcolor=gray marksize=0.5,1,1 gridwidth=0 linewidth=0,0 \
  title="Source Receiver and CMPs locations" label1=Easting label2=Northing > $basefolder/cmp_loc_map.ps

gv $basefolder/cmp_loc_map.ps
