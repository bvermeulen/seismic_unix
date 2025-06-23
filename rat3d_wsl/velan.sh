#! /bin/sh
# Velocity analyses for the cmp gathers
# Authors: Dave, Jack
# NOTE: Comment lines preceeding user input start with  #!#
#set -x

# parameters:  cmpfilein  cmpfirst  cmplast  cmpstep  cmpminfold
#              $1         $2        $3       $4       $5

#!# Set parameters
velpanel=$1
vpicks=stkvel.nmo
normpow=1
slowness=0
cdpmin=$2
cdpmax=$3
dcdp=$4
fold=$5

#!# Set velocity sampling and band pass filters
# nv   number of different velocities to test
# dv   velocity step in m/s
# fv   first velocity to try in m/s
nv=31 dv=100 fv=00
#f1=3 f2=6 f3=30 f4=36

### Get header info
nout=`sugethw ns <$velpanel | sed 1q | sed 's/.*ns=//'`
dt=`sugethw dt <$velpanel | sed 1q | sed 's/.*dt=//'`
dxout=`bc -l <<END
	$dt / 1000000
END`


### Do the velocity analyses.echo "Pick velocities by moving mouse to a velocity peak"
echo "Type lower case 's' to select peak (Time and Stacking Velocity)"
echo "Type upper case 'Q' when done"

cdp=$cdpmin
while [ $cdp -le $cdpmax ]
do
	ok=false
	while [ $ok = false ]
	do
#		sugain tpow=2 |
#		sufilter f=$f1,$f2,$f3,$f4 |

		echo "Starting velocity analysis for cdp $cdp"
		suwind <$velpanel key=cdp min=$cdp max=$cdp count=$fold |
		suvelan nv=$nv dv=$dv fv=spline$fv \
				normpow=$normpow slowness=$slowness |
		suximage f2=$fv d2=$dv \
			label1="Time (sec)" label2="Stacking Velocity (m/s)" \
			title="Velocity Scan for CMP point $cdp" \
			grid1=solid grid2=solid cmap=hue \
			mpicks=mpicks.$cdp

		sort <mpicks.$cdp -n |
		mkparfile string1=tnmo string2=vnmo >par.$cdp

		echo "Putting up velocity function for cdp $cdp"
		sed <par.$cdp '
			s/tnmo/xin/
			s/vnmo/yin/
		' >unisam.p
		unisam nout=$nout fxout=0.0 dxout=$dxout \
			par=unisam.p method=spline |
		xgraph n=$nout nplot=1 d1=$dxout f1=0.0 \
			label1="Time (sec)" label2="Stacking Velocity (m/s)" \
			title="Stacking Velocity Function: CMP $cdp" \
			grid1=solid grid2=solid cmap=hue \
			linecolor=2 style=seismic &

		pause

		echo "Picks OK? (y to continue/n to repeat picking) " >/dev/tty
		read response
		case $response in
		n*) ok=false ;;
		*) ok=true ;;
		esac

	done </dev/tty
	cdp=`bc -l <<END
		$cdp + $dcdp
END`

done

set +x


### Combine the individual picks into a composite sunmo par file
echo "Editing pick files ..."
>$vpicks
echo "cdp=" >>$vpicks
cdp=$cdpmin
echo "$cdp" >>$vpicks
cdp=`bc -l <<END
	$cdp + $dcdp
END`
while [ $cdp -le $cdpmax ]
do
	echo ",$cdp" >>$vpicks
	cdp=`bc -l <<END
		$cdp + $dcdp
END`
done
echo >>$vpicks
cdp=$cdpmin
while [ $cdp -le $cdpmax ]
do
	cat par.$cdp >>$vpicks
	cdp=`bc -l <<END
		$cdp + $dcdp
END`
done


echo "sunmo par file: $vpicks is ready"


### Clean up
cdp=$cdpmin
while [ $cdp -le $cdpmax ]
do
	rm mpicks.$cdp par.$cdp
	cdp=`bc -l <<END
		$cdp + $dcdp
END`
done
rm unisam.p