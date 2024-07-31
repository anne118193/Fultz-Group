#!/bin/bash
#SBATCH -J Zn_PBE_vasp
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

for el in {36..51}; do
        cp -r sample_in dir_POSCAR$el
        cp POSCAR$el dir_POSCAR$el/POSCAR
        cd dir_POSCAR$el
        ./sub_vasp.sh
        cd ../
done

for el in {4..9}; do
	cp -r sample_in dir_POSCAR$el
	cp POSCAR$el dir_POSCAR$el/POSCAR
	cd dir_POSCAR$el
	./sub_vasp.sh
	cd ../
done
