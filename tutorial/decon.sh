#!/bin/sh
minlag=0.02
maxlag=0.1
pnoise=0.001
ntout=120
basefolder=/home/bvermeulen/Python/seismic_unix/tutorial/data
indata=$basefolder/line_001_sorted_fk_bpf.su
outdata=$basefolder/line_001_sorted_fk_bpf_decon.su

# Data selection you will probably need to use sugain to remove any decay in amplitudes with time that may result from geometric spreading
suwind < $indata key=ep min=120 max=120 |
sugain agc=1 wagc=0.2 > tmp_shot

# One Shot display
suximage < tmp_shot perc=90 title="Before deconvolution" label1="Time(s)" label2="Trace"

# Autocorrelation before deconvolution
suacor < tmp_shot suacor ntout=$ntout |
suximage perc=90 title="Autocorrelation before deconvolution" label1="Time(s)" label2="Trace"

# Deconvolution
supef < tmp_shot minlag=$minlag maxlag=$maxlag pnoise=$pnoise > tmp_decon
suximage < tmp_decon perc=90 title="After deconvolution" label1="Time(s)" label2="Trace"# After Deconvolution

# Autocorrelation after deconvolution
suacor < tmp_decon suacor ntout=$ntout |
suximage perc=90 title="Autocorrelation after deconvolution" label1="Time(s)" label2="Trace"

# Apply deconvolution to al the data
supef < $indata minlag=0.02 maxlag=0.1 pnoise=0.001 > $outdata

rm -f tmp*