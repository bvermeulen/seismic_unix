import re
from pathlib import Path

basefolder = Path("/home/bvermeulen/seismic_unix/4dtest201/data/output")
input_filename = basefolder / "4dtest201_geometry.txt"
filename_src = basefolder / "4dtest201_coords_src.txt"
filename_rcv = basefolder / "4dtest201_coords_rcv.txt"

def write_src_generator(fname):
    with open(fname, "w") as outfile:
        while True:
            record = yield
            outfile.write(record)


def write_rcv_generator(fname):
    with open(fname, "w") as outfile:
        while True:
            record = yield
            outfile.write(record)

output_lines =[]
with open(input_filename, "r") as ifile:
    input_lines = ifile.readlines()
    for line in input_lines:
        output_lines.append(line.split())


src_set = set()
rcv_set = set()
for numbers in output_lines:
    src = (float(numbers[1]), float(numbers[2]))
    rcv = (float(numbers[6]), float(numbers[7]))
    src_set.add(src)
    rcv_set.add(rcv)

wg_rcv = write_rcv_generator(filename_rcv)
wg_rcv.send(None)
for v1, v2 in rcv_set:
    wg_rcv.send(
        f"{v1:10.1f} {v2:10.1f}\n"
    )

wg_src = write_src_generator(filename_src)
wg_src.send(None)
for v1, v2 in src_set:
    wg_src.send(f"{v1:10.1f} {v2:10.1f}\n")

print(f"sources: {len(src_set)}, recv: {len(rcv_set)}")
