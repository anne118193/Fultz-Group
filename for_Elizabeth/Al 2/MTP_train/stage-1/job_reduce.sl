#!/bin/bash
#SBATCH -J Al_stage_1
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=regular
#SBATCH -N 2
#SBATCH --time=12:00:00
#SBATCH --exclusive
#SBATCH -C cpu

for j in `seq 1 1`; do ./master_iter.sh iter_reduce.sh; done
