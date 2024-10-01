#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/forge_2d/data
i=0
echo "Basefolder: $basefolder"

for segyfile in "$basefolder"/Correlated_Shot_Gathers/*.sgy;
do

    echo "processing file: $i, $segyfile"
    segyread tape="$segyfile" endian=1 |
    suwind key=tracf min=7 > tmp.su
    if (($i == 0)); then
        cat tmp.su > tmp1.su
    else
        cat tmp.su >> tmp1.su
    fi
    ((i++))

done

susort fldr < tmp1.su | segyclean > "$basefolder"/su_results/line1.su
rm tmp*.su
echo "read_segy completed"
