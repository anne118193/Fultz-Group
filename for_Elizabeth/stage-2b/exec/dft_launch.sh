#!/bin/bash

dir=`pwd`

cd vasp

rm -r dir_POSCAR*
rm POSCAR*

shifter mlp convert-cfg in.cfg POSCAR --output-format=vasp-poscar
for f in POSCAR*; do
  mkdir dir_$f;
  cp sample_in/* dir_$f/
  cp $f dir_$f/POSCAR
  cd dir_$f
  ./sub_vasp.sh
  cd $dir/vasp
done

cd $dir
