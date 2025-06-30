#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl/data/output_revised

a2b < $basefolder/202505_geometry.txt n1=11 > $basefolder/myheaders.bin
sushw < /home/bvermeulen/seismic_unix/rat3d_wsl/data/output/line1.su infile=$basefolder/myheaders.bin key=ep,cdp,sx,sy,selev,sstat,gx,gy,gelev,gstat,offset |
sushw key=scalco,scalel,d2 a=1,1,5 |
suwind tmax=1.6 |
sufilter f=10,15,85,95,250 amps=1,1,1,0,0 |
suresamp dt=0.004 nt=400 |
suramp tmax=1.5 |
susort cdp ep > $basefolder/line1h_sorted.su

