#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfile=$1
if [ $2 == "reversed" ]; then
    sortkey="-cdp"
else
    sortkey="cdp"
fi
echo "argument: $2, sortkey: $sortkey"

susort \
    < $basefolder/$inputfile \
    $sortkey |
suximage \
    verbose=0 \
    f2=$fcdp \
    d2=1.0 \
    wbox=1400 \
    hbox=700 \
    title="Brute stack (bin size 2.5m)" \
    cmap=grey \
    clip=0.50

# for collor add: cmap=hsv4
