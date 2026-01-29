#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfile=$1

suximage < $basefolder/$inputfile verbose=0 f2=$fcdp d2=1.0 wbox=1400 hbox=700 title="Brute stack (bin size 2.5m)" cmap=grey clip=0.5
# for collor add: cmap=hsv4
