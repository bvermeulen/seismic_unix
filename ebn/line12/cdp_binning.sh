#!/bin/bash
tmpfolder=/home/bvermeulen/seismic_unix/ebn/line12/data/tmp
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
inputfilename=line12_filter.su
outputfilename=line12_cdp_test.su
cdp_trace_interval=30
concats="cat " 

# Set the CMP interval
dcdp=10.0

for distmax in 250
do
    echo Running crooked line binning for maximimum offline distance $distmax into $dcdp m bins
    sucdpbin_test \
        < $basefolder/$inputfilename \
        xline=214499,212234,211190,210209,209910,208454,205796,204974,204771,201168 \
		yline=508889,499713,497614,493994,490019,484055,477973,474850,470510,452656 \
        verbose=1 \
        dcdp=$dcdp \
        distmax=$distmax \
        2>$basefolder/cdp.log |
    suwind \
        key=cdp \
        min=1001 \
        > $tmpfolder/tmp1.su

    susort \
        < $tmpfolder/tmp1.su \
        cdp \
        offset |
	sushw \
        key=d2 \
        a=$cdp_trace_interval \
        > $basefolder/$outputfilename

    echo Creating chart data
    suchart \
        < $basefolder/$outputfilename \
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
        > $tmpfolder/plot$distmax.ps \
        title="Maximum offline distance $distmax m - $dcdp m Bins"

    concats="$concats $tmpfolder/plot$distmax.ps"
done

# Now concatenate the Postscript files in the same order they were created, so the resulting multipage file
# can be opened and the effects of changing the offline distance parameter
$concats > $tmpfolder/binning.ps
gv $tmpfolder/binning.ps
rm $tmpfolder/*
