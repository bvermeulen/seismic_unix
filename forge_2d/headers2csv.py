import re
import csv
from pathlib import Path

basefolder = Path("/home/bvermeulen/Python/seismic_unix/forge_2d/data/su_results")
input_filename = basefolder / "line1_coords.txt"
csv_filename_coords = basefolder / "line1_coords.csv"
csv_filename_src = basefolder / "line1_coords_src.csv"
csv_filename_rcv = basefolder / "line1_coords_rcv.csv"
scale_factor = 0.10


with open(input_filename, "r") as ifile:
    input_lines = ifile.readlines()

output_lines = []
for line in input_lines:
    if numbers := re.findall(r"\d+", line):
        output_lines.append(numbers)

src_set = set()
rcv_set = set()
with open(csv_filename_coords, "w") as ofile:
    csv_writer = csv.writer(ofile, delimiter=" ")
    row_count = 0
    for numbers in output_lines:
        numbers = [numbers[0]] + [round(int(n)*scale_factor) for n in numbers[1:]]
        csv_writer.writerow(numbers)
        row_count += 1

        src = (numbers[1], numbers[2])
        rcv = (numbers[3], numbers[4])
        src_set.add(src)
        rcv_set.add(rcv)

src_list = sorted(list(src_set), key=lambda tup: tup[0])
rcv_list = sorted(list(rcv_set), key=lambda tup: tup[0])

with open(csv_filename_src, "w") as ofile:
    csv_writer = csv.writer(ofile, delimiter=" ")
    for numbers in src_list:
        csv_writer.writerow(numbers)

with open(csv_filename_rcv, "w") as ofile:
    csv_writer = csv.writer(ofile, delimiter=" ")
    for numbers in rcv_list:
        csv_writer.writerow(numbers)

print(f"traces: {row_count}, sources: {len(src_list)}, recv: {len(rcv_list)}")
