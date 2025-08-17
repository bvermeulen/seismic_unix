#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/rat3d_corr/data
file1=node_lin_ref
file2=vib_lin_ref

suxcor < $basefolder/$file1.su sufile=$basefolder/$file2.su |
suwind tmin=15.9 tmax=16.1 >> $basefolder/corr_ll_lm_ml_mm_node_vib.su.tmp
#suxwigb
