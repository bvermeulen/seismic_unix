#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/data/forge_2d/Correlated_Shot_Gathers
sugethw < $basefolder/$1.su key=fldr,sx,sy,gx,gy > $basefolder/$1"_coords.txt"