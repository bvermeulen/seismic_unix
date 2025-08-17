#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/rat3d_corr/data
segyfile=node_min_ref
outputfile=minphase

segyread tape=$basefolder/segy/$segyfile.sgy |
segyclean > $basefolder/$segyfile.su
#suwind  > tmp.su
#susort fldr < tmp.su
