#!/bin/bash
#SBATCH -J Zn_liquid
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5_gle
#SBATCH --qos=debug
#SBATCH -N 1
#SBATCH --time=00:30:00
#SBATCH --ntasks-per-node=128
#SBATCH --exclusive
#SBATCH -C cpu

SYSTEM=

T=
P=1 
N=8000
seed=1

srun -n 128 --cpu-bind=cores shifter lmp_mpich -v SEED $seed -v T $T -v P $P -v N $N -v LABEL ${SYSTEM}_${P}_${N} -v RUNSTEPS 1e7 -in in.liquid > liquid.out
