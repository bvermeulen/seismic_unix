#!/bin/bash

basefolder=/home/bvermeulen/Python/seismic_unix/rat3d
i=0
echo "Basefolder: $basefolder"

for segyfile in "$basefolder"/data/segy/*.sgy;
do

    echo "processing file: $i, $segyfile"
    segyread tape="$segyfile" endian=1 |
    suwind key=tracf min=1 > tmp.su
    if (($i == 0)); then
        cat tmp.su > tmp1.su
    else
        cat tmp.su >> tmp1.su
    fi
    ((i++))

done

susort fldr < tmp1.su | segyclean > $basefolder/data/output/line1.su
rm tmp*.su
echo "read_segy completed"
