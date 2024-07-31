#!/bin/bash
#SBATCH -J Al_TDEP_lammps
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=debug
#SBATCH -N 1
#SBATCH --time=00:30:00
#SBATCH -C cpu

P=1 
seed=1

srun -n 128 --cpu-bind=cores shifter lmp_mpich -v SEED $seed -v P $P -in lammps.in > lammps.out
