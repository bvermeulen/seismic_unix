from dataclasses import dataclass
from pathlib import Path

@dataclass
class CdpLine:
    easting_gp: float = 0.0
    northing_gp: float = 0.0
    cdp: int = 0

@dataclass
class CdpRecord:
    fold: int = 0
    easting: float = 0.0
    northing: float = 0.0


data_folder = Path("/home/bvermeulen/seismic_unix/ebn/line12/data/output")
inputfile = data_folder / "line12_geometry_2.txt"
outputfile = data_folder / "cdp_values_10.csv"


def parse(line):
    cdp_line = CdpLine()
    values = line.split()
    easting_ep = float(values[1])
    northing_ep = float(values[2])
    easting_gp = float(values[6])
    northing_gp = float(values[7])
    cdp_line.cdp = int(values[11])
    cdp_line.easting = (easting_ep + easting_gp) * 0.5
    cdp_line.northing = (northing_ep + northing_gp) * 0.5
    return cdp_line

cdp_line = CdpLine()
cdp_dict = {}
with open(inputfile, mode="rt", encoding="latin-1") as fhandle:
    for line in fhandle:
        cdp_line = parse(line)
        cdp = cdp_line.cdp
        if cdp not in cdp_dict:
            cdp_dict[cdp] = CdpRecord()
            cdp_dict[cdp].fold = 1
            cdp_dict[cdp].easting= cdp_line.easting
            cdp_dict[cdp].northing = cdp_line.northing

        else:
            cdp_dict[cdp].fold += 1
            cdp_dict[cdp].easting += (cdp_line.easting - cdp_dict[cdp].easting) / cdp_dict[cdp].fold
            cdp_dict[cdp].northing += (cdp_line.northing - cdp_dict[cdp].northing) / cdp_dict[cdp].fold


with open(outputfile, mode="wt") as fhandle:
    line = "cdp, fold, easting, northing\n"
    fhandle.write(line)
    for cdp, record in cdp_dict.items():
        line = f"{cdp}, {record.fold}, {record.easting:.1f}, {record.northing:.1f}\n"
        fhandle.write(line)
