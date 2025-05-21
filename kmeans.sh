#!/bin/bash

num_samples=10
num_dims=2

# accumulate random points in a flattened array
for ((i=0;i<$num_samples;i++));
do 
    for ((d=0;d<$num_dims;d++)); 
    do
        data[i*$num_dims+d]=$RANDOM
    done
done

k=2
# initialize k means as random data points
for ((i=0;i<$k;i++));
do
    # TODO: make sure that no 2 means are initialized to the same datapoint
    mean_index[i]=$RANDOM%$num_samples
    for ((d=0;d<$num_dims;d++));
    do
        means[i*$num_dims+d]=${data[${mean_index[i]}*$num_dims+d]}
    done
done

echo "Data"
echo ${data[@]}
echo "Means"
echo ${means[@]}

num_iterations=1000
for ((i=0;i<$num_iterations;i++));
do
    # TODO: first compute the assignments
    # TODO: then update the means
    # TODO: print the whole thing as it happens
done
