#!/bin/bash
#SBATCH -J mlip-Zn_vasp
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH -A m2129_g
#SBATCH -q regular
#SBATCH -t 12:00:00        
#SBATCH -N 2        
#SBATCH -C gpu&hbm80g
#SBATCH --ntasks-per-node=4
#SBATCH -c 32
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=none
#SBATCH --exclusive

export SLURM_CPU_BIND="cores"
exec/dft_launch.sh

#sbatch job_finish.sl
