import numpy as np
import random
import os
import sys
import time
import subprocess as sp
from run_sim import gen_job_lines

random.seed(32)

T = np.linspace(400, 550, 4)
c_a_ratio = 1.9516385330561992 # fixed c/a ratio
V = np.sqrt(3)/2*np.linspace(2.6,2.72, 5)**3*c_a_ratio # prim uc
N  = [4, 5, 6, 7]

data = [[t, v, 5, random.choice(N), 1] for t in T for v in V]

header = """#!/bin/bash
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --qos=regular
#SBATCH -N 1
#SBATCH --time=12:00:00
#SBATCH --ntasks-per-node=128
#SBATCH --exclusive
#SBATCH -C cpu\n\n"""

lines = gen_job_lines(data, 4800000)
for i in range(len(lines)//2):
    with open(f"job_{i+1}.sl", 'w') as f:
        f.write(header)
        f.write('\n'.join(lines[i*2:(i+1)*2]))

