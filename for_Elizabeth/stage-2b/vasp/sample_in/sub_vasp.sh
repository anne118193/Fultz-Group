#!/bin/bash


#module load vasp/6.3.2-cpu
#srun -n512 -c2 --cpu_bind=cores vasp_std

#module load vasp/6.3.2-gpu

#export OMP_NUM_THREADS=1
#export OMP_PLACES=threads
#export OMP_PROC_BIND=spread

#srun -n8 -c32 --cpu-bind=cores --gpu-bind=single:1 -G 8 --exclusive vasp_std

module load vasp/6.2.1-gpu

export OMP_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

srun -n 8 -c 32 --cpu-bind=cores --gpu-bind=none -G 8 --exclusive vasp_std
