from pathlib import Path

data_folder = Path("/home/bvermeulen/seismic_unix/ebn/line12/data/sps")
fname1 = data_folder / "L2EBN2020ASCAN012.sps"
fname2 = data_folder / "L2EBN2020ASCAN012.rps"
fname3 = data_folder / "L2EBN2020ASCAN012.xps"

fhand = open(fname1, encoding="latin-1")
sp = []
for line in fhand:
    line = line.strip()
    if not line.startswith("H"):
        list = sp.append(int(float((line[11:21]))))
sp.sort()

fhand = open(fname2, encoding="latin-1")
rp = []
for line in fhand:
    if not line.startswith("H"):
        line = line.strip()
        rp.append(int((float((line[11:21])))))
rp.sort()

fhand = open(fname3, encoding="latin-1")
xps = []
rcv_shot = []

for line in fhand:
    if not line.startswith("H"):
        line = line.strip()
        xps.append(int(line[8:15]))
        rcv_shot.append(int(line[43:48]) - int(line[38:43]) + 1)
xps.sort()

print("============= SPS FILE=============")
print("First Shot Point: ", sp[0])
print("Last Shot Point: ", sp[-1])
print("Total number of shots: ", len(sp))
print("============= RPS FILE=============")
print("First Receiver Point: ", rp[0])
print("Last Shot Point: ", rp[-1])
print("Total number of receivers: ", len(rp))
print("============= XPS FILE=============")
print("First Field File ID: ", xps[0])
print("Last Field File ID: ", xps[-1])
print("Total number of traces: ", f"{sum(rcv_shot):,}")
