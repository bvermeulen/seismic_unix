#!/bin/bash
basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output

suwind key=cdp min=$1 max=$1 < $basefolder/line1cdp_sorted7.su | suxwigb key=offset d2=2.5 perc=80 \
   title="cdp $1 (not filtered)" label1="Time (s)" label2="Offset (m)" &

suwind key=cdp min=$1 max=$1 < $basefolder/line1cdp_fk_bp_decon.su | suxwigb key=offset d2=2.5 perc=80 \
   title="cdp $1 (filtered)" label1="Time (s)" label2="Offset (m)"

#cmap=hsv4