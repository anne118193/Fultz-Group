#!/bin/bash
#SBATCH -J Al_train
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=debug
#SBATCH -N 1
#SBATCH --time=00:30:00
#SBATCH --exclusive
#SBATCH -C cpu


for j in `seq 59 59`; do ./master_iter.sh iter_reduce.sh; done
