#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/2dtestline/data/output
inputfile=line1filtered.su

suwind < $basefolder/$inputfile key=ep min=$1 max=$1 |
sunmo \
    smute=1.30 \
    tnmo=0.00,0.60,1.0,1.6,2.8 \
    vnmo=1800.0,2450.0,3350.0,3700.0,4325.0 |
suximage perc=90
