#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/data/forge_2d/Correlated_Shot_Gathers
i=0
echo "Basefolder: $basefolder"

for segyfile in "$basefolder"/*.sgy;
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

susort fldr < tmp1.su | segyclean > "$basefolder"/line1.su
rm tmp*.su
echo "read_segy completed"
