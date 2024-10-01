#!/bin/bash
basefolder="/home/bvermeulen/Python/seismic_unix/forge_2d/data/su_results"
fn=sp1
nrcv=322
nsrc=168

gawk '{print $1,$2'}<$basefolder/$fn"_src.csv" |
head -n $nsrc |
a2b > $basefolder/sp1srcloc.bin

gawk '{print $1,$2'}<$basefolder/$fn"_rcv.csv" |
head -n $nrcv |
a2b > $basefolder/sp1rcvloc.bin

cat $basefolder/sp1rcvloc.bin $basefolder/sp1srcloc.bin |
psgraph n=$nsrc,$nrcv \
  linecolor=blue,red wbox=16 hbox=3.5 d1num=1000 d2num=1000 labelsize=9 \
  grid1=solid grid2=solid gridcolor=gray marksize=0.5,1,1 gridwidth=0 linewidth=0,0 \
  title="Source Receiver and CMPs locations" label1=Easting label2=Northing > $basefolder/sp1_loc_map.ps

gv $basefolder/sp1_loc_map.ps
