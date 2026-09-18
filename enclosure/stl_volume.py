#!/usr/bin/env python3
"""Print the enclosed volume of an STL, in mm^3.

Used by build.sh to check the "must be empty" intersections: OpenSCAD reports
coincident faces as a degenerate solid rather than as nothing at all, so the
test is that the result has no volume, not that it has no facets.

    stl_volume.py FILE [MAX]   exit 1 if the volume is above MAX (default 0.01)

Missing files are errors. The caller must distinguish a confirmed empty
OpenSCAD result from a failed render before calling this script.
"""
import re
import struct
import sys


def read_stl(path):
    data = open(path, 'rb').read()
    if len(data) >= 84 and not re.match(rb'\s*solid', data[:16]):
        n = struct.unpack('<I', data[80:84])[0]
        return [struct.unpack('<12f', data[84 + i * 50:132 + i * 50])[3:12]
                for i in range(n)]
    v = [float(c) for m in re.finditer(rb'vertex\s+(\S+)\s+(\S+)\s+(\S+)', data)
         for c in m.groups()]
    return [v[i:i + 9] for i in range(0, len(v) - 8, 9)]


def volume(tris):
    total = 0.0
    for t in tris:
        ax, ay, az, bx, by, bz, cx, cy, cz = t
        total += (ax * (by * cz - cy * bz)
                  - ay * (bx * cz - cx * bz)
                  + az * (bx * cy - cx * by)) / 6.0
    return abs(total)


def main(argv):
    path = argv[1]
    limit = float(argv[2]) if len(argv) > 2 else 0.01
    vol = volume(read_stl(path))
    print(f"{vol:.4f}")
    return 1 if vol > limit else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
