#!/bin/bash
#SBATCH -J mlip-Al_eDOS
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=regular
#SBATCH -N 2
#SBATCH --time=12:00:00
#SBATCH --exclusive
#SBATCH -C cpu

./run.sh
