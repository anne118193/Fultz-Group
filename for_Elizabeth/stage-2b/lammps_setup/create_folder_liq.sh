#!/bin/bash

for i in {1..60}; do 
cp -r setup_liq B-lammps_liq_$i
sed -i "s|variable        seed equal 123461|variable        seed equal 12348$i|g" B-lammps_liq_$i/AL.in
done

for i in {0..2}; do
temp=$((600 + $i * 100))
for j in {0..4}; do
ctarg=$(python -c "print('%.3f' % (5.10+0.06*$j))")
for k in {0..3}; do
l=$(( $i * 5 * 4 + $j * 4 + $k + 1))
atarg=$(python -c "print('%.3f' % (2.65+0.02*$k))")
sed -i "s|variable        Ttarg equal 600|variable        Ttarg equal ${temp}|g" B-lammps_liq_$l/AL.in
sed -i "s|variable        atarg equal 2.67|variable        atarg equal ${atarg}|g" B-lammps_liq_$l/AL.in
sed -i "s|variable        ctarg equal 5.26|variable        ctarg equal ${ctarg}|g" B-lammps_liq_$l/AL.in
done
done
done
