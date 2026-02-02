#!/bin/bash
tmpfolder=/home/bvermeulen/seismic_unix/ebn/line12/data/tmp
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
filename=line12_cdp.su

suwind \
    < $basefolder/$filename \
    key=cdp \
    min=$1 \
    max=$1 \
    > $tmpfolder/tmp.su

foffset=$(sugethw < $tmpfolder/tmp.su key=offset | head -n 1 | grep -Eo '[-][0-9]*')

suximage \
    <  $tmpfolder/tmp.su \
    f2=$foffset \
    perc=90 \
    verbose=0 \
    wbox=500 \
    hbox=750 \
    title="cdp $1" \
    label1="Time (s)" label2="Offset (m)" 

#suspecfk < $basefolder/tmp.su |
#suximage cmap=hsv2 legend=1 title="VP$1 F-K spectrum" label1="Frequency Hz" label2="Wavenumber cycles/m"

rm $tmpfolder/*

#cmap=hsv4
