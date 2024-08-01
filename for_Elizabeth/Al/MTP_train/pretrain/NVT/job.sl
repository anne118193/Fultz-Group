#!/bin/bash
#SBATCH --job-name=NVT_Al
#SBATCH -A m2129
#SBATCH -q debug
#SBATCH -t 00:30:00        
#SBATCH -N 2          
#SBATCH -C cpu
#SBATCH --exclusive

module load vasp/6.3.2-cpu
srun -n256 -c2 --cpu_bind=cores vasp_gam
