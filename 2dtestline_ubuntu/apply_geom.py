from pathlib import Path
import math

data_folder = Path("/home/bvermeulen/Development/seismic_unix/2dtestline_ubuntu/data")
rps_fname = data_folder / "sps" / "20250804_sps.r"
sps_fname = data_folder / "sps" / "20250804_sps.s"
xps_fname = data_folder / "sps" / "20250804_sps.x"
geometry_fname = data_folder / "output" / "20250804_geometry.txt"

nrcv = 201  # total number of receivers
nsrc = 201  # total number of source points
ttrc = 40401  # total number of traces
ntrc = ttrc // nsrc  # traces per source point
r_step = 8


def write_generator(fname):
    with open(fname, "w") as f:
        while True:
            record = yield
            f.write(record)


# ============================ WORK ON SPS ==========================================================
# Read each SPS file separately, create lists
sp = []
sx = []
sy = []
selev = []
sstat = []
fhand = open(sps_fname)
for line in fhand:
    if not line.startswith("H26"):
        sp.append(int(float(line[11:21])))
        sx.append(float(line[46:55]))
        sy.append(float(line[55:65]))
        selev.append(float(line[65:71]))
        sstat.append(0 if line[28:32] == "    " else float(line[28:32]))

fhand.close()
dict_sx = {p: val for p, val in zip(sp, sx)}
dict_sy = {p: val for p, val in zip(sp, sy)}
dict_selev = {p: val for p, val in zip(sp, selev)}
dict_sstat = {p: val for p, val in zip(sp, sstat)}
dict_sps = {"sp": sp, "sx": sx, "sy": sy}

# ============================ WORK ON RPS ==========================================================
rp = []
rx = []
ry = []
relev = []
rstat = []
fhand = open(rps_fname)
for line in fhand:
    if not line.startswith("H26"):
        line = line.strip()
        rp.append(int(float(line[11:21])))
        rx.append(float(line[46:55]))
        ry.append(float(line[55:65]))
        relev.append(float(line[65:71]))
        rstat.append(0 if line[28:32] == "    " else float(line[28:32]))

fhand.close()
dict_relev = {p: val for p, val in zip(rp, relev)}
dict_rstat = {p: val for p, val in zip(rp, rstat)}
dict_rx = {p: val for p, val in zip(rp, rx)}
dict_ry = {p: val for p, val in zip(rp, ry)}
dict_rps = {"rp": rp, "rx": rx, "ry": ry}

# ============================ WORK ON XPS ==========================================================
xp = []
r1 = []
r2 = []
fhand = open(xps_fname)
for line in fhand:
    if not line.startswith("H26"):
        line = line.strip()
        xp.append(int(float(line[27:37])))
        r1.append(int(float(line[59:69])))
        r2.append(int(float(line[69:79])))

dict_xps = {"xp": xp, "ch_from": r1, "ch_to": r2}
dict_xps2 = {p: [*range(r1_val, r2_val + 1, r_step)] for p, r1_val, r2_val in zip(xp, r1, r2)}

# INDEX of VP 701 (dict_xps2[int(dict_xps['vp'][i])][0])
"""
=====================================================================
Calculate the offset matrix for each VP corresponding to all traceso
collaborated to that particular VP
=====================================================================
"""
trace_record = []
write_record = write_generator(geometry_fname)
write_record.send(None)
cdp_count = {cdp: 0 for cdp in range(1000,1402)}
for i in range(nsrc):
    for j in range(ntrc):
        if (
            dict_xps["xp"][i] in sp and
            dict_xps["ch_from"][i] in rp and
            dict_xps["ch_to"][i] in rp
        ):
            rp_val = dict_xps2[dict_xps["xp"][i]][j]
            rx_val = dict_rx[dict_xps2[dict_xps["xp"][i]][j]]
            ry_val = dict_ry[dict_xps2[dict_xps["xp"][i]][j]]
            relev_val = dict_relev[dict_xps2[dict_xps["xp"][i]][j]]
            rstat_val = dict_rstat[dict_xps2[dict_xps["xp"][i]][j]]

            ep_val = dict_xps["xp"][i]
            sx_val = dict_sx[dict_xps["xp"][i]]
            sy_val = dict_sy[dict_xps["xp"][i]]
            selev_val = dict_selev[dict_xps["xp"][i]]
            sstat_val = dict_sstat[dict_xps["xp"][i]]

            offset_val = math.sqrt(
                (rx_val - sx_val)**2 + (ry_val - sy_val)**2
            )
            if dict_xps["xp"][i] > dict_xps2[dict_xps["xp"][i]][j]:
                offset_val = -offset_val


            cdp = int(((ep_val+rp_val)*0.5 - 5553)*0.25) + 1001
            cdp_count[cdp] += 1
            write_record.send(
                f"{ep_val:6} "
                f"{sx_val:10.1f} "
                f"{sy_val:10.1f} "
                f"{selev_val:5.1f} "
                f"{sstat_val:3.1f} "
                f"{rp_val:6} "
                f"{rx_val:10.1f} "
                f"{ry_val:10.1f} "
                f"{relev_val:5.1f} "
                f"{rstat_val:3.1f} "
                f"{offset_val:6.1f}"
                f"{cdp:6}\n"
            )

"""
=====================================================================
Print the CPD count
=====================================================================
"""
for cdp, count in cdp_count.items():
    print(f"cdp {cdp:6}, bin count: {count:6}")
