#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl/data/output
stack=stack_bgp

suwind tmin=0 tmax=1.6 < $basefolder/$stack.su | 
sugain agc=2 wagc=0.5 | 
suximage f2=0 d2=1  wbox=1400 hbox=700 title="Brute stack" cmap=grey clip=4
