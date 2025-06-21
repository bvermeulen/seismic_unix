#!/bin/bash
basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output

suwind key=ep min=$1 max=$1 tmax=2.5 < $basefolder/line1h.su > $basefolder/$1.su
suchw < $basefolder/$1.su > $basefolder/$1.clean key1=d2 a=5.0
foffset=$(sugethw < $basefolder/$1.su key=offset | head -n 1 | grep -Eo '[-][0-9]*')

suximage < $basefolder/$1.clean f2=$foffset perc=98 cmap=grey \
    verbose=0 wbox=500 hbox=750 title="shot $1 after geometry" label1="Time (s)" label2="Offset (m)" &

sufilter  < $basefolder/$1.clean f=10,15,85,95,250 amps=1,1,1,0,0 |
suresamp dt=0.004 nt=625 |
suramp tmax=2.0 > $basefolder/$1.unfiltered
suspecfk < $basefolder/$1.unfiltered |
suximage cmap=hsv2 title="VP$1 F-K spectrum" label1="Frequency Hz" label2="Wavenumber cycles/m" &

sudipfilt < $basefolder/$1.clean verbose=0 slopes=-0.0016,-0.0014,0.0014,0.0016 amps=0,1,1,0 bias=0 > $basefolder/$1.tmp
sufilter  < $basefolder/$1.tmp f=10,15,55,65,250 amps=0,1,1,0,0 |
suresamp dt=0.004 nt=625 |
suramp tmax=2.0 > $basefolder/$1.filtered
foffset=$(sugethw < $basefolder/$1.filtered key=offset | head -n 1 | grep -Eo '[-][0-9]*')

suximage < $basefolder/$1.filtered f2=$foffset perc=98 cmap=grey \
    verbose=0 wbox=500 hbox=750 title="shot $1 after dipfilter" label1="Time (s)" label2="Offset (m)" &

suspecfk < $basefolder/$1.filtered |
suximage cmap=hsv2 title="VP$1 F-K spectrum" label1="Frequency Hz" label2="Wavenumber cycles/m"
rm $basefolder/$1.*

#cmap=hsv4