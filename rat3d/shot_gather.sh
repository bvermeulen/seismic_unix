#!/bin/bash
basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output

suwind key=ep min=$1 max=$1 tmax=2.0 < $basefolder/line1cdp_fk_bp7.su | suxwigb key=offset d2=5 perc=70 \
   title="shot $1 after geometry" label1="Time (s)" label2="Offset (m)"

#cmap=hsv4