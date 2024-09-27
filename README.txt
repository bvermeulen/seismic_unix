tutorial: https://github.com/hadi-tim/sdp-seismic-unix
author: Hadi Timediouine
Dataset: https://wiki.seg.org/wiki/2D_Vibroseis_Line_001#Download_Link

apply geometry:
sushw < line_001.su infile=myheaders.bin key=sx,sy,selev,sstat,gx,gy,gelev,gstat,offset > line_001e.su


