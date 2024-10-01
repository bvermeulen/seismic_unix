#!/bin/bash
basefolder=/home/bvermeulen/Python/seismic_unix/forge_2d/data

suwind key=fldr min=$1 max=$2 < $basefolder/su_results/line1_norm.su | suximage key=offset d2=25 cmap=hsv4 perc=90 \
   title="shot $1 after geometry" label1="Time (s)" label2="Offset (m)"
