suwind key=cdp min=$1 max=$1 < data/line_001sorted.su | suximage key=offset cmap=hsv4 perc=90 \
   title="shot $1 after geometry" label1="Time(s)" label2="Offsset(m)"
