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
shifter mlp calc-grade $prev/pot.mtp $prev/train.cfg $prev/train.cfg $curr/temp.cfg --als-filename=$curr/A-state.als
rm $curr/temp.cfg
cp $prev/pot.mtp $curr/pot.mtp


#
# Step B1
# Input: supercell_lammps_*, 
# Output: 
# 

cd $dir/lammps_setup
cp $dir/$curr/pot.mtp setup_sol
cp $dir/$curr/A-state.als setup_sol

cp $dir/$curr/pot.mtp setup_liq
cp $dir/$curr/A-state.als setup_liq

./create_folder_sol.sh
./create_folder_liq.sh
cd $dir

#
# Step B2
# Input: $prev/pot.mtp $curr/A-state.als, 
# Output: $curr/B-preselected.cfg
# 
echo ALCYCLE: Iteration $curr, Step B: LAMMPS
mv lammps_setup/B-lammps_* $curr/
#cp lammps_setup/AL.sl $curr/
cd $curr
#sbatch AL.sl
#../exec/swait-for.sh mlip-AL_Zn_PBE

for i in {1..60}; do
	cd B-lammps_sol_$i
	srun -N 1 -n 1 -c 1 --mem=1952 --exclusive --gres=craynetwork:0 shifter lmp_mpich -in AL.in >B-lammps-log.txt &
	cd ../
done

for i in {1..60}; do
        cd B-lammps_liq_$i
        srun -N 1 -n 1 -c 1 --mem=1952 --exclusive --gres=craynetwork:0 shifter lmp_mpich -in AL.in >B-lammps-log.txt &
        cd ../
done

wait


cat B-lammps*/B-preselected.cfg >>B-preselected.cfg
cd $dir

#
# Step C
# Input: $prev/pot.mtp, $prev/train.cfg, $curr/B-preselected.cfg
# Output: $curr/C-selected.cfg
#
echo ALCYCLE: Iteration $curr, Step C: select
shifter mlp select-add $prev/pot.mtp $prev/train.cfg $curr/B-preselected.cfg $curr/C-selected.cfg
rm selected.cfg state.als # remove files created by select-add

#
# Step D: DFT
# Input: $curr/C-selected.cfg
# Output: $curr/D-computed.cfg
#
echo ALCYCLE: Iteration $curr, Step D: DFT
rm vasp/in.cfg
cp $curr/C-selected.cfg vasp/in.cfg


#exec/dft_launch.sh
sbatch job_vasp.sl

