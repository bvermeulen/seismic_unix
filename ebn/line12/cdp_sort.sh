#!/bin/bash
tmpfolder=/home/bvermeulen/seismic_unix/ebn/line12/data/tmp
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
filename=line12_filter.su
outfile=line12_cdp.su
distance=n/a
dcdp=10.0
cdp_trace_interval=30

susort \
    < $basefolder/$filename \
    cdp offset \
    > $tmpfolder/tmp.su

sushw \
    < $tmpfolder/tmp.su \
    key=d2 \
    a=$cdp_trace_interval \
    > $basefolder/$outfile

echo Creating chart data
suchart \
    < $basefolder/$outfile \
    key1=cdp \
    key2=offset \
    outpar=$tmpfolder/par \
    > $tmpfolder/plotdata

echo Running Postscript graphing routine
psgraph \
    < $tmpfolder/plotdata \
    par=$tmpfolder/par \
    linewidth=0 \
    mark=0 \
    marksize=1 \
    labelsize=6 \
    titlesize=12 \
    linecolor=blue \
    wbox=13 \
    hbox=10 \
    >$tmpfolder/plot.ps title="Maximum offline distance $distmax m - $dcdp m bins"

gv $tmpfolder/plot.ps
rm $tmpfolder/*
