import numpy as np
import os

# Script need python3 with numpy installed
def strip_confs_cfg(file, start, n_strip = 1, output = "out.cfg"):
    if not os.path.exists(file):
        raise FileNotFoundError
    confs = []
    with open(file, 'r') as f:
        for s in f:
            if s == "BEGIN_CFG\n":
                confs.append([])
            confs[len(confs) - 1].append(s)

    with open(output, 'w') as out:
        out_confs = confs[start::n_strip]
        for conf in out_confs:
            for s in conf:
                out.write(s)

    return confs

folder = "."

confs = strip_confs_cfg(f"{folder}/AIMD.cfg", 0, 100, output = f"{folder}/train.cfg")
