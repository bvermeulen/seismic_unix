#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/2dtestline
i=0
echo "Basefolder: $basefolder"

for segdfile in $basefolder/data/segd/*.sgd;
do

    echo "processing file: $i, $segdfile"
    segdread tape="$segdfile" use_stdio=1 |
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
echo "read_segd completed"
