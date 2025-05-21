#!/bin/bash

num_samples=10
num_dims=2

# accumulate random points in a flattened array
# TODO: use a Z table to sample from normal distributions
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

num_iterations=10
for ((i=0;i<$num_iterations;i++));
do
    # TODO: first compute the assignments
    # TODO: then update the means
    # TODO: print the whole thing as it happens
    declare -a num_assignments=( $(for ((j=0;j<$k;j++)); do echo 0; done) )
    for ((j=0;j<$num_samples;j++));
    do
        # initialize min_distance and assignment
        min_distance=-1
        assignment=-1
        for ((l=0;l<$k;l++));
        do
            distance[k]=0
        done
    done
    echo "Iteration ${i}:"
    echo "Means:"
    echo ${means[@]}
done
