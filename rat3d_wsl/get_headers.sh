#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl/data/output
suwind key=fldr min=$1 max=$1 < $basefolder/line1h.su |
sugethw key=ep,tracf,fldr,sx,sy,gx,gy,offset,scalco,scalel
