#!/bin/bash

dir=`pwd`

if [ -z "$1" ]; then
    echo "First argument should be the current interation number (starting from 1)"
    curr=`ls | grep -e "^[0-9]*\$" | wc -l`
else
    curr=$1
fi

echo ALCYCLE: Iteration $curr begin

prev=$(( $curr-1 ))

prev=`printf "%02d" $prev`
curr=`printf "%02d" $curr`

mkdir $curr

#
# Step A
# Input: $prev/pot.mtp, $prev/train.cfg
# Output: $curr/A-state.als
#
echo ALCYCLE: Iteration $curr, Step A: calc-grade
shifter mlp calc-grade $prev/pot.mtp $prev/train.cfg $prev/train.cfg $curr/temp.cfg --als-filename=$curr/A-state.als
rm $curr/temp.cfg
cp $prev/pot.mtp $curr/pot.mtp

#
# Step B
# Input: $prev/pot.mtp $curr/A-state.als, 
# Output: $curr/B-preselected.cfg
# 
echo ALCYCLE: Iteration $curr, Step B: LAMMPS
cp lammps_setup/mlip.ini $curr/
cp lammps_setup/supercell_lammps $curr/
cd $curr
shifter lmp_mpich -v SEED 1 -v T 900 -v latparam 4.10 -v size 3 -log none -in $dir/lammps_setup/AL.in >B-lammps-log.txt 2>&1
cd $dir

#
# Step C
# Input: $prev/pot.mtp, $prev/train.cfg, $curr/B-preselected.cfg
# Output: $curr/C-selected.cfg
#
echo ALCYCLE: Iteration $curr, Step C: select
srun -N 1 -n 1 --cpu-bind=cores shifter mlp select-add $prev/pot.mtp $prev/train.cfg $curr/B-preselected.cfg $curr/C-selected.cfg
rm selected.cfg state.als # remove files created by select-add

#
# Step D: DFT
# Input: $curr/C-selected.cfg
# Output: $curr/D-computed.cfg
#
echo ALCYCLE: Iteration $curr, Step D: DFT
rm vasp/in.cfg
cp $curr/C-selected.cfg vasp/in.cfg
exec/dft_launch.sh
exec/dft_collect.sh
cp vasp/out.cfg $curr/D-computed.cfg

#
# Step E and F: merge and train
# Input: $prev/pot.mtp, $prev/train.cfg, $curr/D-computed.cfg
# Output: $curr/pot.mtp, $curr/train.cfg, 
#
echo ALCYCLE: Iteration $curr, Step E and F: merge and train
cat $prev/train.cfg $curr/D-computed.cfg >>$curr/train.cfg
cp $curr/train.cfg $curr/E-train.cfg

# Local train:
# exec/mlp train $curr/pot.mtp $curr/train.cfg --trained-pot-name=$curr/pot.mtp --curr-pot-name= --max-iter=500
# Cluster train:
cp $curr/pot.mtp train/
cp $curr/train.cfg train/
exec/train.sh
cp train/pot.mtp $curr/
grep -v "DAT Registry" train/train-output.txt > $curr/E-train-output.txt

cp $curr/pot.mtp $curr/E-pot.mtp

echo ALCYCLE: Iteration $curr end
