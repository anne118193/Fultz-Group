#!/bin/bash

# By default assume number of atoms is 1000 for each phase
T=$1
SYSTEM=Zn

cp -r setup ${T}K
sed -i "s|T=|T=${T}|g" ${T}K/liquid/job.sl
sed -i "s|T=|T=${T}|g" ${T}K/solid_melt/job.sl

sed -i "s|SYSTEM=|SYSTEM=${SYSTEM}|g" ${T}K/liquid/job.sl
sed -i "s|SYSTEM=|SYSTEM=${SYSTEM}|g" ${T}K/solid_melt/job.sl
