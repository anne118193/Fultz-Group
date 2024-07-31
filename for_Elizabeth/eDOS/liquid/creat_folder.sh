#!/bin/bash


for i in {1..20}; do
	cp -r setup conf_$i
	cp confs/POSCAR_$i conf_$i/1/POSCAR
	cp confs/POSCAR_$i conf_$i/2/POSCAR
done
