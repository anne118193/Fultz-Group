#!/bin/bash

dir=`pwd`

cd train

srun -n 256 --cpu-bind=cores shifter mlp train pot.mtp train.cfg --trained-pot-name=pot.mtp --max-iter=500 >train-output.txt

cd $dir
