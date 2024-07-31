#!/bin/bash
#SBATCH -J pretrain
#SBATCH --image=docker:wolanddream/python_mpi:lammps_hdf5
#SBATCH --module=mpich
#SBATCH --qos=debug
#SBATCH --time=00:30:00
#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -C cpu


srun -n 1 shifter mlp convert-cfg --input-format=vasp-outcar ../NVT/OUTCAR AIMD.cfg

python3 strip_conf.py

srun -n 128 --cpu-bind=cores --exclusive shifter mlp train init.mtp train.cfg --trained-pot-name=pot.mtp --max-iter=500

cp pot.mtp ../../stage-1/00
cp train.cfg ../../stage-1/00

cd ../../stage-1
sbatch job.sl
