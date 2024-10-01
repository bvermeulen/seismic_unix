import csv
from pathlib import Path

basefolder = Path("/home/bvermeulen/Python/seismic_unix/forge_2d/data")
input_filename_rcv = basefolder / "NA83_receiver.sp1"
input_filename_src = basefolder / "NAD93_source.sp1"

csv_filename_src = basefolder / "su_results/sp1_src.csv"
csv_filename_rcv = basefolder / "su_results/sp1_rcv.csv"
scale_factor = 1.0

with open(input_filename_src, "r", encoding="latin1") as ifile:
    input_lines = ifile.readlines()

output_lines = []
for line in input_lines:
    if line[0] == " ":
        x_coord = round(float(line[46:53]) * scale_factor)
        y_coord = round(float(line[53:61]) * scale_factor)
        elevation = round(float(line[61:67]) * scale_factor)
        output_lines.append([x_coord, y_coord, elevation])
nsrc = len(output_lines)

with open(csv_filename_src, "w") as ofile:
    csv_writer = csv.writer(ofile, delimiter=" ")
    for numbers in output_lines:
        csv_writer.writerow(numbers)

with open(input_filename_rcv, "r", encoding="latin1") as ifile:
    input_lines = ifile.readlines()

output_lines = []
for line in input_lines:
    if line[0] == " ":
        x_coord = round(float(line[46:53]) * scale_factor)  # 7 char
        y_coord = round(float(line[53:61]) * scale_factor)  # 8 char
        elevation = round(float(line[61:67]) * scale_factor)  # 6 char
        output_lines.append([x_coord, y_coord, elevation])
nrcv = len(output_lines)

with open(csv_filename_rcv, "w") as ofile:
    csv_writer = csv.writer(ofile, delimiter=" ")
    for numbers in output_lines:
        csv_writer.writerow(numbers)

print(f"sp1 reading complted: sources: {nsrc}, receivers: {nrcv}")
