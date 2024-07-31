#!/bin/bash

module load vasp/6.3.2-cpu

for i in {1..20}; do
	cd conf_$i
	
	cd 1
	srun -n256 -c2 --cpu_bind=cores vasp_std

	cp CHGCAR ../2 
	cd ../2
	srun -n256 -c2 --cpu_bind=cores vasp_std
	cd ../

	cd ../
done
