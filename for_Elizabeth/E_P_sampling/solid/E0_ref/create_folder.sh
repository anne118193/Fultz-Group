#!/bin/bash

for j in {0..25}; do
cp -r lammps_setup $j
lat_param=$(python -c "print('%.8f' % (4.100+0.001*$j))")
half=$(python -c "print('%.8f' % ((4.100+0.001*$j)/2))")
sed -i "s|lat_param|${lat_param}|g" $j/supercell_lammps
sed -i "s|half|${half}|g" $j/supercell_lammps
done
