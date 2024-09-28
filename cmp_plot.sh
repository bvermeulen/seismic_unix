gawk '{print ($1+$5)/2,($2+$6)/2}'<data/geometry.txt | head -n 70782 | a2b > data/cmploc.bin 
cat data/cmploc.bin data/srcloc.bin data/rcvloc.bin | psgraph n=70782,251,782 linecolor=green,red,blue wbox=16 hbox=3.5 d1num=1000 d2num=1000 labelsize=9 grid1=solid grid2=solid gridcolor=gray marksize=0.5,1,1 gridwidth=0 linewidth=0,0 title="Source Receiver and CMPs locations" label1=Easting label2=Northing > data/SrcRcvCmp_loc_map.ps
gv ./data/SrcRcvCmp_loc_map.ps
