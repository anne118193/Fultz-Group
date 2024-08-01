#!/bin/bash

jobs_left=`squeue -n $1 | grep -v JOBID | wc -l`;
wait_time=1
while( (( $jobs_left > 0 )) ); do
echo Jobs left: $jobs_left
sleep $wait_time
if [ $wait_time -lt 10 ]; then wait_time=$(( $wait_time+1 )); fi
jobs_left=`squeue -n $1 | grep -v JOBID | wc -l`;
done
