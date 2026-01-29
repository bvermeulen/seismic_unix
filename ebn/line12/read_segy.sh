#!/bin/bash

transferfolder=/mnt/d/wsl/data_transfer/Line12/SEGY
basefolder=/home/bvermeulen/seismic_unix/ebn/line12
i=0
echo "Basefolder: $basefolder"

for segyfile in $transferfolder/*.sgy;
do
    echo "processing file: $i, $segyfile"
    segyread tape="$segyfile" |
    suwind key=tracf min=1 | 
    sufilter f=0,85,95,250 amps=1,1,0,0 |
    suresamp dt=0.004 nt=1000 |
    suramp tmax=3.9 > tmp1.su 

    if (($i == 0)); then
        cat tmp1.su > tmp2.su
    else
        cat tmp1.su >> tmp2.su
    fi
    ((i++))

done

susort < tmp2.su fldr | 
segyclean > tmp3.su

sushw < tmp3.su key=d2 a=5 > $basefolder/data/output/line12_1500_1922.su

rm tmp*.su
echo "read_segy completed"
