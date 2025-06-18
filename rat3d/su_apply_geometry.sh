basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output
a2b < $basefolder/202505_geometry.txt n1=10 > $basefolder/myheaders.bin
sushw < $basefolder/line1.su infile=$basefolder/myheaders.bin key=ep,sx,sy,selev,sstat,gx,gy,gelev,gstat,offset > $basefolder/tmp.su
sushw < $basefolder/tmp.su key=scalco,scalel a=1,1 > $basefolder/line1h.su
rm $basefolder/tmp.su
