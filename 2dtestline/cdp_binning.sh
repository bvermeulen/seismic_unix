#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/2dtestline/data/output

# Set up a command to concatenate some plot files for comparing off-line distances accepted
convert="cat "

# Set the CMP interval
dcdp=12.5

for distmax in 15
do
	echo Running crooked line binning for maximimum offline distance $distmax into $dcdp m bins
	sucdpbin < $basefolder/line1filtered.su \
		  xline=701590.0,706590.0 \
		  yline=3390584.1,3390584.4\
          verbose=2 dcdp=$dcdp distmax=$distmax 2>$basefolder/cdp.log |
	suwind key=cdp min=1001 > $basefolder/line1cdp.su
	susort < $basefolder/line1cdp.su cdp offset > $basefolder/tmp.su
	suchw < $basefolder/tmp.su key1=d2 a=50.0 b=0 |
	sumute key=offset xmute=-5000,0,5000 tmute=0,0,0 > $basefolder/line1cdp_muted.su
	rm $basefolder/tmp.su

	echo Creating chart data
	suchart < $basefolder/line1cdp.su key1=cdp key2=offset > $basefolder/plotdata outpar=$basefolder/par

	echo Running Postscript graphing routine
	psgraph < $basefolder/plotdata par=$basefolder/par linewidth=0 mark=0 marksize=1 labelsize=6 titlesize=12 \
           linecolor=blue wbox=13 hbox=10 >$basefolder/plot$distmax.ps title="Maximum offline distance \
           $distmax m - $dcdp m Bins"

	convert="$convert $basefolder/plot$distmax.ps"
    #echo $convert
done

# Now concatenate the Postscript files in the same order they were created, so the resulting multipage file
# can be opened and the effects of changing the offline distance parameter
$convert > $basefolder/binning.ps
cd $basefolder
rm plotdata
rm plot*.ps
#rm line1cdp*.su
gv $basefolder/binning.ps
