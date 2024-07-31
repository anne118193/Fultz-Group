#!/bin/bash
#SBATCH -J Zn_liquid
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5_gle
#SBATCH --qos=regular
#SBATCH -N 1
#SBATCH --time=12:00:00
#SBATCH --ntasks-per-node=128
#SBATCH --exclusive
#SBATCH -C cpu

SYSTEM=Zn

T=500
P=1 
N=216000
seed=1

srun -n 128 --cpu-bind=cores shifter lmp_mpich -v SEED $seed -v T $T -v P $P -v N $N -v LABEL ${SYSTEM}_${P}_${N} -v RUNSTEPS 1e7 -in DOS.in > DOS.out
