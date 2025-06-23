#!/bin/bash

# set -x
echo "Velocity Analysis"

#------------------------------------------------
# Defining Variables etc...
#------------------------------------------------

basefolder=/home/bvermeulen/seismic_unix/rat3d/data/output
indata=$basefolder/line1cdp_muted.su
outdata=$basefolder/vpick.data1

if [ ! -f $indata ]
then    echo "file $indata does not exist!"
        pause EXIT
        exit
fi

nt=400
dt=0.004

nv=10    # Number of Velocities
dv=250   # Interval
fv=1000  # First Velocity

>$outdata   # Write an empty file
>par.cmp    # Write an empty file

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

    suwind <$indata key=cdp min=$picknow \
            max=$picknow >panel.$picknow
    suximage <panel.$picknow xbox=422 ybox=10 \
             wbox=400 hbox=600 \
             title="CMP gather $picknow" \
             perc=90 verbose=0 &

#------------------------------------------------
# Constant Velocity Stack (please wait)...
#------------------------------------------------

    >tmp1			# Create empty file
    j=0
	s=`expr $picknow - 4`
    k=`expr $picknow + 5`
    l=`echo "$dv * $nv / 120" | bc`

	suwind < $indata key=cdp min=$s \
			max=$k > tmp0

    while [ $j -lt 10 ]
    do
		vel=`echo "$fv + $dv * $j * $nv / 10" | bc`
		sunmo < tmp0 vnmo=$vel |
			sustack >> tmp1
		sunull ntr=2 nt=$nt dt=$dt >> tmp1
		j=`expr $j + 1`
    done

	suximage <tmp1 xbox=834 ybox=10 wbox=400 hbox=600 \
			title="Constant Velocity Stack CMP $picknow" \
			label1="Time [s]" label2="Velocity [m/s]" \
			f2=$fv d2=$l verbose=0 mpicks=picks.$picknow \
			perc=90 n2tic=5 cmap=hsv5  &

#------------------------------------------------
# Semblance Plot...
#------------------------------------------------

	echo "  Place the cursor over the semblance plot or the"
	echo "  constant velocity stack and type 's' to pick velocities."
	echo "  For each suitable cursor position, press 's' to pick."
	echo "  Type 'q' in the semblance plot when all picks are made."
	echo "  A NMO corrected gather will be plotted after picking"
	echo " "

	nv=150
	dv=25
	fv=1000
	bclip=0.1

	suvelan < panel.$picknow nv=$nv dv=$dv fv=$fv |
		suximage xbox=10 ybox=10 wbox=400 hbox=600 \
			units="semblance" f2=$fv d2=$dv \
			label1="Time [s]" label2="Velocity [m/s]" \
			title="Semblance Plot CMP $picknow" cmap=hsv2 \
			legend=1 units=Semblance verbose=0  gridcolor=black bclip=$bclip\
			grid1=solid grid2=solid mpicks=picks.$picknow

	sort < picks.$picknow -n | mkparfile string1="tnmo" string2="vnmo" > par.$i
	sort < picks.$picknow -n | mkparfile string1="xin" string2="yin" > par.unisam.$i
	echo "Completed listing of mkparfile output ..."

#------------------------------------------------
# NMO Plot and Velocity Profile...
#------------------------------------------------

	>tmp2	# Create empty file
	echo "cdp=$picknow" >> tmp2
	cat par.$i >> tmp2
	sunmo <panel.$picknow par=tmp2 |
	suximage title="CMP gather $picknow after NMO" xbox=10 ybox=10 \
		wbox=400 hbox=600 verbose=0 key=offset perc=90 &
	echo "Completed NMO plot ..."

#------------------------------------------------
# Velocity Profile...
#------------------------------------------------

	unisam \
		par=par.unisam.$i nout=$nt fxout=0.0 dxout=$dt  method=linear > tmp.unisam

	cat tmp.unisam |
		 xgraph n=$nt nplot=1 d1=$dt f1=0.0 \
			label1="Time [s]" label2="Velocity [m/s]" \
			title="---> Stacking Velocity Function CMP $picknow" \
			-geometry 400x600+422+10 style=seismic \
			titleColor=red axesColor=blue \
			grid1=solid grid2=solid linecolor=3 mark=0 marksize=1 &

	echo "Completed Velocity profile ..."

	echo "Picks OK? (y/n) " >  /dev/tty
	read response

	case $response in
		n*)
			i=$i
			echo "Picks removed"
			;;
		*)
			i=`expr $i + 1`
			echo "$picknow  $i" >> par.cmp
			;;
    esac
done
echo "Completed picking ..."

#------------------------------------------------
# Create Velocity Output File...
#------------------------------------------------

mkparfile < par.cmp string1=cdp string2=# > par.0

i=0
while [ $i -le $nrpicks ]
do
	cat par.$i >>$outdata
	i=`expr $i + 1`
done

rm -f panel.* picks.* par.* tmp*
exit
