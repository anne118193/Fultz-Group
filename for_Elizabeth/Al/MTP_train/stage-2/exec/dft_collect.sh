#!/bin/bash

dir=`pwd`

cd vasp

rm out.cfg
for f in POSCAR*; do
   shifter mlp convert-cfg dir_$f/OUTCAR out.cfg --input-format=vasp-outcar --append
#  rm -r dir_$f
done
shifter mlp filter-nonconv out.cfg

cd $dir
