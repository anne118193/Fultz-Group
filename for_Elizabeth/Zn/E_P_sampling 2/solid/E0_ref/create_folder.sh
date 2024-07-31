#!/bin/bash

for j in {0..25}; do
    cp -r lammps_setup $j
    a=$(python -c "print('%.8f' % (2.600+0.0048*$j))")
    python ./gen_ortho_cell.py $a $j/supercell_lammps
done


