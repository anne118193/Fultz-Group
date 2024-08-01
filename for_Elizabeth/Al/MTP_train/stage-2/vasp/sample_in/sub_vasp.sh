#!/bin/bash

module load vasp/6.3.2-cpu
srun -n256 -c2 --cpu_bind=cores vasp_std
