#!/bin/bash

for i in {1..60}; do 
cp -r setup_liq B-lammps_liq_$i
sed -i "s|variable        seed equal 123461|variable        seed equal 12348$i|g" B-lammps_liq_$i/AL.in
done

for i in {0..4}; do
temp=$((700 + $i * 100))
for j in {0..11}; do
l=$(( $i * 12 + $j + 1))
atarg=$(python -c "print('%.3f' % (4.000 + 0.025*$j))")
sed -i "s|variable        Ttarg equal 600|variable        Ttarg equal ${temp}|g" B-lammps_liq_$l/AL.in
sed -i "s|variable        atarg equal 4.100|variable        atarg equal ${atarg}|g" B-lammps_liq_$l/AL.in
done
done
