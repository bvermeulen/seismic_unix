sunmo < data/line_001_sorted_fk.su vnmo=1700,2750,3000 tnmo=0.1,1.0,2.0 |
sugain \
	agc=1 \
	wagc=0.400 |
sustack > data/line_001_stack.su
suximage < data/line_001_stack.su key=cdp cmap=hsv0 title="Brute stack V0" perc=90
# for collor add: cmap=hsv4
