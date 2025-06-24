basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl/data/output

a2b < $basefolder/202505_geometry.txt n1=10 > $basefolder/myheaders.bin
sushw < $basefolder/line1.su infile=$basefolder/myheaders.bin key=ep,sx,sy,selev,sstat,gx,gy,gelev,gstat,offset > $basefolder/tmp1.su
sushw < $basefolder/tmp1.su key=scalco,scalel,d2 a=1,1,5 > $basefolder/tmp2.su

suwind tmax=1.6 < $basefolder/tmp2.su > $basefolder/tmp3.su
sufilter  < $basefolder/tmp3.su f=10,15,85,95,250 amps=1,1,1,0,0 |
suresamp dt=0.004 nt=400 |
suramp tmax=1.5 > $basefolder/line1h.su

rm $basefolder/tmp?.*
