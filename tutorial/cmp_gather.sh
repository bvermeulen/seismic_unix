suwind key=cdp min=$1 max=$1 < data/line_001sorted.su | suximage key=offset d2=100 cmap=hsv0 perc=90 verbose=1 \
   title="shot $1 after geometry" label1="Time (s)" label2="Offset (m)"
