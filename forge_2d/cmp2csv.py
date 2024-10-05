import re
import csv
from pathlib import Path

basefolder = Path("/home/bvermeulen/Python/seismic_unix/forge_2d/data/su_results")
input_filename = basefolder / "cdp.log"
csv_filename_cmp = basefolder / "cmp_coords.csv"
cmp_0 = 1001  # default value from sucdpbin.c

with open(input_filename, "r") as ifile:
    input_lines = ifile.readlines()

cmp_dict = {}
for line in input_lines:
    if match := re.search(r"ibin=(\d+).*?x=(\d+\.\d+).*?y=(\d+\.\d+)", line):
        coords = (
            round(float(match.group(2))),
            round(float(match.group(3))),
        )
        cmp_dict[int(match.group(1)) + cmp_0] = coords

with open(csv_filename_cmp, "w") as ofile:
    csv_writer = csv.writer(ofile, delimiter=" ")
    for cdp, coords in cmp_dict.items():
        csv_writer.writerow([cdp, *coords])

print(f"number of cmp's: {len(cmp_dict)}")
