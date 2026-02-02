"""convert velocities"""

from pathlib import Path
from dataclasses import dataclass

reversed = False


@dataclass
class Velocity_field:
    cdp: int = 0
    time: float = 0
    velocity: float = 0
    easting: float = 0
    northing: float = 0


base_folder = Path("/home/bvermeulen/seismic_unix/ebn/line12/data")
velocity_input_file = (
    base_folder / "velocities/L2EBN2020ASCAN012_RMS_velocities_stacking_ascii.txt"
)
velocity_output_file = base_folder / "velocities/vpick_su.txt"


def read_velocity_pick_generator(fname):
    with open(velocity_input_file, "rt", encoding="latin-1") as velfile:
        for line in velfile:
            yield line


def write_generator(fname):
    with open(fname, "w") as f:
        while True:
            record = yield
            f.write(record)


def parse_line(line):
    vel_field = Velocity_field()
    vel_field.cdp = int(line[15:20])
    vel_field.time = float(line[35:40]) * 0.001
    vel_field.velocity = float(line[60:65])
    vel_field.easting = float(line[65:72])
    vel_field.northing = float(line[72:80])
    return vel_field


velocity_picks = read_velocity_pick_generator(velocity_input_file)
write_record = write_generator(velocity_output_file)
write_record.send(None)
cdp_factor = 5796 / 23173  # <-- 10m / 20m <-- 2903 / 23173

vel_field = Velocity_field()
cdp_new = 0
line_out_cdp = ""
for line in velocity_picks:
    line = next(velocity_picks)
    if line[0:2] != "V2":
        continue

    vel_field = parse_line(line)
    cdp = int(vel_field.cdp * cdp_factor + 1000)
    if cdp != cdp_new:
        if cdp_new != 0:
            record1 = f"{line_cdp}\n{line_out_t_v_pair}\n"
            record2 = f"{line_out_tnmo} \\\n{line_out_vnmo} \\\n"
            line_out_cdp = ",".join([line_out_cdp, f"{cdp}"])
            print(record1)
            write_record.send(record2)

        else:
            line_out_cdp = f"{cdp}"

        line_cdp = f"cdp: {cdp}, {vel_field.easting:.0f}, {vel_field.northing:.0f}"
        line_out_tnmo = f"tnmo={vel_field.time:.3f}"
        line_out_vnmo = f"vnmo={vel_field.velocity:.0f}"
        line_out_t_v_pair = f"({vel_field.time:.3f}, {vel_field.velocity:.0f})"
        cdp_new = cdp

    else:
        line_out_tnmo = ",".join([line_out_tnmo, f"{vel_field.time:.3f}"])
        line_out_vnmo = ",".join([line_out_vnmo, f"{vel_field.velocity:.0f}"])
        line_out_t_v_pair = ", ".join(
            [line_out_t_v_pair, f"({vel_field.time:.3f}, {vel_field.velocity:.0f})"]
        )

record1 = f"{line_cdp}\n{line_out_t_v_pair}\n"
if not reversed:
    line_out_cdp = "".join(["cdp=", line_out_cdp, " \\\n"])

else:
    line_out_cdp = "".join(["cdp=", ",".join(line_out_cdp.split(",")[::-1]), " \\\n"])

print(record1)
print(line_out_cdp)
record2 = f"{line_out_tnmo} \\\n{line_out_vnmo} \\\n"
write_record.send(record2)
write_record.send(line_out_cdp)
