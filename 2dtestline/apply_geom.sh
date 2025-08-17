#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/2dtestline/data/output

a2b < $basefolder/20250804_geometry.txt n1=12 > $basefolder/myheaders.bin
sushw < $basefolder/line1.su infile=$basefolder/myheaders.bin key=ep,sx,sy,selev,sstat,gstat,gx,gy,gelev,gstat,offset,cdp > $basefolder/tmp1.su
sushw < $basefolder/tmp1.su key=scalco,scalel,d2 a=1,1,25 > $basefolder/tmp2.su

suwind tmax=6.0 < $basefolder/tmp2.su > $basefolder/tmp3.su
sufilter  < $basefolder/tmp3.su f=0,85,95,250 amps=1,1,0,0 |
suresamp dt=0.004 nt=750 |
suramp tmax=2.9 > $basefolder/line1h.su
rm $basefolder/tmp?.*
