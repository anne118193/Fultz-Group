#!/bin/bash

# Use this script after computing liquid to create folders 
# for statistics collection of melting

REF_LIQ=`tail -2 ./liquid/liquid.out | head -n 1 | grep -Eo "[+-]?[0-9]+([.][0-9]+)?"`

for i in {1..8}; do
        cp -r solid_melt $i
	sed -i "s|seed=1|seed=$i|g" $i/job.sl
        sed -i "s|REF_LIQ=|REF_LIQ=${REF_LIQ}|g" $i/job.sl
        cd $i
	sbatch job.sl
	cd ../
done
