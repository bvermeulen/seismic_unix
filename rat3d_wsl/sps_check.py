from pathlib import Path

data_folder = Path("/home/bvermeulen/Python/seismic_unix/rat3d/data/202505test_sps")
fname1 = data_folder / "202505.S"
fname2 = data_folder / "202505.R"
fname3 = data_folder / "202505.X"

fhand = open(fname1)
sp = []
for line in fhand:
    line = line.strip()
    if not line.startswith("H26"):
        list = sp.append(int(float((line[11:21]))))
sp.sort()

fhand = open(fname2)
rp = []
for line in fhand:
    if not line.startswith("H26"):
        line = line.strip()
        rp.append(int((float((line[11:21])))))
rp.sort()

fhand = open(fname3)
xps = []
rcv_shot = []

for line in fhand:
    if not line.startswith("H26"):
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
print("Total number of traces: ", sum(rcv_shot))
