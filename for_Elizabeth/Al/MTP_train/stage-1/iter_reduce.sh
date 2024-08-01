#!/bin/bash

dir=`pwd`

if [ -z "$1" ]; then
    echo "First argument should be the current interation number (starting from 1)"
    curr=`ls | grep -e "^[0-9]*\$" | tail -1`
    curr=$(( $curr+1 ))
else
    curr=$1
fi

echo REDUCE-TRAIN: Iteration $curr begin

prev=$(( $curr-1 ))

prev=`printf "%02d" $prev`
curr=`printf "%02d" $curr`

mkdir $curr

#
# Step A
# Input: $prev/pot.mtp, $prev/train.cfg
# Output: $curr/A-state.als
#
touch $curr/empty.cfg
shifter mlp select-add $prev/pot.mtp $curr/empty.cfg $prev/train.cfg $curr/train.cfg --als-filename=$curr/unused.als
rm $curr/temp.cfg
cp $prev/pot.mtp $curr/pot.mtp

echo REDUCE-TRAIN: Iteration $curr end
