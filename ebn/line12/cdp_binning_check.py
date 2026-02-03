from dataclasses import dataclass
from pathlib import Path


@dataclass
class CdpLine:
    cdp: int = 0
    easting: float = 0.0
    northing: float = 0.0
    fold: int = 0


data_folder = Path("/home/bvermeulen/seismic_unix/ebn/line12/data/output")
inputfile = data_folder / "cdp.log"
outputfile = data_folder / "cdp.csv"


def parse(line):
    cdp_line = CdpLine()
    if not line[0:8] == "sucdpbin":
        return None
    
    try:
        cdp_line.cdp = int(line[19:24])

    except ValueError:
        return None
    
    cdp_line.easting = float(line[26:32])
    cdp_line.northing = float(line[34:40])
    cdp_line.fold = int(line[52:60])
    return cdp_line


cdp_records = []
with open(inputfile, mode="rt", encoding="latin-1") as fhandle:
    for line in fhandle:
        cdp_line = parse(line)
        if cdp_line:
            cdp_records.append(cdp_line)

with open(outputfile, mode="wt") as fhandle:
    line = "cdp, fold, easting, northing\n"
    fhandle.write(line)
    for record in cdp_records:
        line = f"{record.cdp}, {record.fold}, {record.easting:.1f}, {record.northing:.1f}\n"
        fhandle.write(line)
