#!/bin/sh
minlag=0.02
maxlag=0.1
pnoise=0.001
ntout=120
indata=/home/bvermeulen/Python/seismic_unix/tutorial/data/line_001_sorted_fk.su
outdata=/home/bvermeulen/Python/seismic_unix/tutorial/data/line_001_sorted_fk_decon.su

# Data selection you will probably need to use sugain to remove any decay in amplitudes with time that may result from geometric spreading
suwind < $indata key=ep min=120 max=120 > tmp0
sugain < tmp0 agc=1 wagc=0.2 > tmp1

# One Shot display
suximage < tmp1 perc=90 title="Before deconvolution" label1="Time(s)" label2="Trace"

# Autocorrelation before deconvolution
suacor < tmp1 suacor ntout=$ntout |
suximage perc=90 title="Autocorrelation before deconvolution" label1="Time(s)" label2="Trace"

# Deconvolution
supef < tmp1 minlag=$minlag maxlag=$maxlag pnoise=$pnoise > tmp2
suximage < tmp2 perc=90 title="After deconvolution" label1="Time(s)" label2="Trace"# After Deconvolution

# Autocorrelation after deconvolution
suacor < tmp2 suacor ntout=$ntout |
suximage perc=90 title="Autocorrelation after deconvolution" label1="Time(s)" label2="Trace"

# Apply deconvolution to al the data
supef < $indata minlag=0.02 maxlag=0.1 pnoise=0.001 > $outdata

rm -f tmp*