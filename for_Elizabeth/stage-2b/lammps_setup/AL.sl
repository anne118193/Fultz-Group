#!/bin/bash
#SBATCH -J mlip-AL_Zn_PBE
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=debug
#SBATCH -N 1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH -C cpu
#SBATCH -L SCRATCH


for i in {1..80}; do
cd B-lammps_sol_$i
srun -N 1 -n 1 -c 1 --mem=1952 --exclusive --gres=craynetwork:0 shifter lmp_mpich -in AL.in >B-lammps-log.txt &
cd ../
done

wait
