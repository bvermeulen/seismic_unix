
suwind < data/line_001binned.su key=ep min=32 max=32 > data/data_geom_ep32.su
suxwigb < data/data_geom_ep32.su title="Ungained Data" &
sugain < data/data_geom_ep32.su scale=10.0 | suxwigb title="Scaled data" &
sugain < data/data_geom_ep32.su agc=1 wagc=.1 | suxwigb title="AGC=1 WAGC=.01 sec" &
sugain < data/data_geom_ep32.su agc=1 wagc=.5 | suxwigb title="AGC=1 WAGC=.5 sec" &
sugain < data/data_geom_ep32.su pbal=3 | suxwigb title="traces balanced by rms" &
sugain < data/data_geom_ep32.su qbal=3 | suxwigb title="traces balanced by quantile" &
sugain < data/data_geom_ep32.su mbal=3 | suxwigb title="traces balanced by mean" &
sugain < data/data_geom_ep32.su tpow=2 | suxwigb title="t squared factor applied" &
sugain < data/data_geom_ep32.su tpow=0.5 | suxwigb title="square root t factor applied" &