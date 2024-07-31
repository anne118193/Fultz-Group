#!/bin/bash

for i in {1..60}; do 
cp -r setup_sol B-lammps_sol_$i
sed -i "s|variable        seed equal 12345|variable        seed equal 12347$i|g" B-lammps_sol_$i/AL.in
done

for i in {0..2}; do
temp=$((400 + $i * 100))
for j in {1..20}; do
l=$(( $i * 20 + $j))
sed -i "s|variable        T equal 1200|variable        T equal ${temp}|g" B-lammps_sol_$l/AL.in
cp cells/supercell_lammps_$j B-lammps_sol_$l/supercell_lammps
done
done
