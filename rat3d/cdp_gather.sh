#!/bin/bash
basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output

suwind key=cdp min=$1 max=$1 < $basefolder/line1cdp_sorted.su > $basefolder/tmp.su

suximage < $basefolder/tmp.su key=offset perc=90 \
   verbose=0 wbox=500 hbox=750 title="cdp $1" label1="Time (s)" label2="Offset (m)" &

suspecfk < $basefolder/tmp.su |
suximage cmap=hsv2 title="VP$1 F-K spectrum" label1="Frequency Hz" label2="Wavenumber cycles/m"

rm $basefolder/tmp.*

#cmap=hsv4
