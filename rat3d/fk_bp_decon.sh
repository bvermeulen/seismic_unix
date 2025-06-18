#!/bin/bash

#slopes=-0.5,-0.3,0.3,0.5 amps=0,1,1,0 bias=0 |

basefolder=/home/bvermeulen/Python/seismic_unix/rat3d/data/output
inputfile=line1cdp_sorted7.su
outputfile=line1cdp_fk_bp_decon.su

sudipfilt < $basefolder/$inputfile dt=0.001 dx=5.0 \
    slopes=-0.6,-0.5,0.5,0.6 amps=0,1,1,0 bias=0 |
sufilter f=10,15,70,80 > $basefolder/tmp.su
supef < $basefolder/tmp.su minlag=0.02 maxlag=0.1 pnoise=0.001 > $basefolder/$outputfile
