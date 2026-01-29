#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
filename=line12_filter.su
outfile=line12_cdp.su

susort < $basefolder/$filename cdp offset > $basefolder/tmp.su
sushw < $basefolder/tmp.su key=d2 a=10 > $basefolder/$outfile

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
