#!/bin/bash
#SBATCH -J Al_VACF_lammps
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=regular
#SBATCH -N 2
#SBATCH --time=12:00:00
#SBATCH -C cpu

P=1 
seed=1

srun -n 256 --cpu-bind=cores shifter lmp_mpich -v SEED $seed -v P $P -in DOS.in > DOS.out
