#!/bin/bash
  
dir=`pwd`

cd train

srun -n 256 --cpu-bind=cores shifter mlp train pot.mtp train.cfg --trained-pot-name=pot.mtp --max-iter=1000 >train-output.txt
#sbatch sub_train.sh
#../exec/swait-for.sh train

cd $dir
