#!/bin/bash

basefolder=/home/bvermeulen/Development/seismic_unix/rat3d/data/output

# Set up a command to concatenate some plot files for comparing off-line distances accepted
convert="cat "

# Set the CMP interval
dcdp=2.5

for distmax in 7
do
	echo Running crooked line binning for maximimum offline distance $distmax into $dcdp m bins
	sucdpbin < $basefolder/line1filtered.su \
		  xline=717546.30,718713.25 \
		  yline=3371457.35,3370692.85 \
          verbose=2 dcdp=$dcdp distmax=$distmax 2>$basefolder/cdp.log |
	suwind key=cdp min=1001 > $basefolder/line1cdp.su
	susort < $basefolder/line1cdp.su cdp offset > $basefolder/tmp.su
	suchw < $basefolder/tmp.su key1=d2 a=10.0 b=0 |
	suwind key=offset  min=-1100 max=1100 > $basefolder/line1cdp_muted.su
	rm $basefolder/tmp.su

	echo Creating chart data
	suchart < $basefolder/line1cdp_muted.su key1=cdp key2=offset > $basefolder/plotdata outpar=$basefolder/par

	echo Running Postscript graphing routine
	psgraph < $basefolder/plotdata par=$basefolder/par linewidth=0 mark=0 marksize=1 labelsize=6 titlesize=12 \
           linecolor=blue wbox=13 hbox=10 >$basefolder/plot$distmax.ps title="Maximum offline distance \
           $distmax m - $dcdp m Bins"

	convert="$convert $basefolder/plot$distmax.ps"
    # echo $convert
done

# Now concatenate the Postscript files in the same order they were created, so the resulting multipage file
# can be opened and the effects of changing the offline distance parameter
$convert > $basefolder/binning.ps
cd $basefolder
rm plotdata
rm plot*.ps
#rm line1cdp*.su
gv $basefolder/binning.ps
