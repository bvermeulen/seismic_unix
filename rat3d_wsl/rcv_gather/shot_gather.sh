#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl/data/output_revised

suwind key=cdp min=$1 max=$1 < $basefolder/line1h_sorted.su > $basefolder/tmp.su
foffset=$(sugethw < $basefolder/tmp.su key=offset | head -n 1 | grep -Eo '[-]*[0-9]*')
echo "minimum offset: $foffset"

suximage < $basefolder/tmp.su f2=$foffset perc=98 cmap=grey\
   verbose=0 wbox=500 hbox=750 title="shot $1 after geometry" label1="Time (s)" label2="Offset (m)" &

suspecfk < $basefolder/tmp.su |
suximage cmap=hsv2 legend=1 title="VP$1 F-K spectrum" label1="Frequency Hz" label2="Wavenumber cycles/m"

# rm $basefolder/tmp.*

#cmap=hsv4
