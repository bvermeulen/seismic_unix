#!/bin/bash

suximage < data/line_001_stack.su key=cdp cmap=hsv0 title="Brute stack" perc=90 &

sudipfilt < data/line_001_stack.su dt=0.002 dx=0.025 \
    slopes=-0.5,-0.3,0.3,0.5 amps=0,1,1,0 bias=0 \
> data/line_001_stack_fk.su
suximage < data/line_001_stack_fk.su key=cdp cmap=hsv0 title="Brute stack - FK filter" perc=90 &

sufilter < data/line_001_stack_fk.su f=10,15,55,60 > data/line_001_stack_fk_bpf.su
suximage < data/line_001_stack_fk_bpf.su key=cdp cmap=hsv0 title="Brute stack - BP filter" perc=90 &

suspecfx < data/line_001_stack_fk_bpf.su |
suximage key=cdp title="F-X SPECTRUM" label2="CMP" label1="Frequency (Hz)" cmap="hsv2" bclip=45 &
