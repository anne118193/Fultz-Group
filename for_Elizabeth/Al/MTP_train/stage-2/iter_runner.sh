#!/bin/bash

dir=`pwd`

if [ -z "$1" ]; then
    echo "First argument should be the current interation number (starting from 1)"
    curr=`ls | grep -e "^[0-9]*\$" | tail -1`
    curr=$(( $curr+1 ))
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
cp $prev/train.cfg $curr/train.cfg

#
# Step D: DFT
# Input: $curr/C-selected.cfg
# Output: $curr/D-computed.cfg
#
echo ALCYCLE: Iteration $curr, Step D: DFT
rm vasp/in.cfg
cp $curr/train.cfg vasp/in.cfg
exec/dft_launch.sh
exec/dft_collect.sh
cp vasp/out.cfg $curr/D-computed.cfg

#
# Step E and F: merge and train
# Input: $prev/pot.mtp, $prev/train.cfg, $curr/D-computed.cfg
# Output: $curr/pot.mtp, $curr/train.cfg, 
#
echo ALCYCLE: Iteration $curr, Step E and F: merge and train
cp $curr/D-computed.cfg $curr/train.cfg
cp $curr/train.cfg $curr/E-train.cfg

# Local train:
# exec/mlp train $curr/pot.mtp $curr/train.cfg --trained-pot-name=$curr/pot.mtp --curr-pot-name= --max-iter=500
# Cluster train:
cp $prev/init.mtp train/
cp $curr/train.cfg train/
exec/train.sh
cp train/pot.mtp $curr/
grep -v "DAT Registry" train/train-output.txt > $curr/E-train-output.txt

cp $curr/pot.mtp $curr/E-pot.mtp

echo ALCYCLE: Iteration $curr end
