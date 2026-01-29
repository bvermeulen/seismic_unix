#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/4dtest201/data/output
filename=line201filter.su
outfile=line201_cdp.su

susort < $basefolder/$filename cdp offset > $basefolder/tmp.su
suchw < $basefolder/tmp.su key1=d2 a=50.0 b=0 > $basefolder/$outfile

echo Creating chart data
suchart < $basefolder/$outfile key1=cdp key2=offset > $basefolder/plotdata outpar=$basefolder/par

echo Running Postscript graphing routine
psgraph < $basefolder/plotdata par=$basefolder/par linewidth=0 mark=0 marksize=1 labelsize=6 titlesize=12 \
        linecolor=blue wbox=13 hbox=10 >$basefolder/plot.ps title="Maximum offline distance \
        $distmax m - $dcdp m Bins"

cd $basefolder
gv plot.ps
rm plotdata
rm par
rm tmp.su
rm plot.ps
