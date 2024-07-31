#!/bin/bash
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=regular
#SBATCH -N 2
#SBATCH --time=12:00:00
#SBATCH -C cpu

T="887.3"
P=1 
N=32000
seed=1
REF_LIQ="-4.07"

srun -n 256 --cpu-bind=cores shifter lmp_mpich -v SEED $seed -v T $T -v P $P -v N $N -v REF_LIQ ${REF_LIQ} -v LABEL Al_${P}_${N} -v RUNSTEPS 1e7 -in in.solid > solid.out
