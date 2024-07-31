#!/bin/bash
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --qos=debug
#SBATCH -N 1
#SBATCH --time=00:30:00
#SBATCH --ntasks-per-node=128
#SBATCH --exclusive
#SBATCH -C cpu

for j in {0..25}; do
cd $j
shifter lmp_mpich -in E0_ref.in
cd ../
done
