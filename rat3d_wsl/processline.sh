#!/bin/bash

basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl

# processing of line1.su, located in /home/bvermeulen/seismic_unix/rat3d_wsl/data/output

echo "==> apply geometry, resample to 4 msec and limit traces to 400 samples"
$basefolder/apply_geom.sh

echo "==> apply dipfilter in shot domain, bandpass filter, decon"
$basefolder/filter.sh

echo "==> apply cdp binning, cdp sort, mute before first break, "
$basefolder/cdp_binning.sh

echo "==> precondition: velocity picking has been done with velpich.sh"
echo "==> make brute stack"
$basefolder/brute_stack.sh

echo "==> processing completed <=="
