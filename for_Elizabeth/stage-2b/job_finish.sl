#!/bin/bash
#SBATCH -J Zn_stage_2b_finish
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=debug
#SBATCH -N 1
#SBATCH --time=00:30:00
#SBATCH --exclusive
#SBATCH -C cpu


./master_iter.sh iter_finish.sh 

sbatch job.sl
