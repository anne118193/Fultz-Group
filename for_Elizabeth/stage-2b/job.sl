#!/bin/bash
#SBATCH -J Zn_stage_2b
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=debug
#SBATCH -N 1
#SBATCH --time=00:30:00
#SBATCH --exclusive
#SBATCH -C cpu


./master_iter.sh iter_runner.sh

#for j in `seq 42 42`; do ./master_iter.sh iter_reduce.sh; done
