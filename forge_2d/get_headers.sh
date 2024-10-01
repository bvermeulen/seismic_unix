#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/forge_2d/data/su_results/
suwind key=fldr min=$1 max=$1 < $basefolder/line1_norm.su |
sugethw key=fldr,sx,sy,gx,gy,offset
