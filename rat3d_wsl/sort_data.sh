#!/bin/bash
basefolder=/home/bvermeulen/seismic_unix/rat3d_wsl/data/output

susort < $basefolder/line1filtered.su cdp offset > $basefolder/line1_sorted.su
