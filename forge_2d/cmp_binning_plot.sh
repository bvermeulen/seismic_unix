#!/bin/bash

# Set up a command to concatenate some plot files for comparing off-line distances accepted
convert="cat "
basefolder=/home/bvermeulen/Python/seismic_unix/forge_2d/data/su_results

# Set the CMP interval
dcdp=12.50

# Loop through several offline distances and compare results.
for distmax in 12.5 25 50 100 200 500
do
	echo Running crooked line binning for maximimum offline distance $distmax into $dcdp m bins
	sucdpbin < $basefolder/line1_norm.su \
		  xline=329280,332126,333124,337720,339931,341522 \
		  yline=4265315,4264380,4264308,4263949,4263920,4264422 \
          verbose=2 dcdp=$dcdp distmax=$distmax 2>$basefolder/cdp.log |
	suwind key=cdp min=1 > $basefolder/geomdata_cmps_$distmax.su

	echo Creating chart data
	suchart < $basefolder/geomdata_cmps_$distmax.su key1=offset key2=cdp > $basefolder/plotdata outpar=par

	echo Running Postscript graphing routine
	psgraph < $basefolder/plotdata par=par linewidth=0 mark=0 marksize=1 labelsize=6 titlesize=12 \
           linecolor=blue wbox=13 hbox=10 >$basefolder/plot$distmax.ps title="Maximum offline distance \
           $distmax m - $dcdp m Bins"

	convert="$convert $basefolder/plot$distmax.ps"
    echo $convert
done

# Now concatenate the Postscript files in the same order they were created, so the resulting multipage file
# can be opened and the effects of changing the offline distance parameter
$convert > $basefolder/crookedLine_binning.ps
cd $basefolder
rm plotdata
rm plot*.ps
rm geomdata_cmps_*.su
gv crookedLine_binning.ps
