#!/bin/bash

# set -x
echo "Velocity Analysis"
echo " "
echo "  Place the cursor over the semblance plot or the"
echo "  constant velocity stack and type 's' to pick velocities."
echo "  For each suitable cursor position, press 's' to pick."
echo "  Type 'q' in the semblance plot when all picks are made."
echo "  A NMO corrected gather will be plotted after picking"
echo " "

#------------------------------------------------
# Defining Variables etc...
#------------------------------------------------

tmpfolder=/home/bvermeulen/seismic_unix/ebn/line12/data/tmp
basefolder=/home/bvermeulen/seismic_unix/ebn/line12/data/output
indata=$basefolder/line12_cdp.su
outdata=$basefolder/vpick.data1

if [ ! -f $indata ]
then    
    echo "file $indata does not exist!"
    pause EXIT
    exit
fi

nt=1000
dt=0.004
nv=20    # Number of Velocities
dv=200   # Interval
fv=1000  # First Velocity
trace_distance=30.0 # distance between traces within the the gather
>$outdata   # Write an empty file
>$tmpfolder/par.cmp    # Write an empty file

#------------------------------------------------
# Interactive Velocity Analysis...
#------------------------------------------------

echo "How many Picks? (typical 4)" >/dev/tty
read nrpicks

i=1
while [ $i -le $nrpicks ]
do
    echo "Specify CMP Pick Location (CMP gather number) $i" >/dev/tty
    read picknow
    echo "Preparing Location $i of $nrpicks for Picking "
    echo "Location is CMP $picknow "

#------------------------------------------------
# CMP Gather Plot...
#------------------------------------------------

    suwind \
        < $indata \
        key=cdp \
        min=$picknow \
        max=$picknow \
        > $tmpfolder/panel.$picknow

    foffset=$(sugethw < $tmpfolder/panel.$picknow key=offset | head -n 1 | grep -Eo '[-][0-9]*')
    suximage \
        < $tmpfolder/panel.$picknow \
        xbox=422 \
        ybox=10 \
        wbox=400 \
        hbox=600 \
        title="CMP gather $picknow" \
	    f2=$foffset \
        d2=$trace_distance \
        perc=95 \
        verbose=0 &

#------------------------------------------------
# Constant Velocity Stack (please wait)...
#------------------------------------------------

    >$tmpfolder/tmp1 # Create empty file
    j=0
    s=`expr $picknow - 19`
    k=`expr $picknow + 20`
    l=`echo "$dv * $nv / 820" | bc`

    suwind \
        < $indata \
        key=cdp \
        min=$s \
        max=$k \
        > $tmpfolder/tmp0

    while [ $j -lt $nv ]
    do
        vel=`echo "$fv + $dv * $j" | bc`
        sunmo \
            < $tmpfolder/tmp0 \
            vnmo=$vel |
        sustack \
            >> $tmpfolder/tmp1
        sunull \
            ntr=2 \
            nt=$nt \
            dt=$dt \
            >> $tmpfolder/tmp1

        j=`expr $j + 1`
    done

    suximage \
        < $tmpfolder/tmp1 \
        xbox=834 \
        ybox=10 \
        wbox=400 \
        hbox=600 \
        title="Constant Velocity Stack CMP $picknow" \
        label1="Time [s]" label2="Velocity [m/s]" \
        f2=$fv \
        d2=$l \
        verbose=0 \
        mpicks=$tmpfolder/picks.$picknow \
        perc=95 \
        n2tic=5 \
        cmap=hsv5 &

#------------------------------------------------
# Semblance Plot...
#------------------------------------------------

    nv=100
    dv=40
    fv=1000
    bclip=0.6

    suvelan \
        < $tmpfolder/panel.$picknow \
        nv=$nv \
        dv=$dv \
        fv=$fv |
    suximage \
        xbox=10 \
        ybox=10 \
        wbox=400 \
        hbox=600 \
        units="semblance" \
        f2=$fv \
        d2=$dv \
        label1="Time [s]" label2="Velocity [m/s]" \
        title="Semblance Plot CMP $picknow" cmap=hsv2 \
        legend=1 \
        units=Semblance \
        verbose=0 \
        gridcolor=black \
        bclip=$bclip \
        grid1=solid \
        grid2=solid \
        mpicks=$tmpfolder/picks.$picknow

	sort \
        < $tmpfolder/picks.$picknow \
        -n | 
    mkparfile \
        string1="tnmo" \
        string2="vnmo" \
        > $tmpfolder/par.$i
	
    sort \
        < $tmpfolder/picks.$picknow \
        -n | 
    mkparfile \
        string1="xin" \
        string2="yin" \
        > $tmpfolder/par.unisam.$i

	echo "Completed listing of mkparfile output ..."

#------------------------------------------------
# NMO Plot and Velocity Profile...
#------------------------------------------------

	>$tmpfolder/tmp2	# Create empty file
	echo "cdp=$picknow" >> $tmpfoldertmp2
	cat $tmpfolder/par.$i >> $tmpfolder/tmp2
	foffset=$( \
        sugethw \
            < $tmpfolder/panel.$picknow \
            key=offset | 
        head \
            -n 1 | 
        grep \
            -Eo '[-][0-9]*' \
    )
	
    sunmo \
        < $tmpfolder/panel.$picknow \
        par=$tmpfolder/tmp2 |
	suximage \
        title="CMP gather $picknow after NMO" \
        xbox=10 \
        ybox=10 \
		wbox=400 \
        hbox=600 \
        verbose=0 \
        f2=$foffset \
        d2=120 \
        perc=95 &

	echo "Completed NMO plot ..."

#------------------------------------------------
# Velocity Profile...
#------------------------------------------------

	unisam \
		par=$tmpfolder/par.unisam.$i \
        nout=$nt \
        fxout=0.0 \
        dxout=$dt \
        method=linear \
        > $tmpfolder/tmp.unisam

	xgraph \
        < $tmpfolder/tmp.unisam \
	 	n=$nt \
        nplot=1 \
        d1=$dt \
        f1=0.0 \
		label1="Time [s]" \
        label2="Velocity [m/s]" \
		title="---> Stacking Velocity Function CMP $picknow" \
		-geometry 400x600+422+10 style=seismic \
		titleColor=red \
        axesColor=blue \
        gridColor=purple\
		grid1=dash \
        grid2=dash \
		linecolor=3 \
        mark=0 \
        marksize=1 &

	echo "Completed Velocity profile ..."

	echo "Picks OK? (y/n) " > /dev/tty
	read response

	case $response in
		n*)
			i=$i
			echo "Picks removed"
			;;
		*)
			i=`expr $i + 1`
			echo "$picknow $i" >> $tmpfolder/par.cmp
			;;
    esac
done
echo "Completed picking ..."

#------------------------------------------------
# Create Velocity Output File...
#------------------------------------------------

mkparfile \
    < $tmpfolder/par.cmp \
    string1=cdp \
    string2=# \
    > $tmpfolder/par.0

i=0
while [ $i -le $nrpicks ]
do
	cat $tmpfolder/par.$i >>$outdata
	i=`expr $i + 1`
done

rm -f $tmpfolder/*
exit
