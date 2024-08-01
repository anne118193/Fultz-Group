#!/bin/bash

dir=`pwd`

curr=`ls | grep -e "^[0-9]*\$" | wc -l`

./$1 $curr >iter-output.txt 2>&1

curr=`printf "%02d" $curr`

mv iter-output.txt $curr/
cp $1 $curr/
