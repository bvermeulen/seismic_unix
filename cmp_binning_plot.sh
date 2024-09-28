#!/bin/bash

# Set up a command to concatenate some plot files for comparing off-line distances accepted
convert="cat "

# Set the CMP interval
dcdp=12.5

# Loop through several offline distances and compare results.
for distmax in 12.5 25 50 100 200 500
do
	echo Running crooked line binning for maximimum offline distance $distmax into $dcdp m bins
	sucdpbin < data/line_001e.su \
		  xline=684590.2,697315.1,703807.7 \
		  yline=3837867.6,3839748.8,3841277.2 \
          verbose=2 dcdp=$dcdp distmax=$distmax 2>data/cdp.log |
	suwind key=cdp min=1 > data/geomdata_cmps_$distmax.su

	echo Creating chart data
	suchart < data/geomdata_cmps_$distmax.su key1=cdp key2=offset > data/plotdata outpar=par

	echo Running Postscript graphing routine
	psgraph < data/plotdata par=par linewidth=0 mark=0 marksize=1 labelsize=6 titlesize=12 \
           linecolor=blue wbox=13 hbox=10 >data/plot$distmax.ps title="Maximum offline distance \
           $distmax m - $dcdp m Bins"

	convert="$convert data/plot$distmax.ps"
    echo $convert
done

# Now concatenate the Postscript files in the same order they were created, so the resulting multipage file
# can be opened and the effects of changing the offline distance parameter
$convert > data/crookedLine_binning.ps
cd ./data
rm plotdata
rm plot*.ps
#rm geomdata_cmps_*.su
gv crookedLine_binning.ps
