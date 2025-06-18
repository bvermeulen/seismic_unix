#!/bin/bash
basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output

suwind < $basefolder/geomdata_cmps_7.su key=ep min=1255 max=1255 tmax=2.5 > $basefolder/tmp.su
#suxwigb < $basefolder/tmp.su title="Ungained Data" &
#sugain < $basefolder/tmp.su scale=10.0 | suxwigb title="Scaled data" &
sugain < $basefolder/tmp.su agc=1.0 wagc=0.8 | suxwigb title="AGC=1 WAGC=0.8 sec" perc=90 &
sugain < $basefolder/tmp.su agc=1.0 wagc=0.2 | suxwigb title="AGC=1 WAGC=0.2 sec" perc=90 &
#sugain < $basefolder/tmp.su pbal=3 | suxwigb title="traces balanced by rms" &
#sugain < $basefolder/tmp.su qbal=3 | suxwigb title="traces balanced by quantile" &
sugain < $basefolder/tmp.su mbal=3 | suxwigb title="traces balanced by mean" perc=90 &
#sugain < $basefolder/tmp.su tpow=2 | suxwigb title="t squared factor applied" &
#sugain < $basefolder/tmp.su tpow=0.5 | suxwigb title="square root t factor applied" &

rm $basefolder/tmp.su