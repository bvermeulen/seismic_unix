tutorial: https://github.com/hadi-tim/sdp-seismic-unix
author: Hadi Timediouine
Dataset: https://wiki.seg.org/wiki/2D_Vibroseis_Line_001#Download_Link
installation: https://wiki.seismic-unix.org/sudoc:su_installation


apply geometry:
sushw < line_001.su infile=myheaders.bin key=sx,sy,selev,sstat,gx,gy,gelev,gstat,offset > line_001e.su

change header
sushw < line_001e.su key=scalel,slalco a=1,1 > line_001_edited.su


