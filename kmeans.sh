#!/bin/bash

num_samples=500
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
    # make sure that no 2 means are initialized to the same datapoint
    index=$RANDOM%$num_samples
    while [[ ${hm[$index]} ]]; do index=$RANDOM%$num_samples; done
    mean_index[i]=$index
    hm[$index]=1
    for ((d=0;d<$num_dims;d++));
    do
        means[i*$num_dims+d]=${data[${mean_index[i]}*$num_dims+d]}
    done
done

echo "Data"
echo ${data[@]}
echo "Means"
echo ${means[@]}

scale=8

num_iterations=10
for ((i=0;i<$num_iterations;i++));
do
    # initialize new means
    for ((j=0;j<$k;j++));
    do
        for ((l=0;l<$num_dims;l++));
        do
            new_means[j*$num_dims+l]=0
        done
    done
    declare -a num_assignments=( $(for ((j=0;j<$k;j++)); do echo 0; done) )
    for ((j=0;j<$num_samples;j++));
    do
        # initialize min_distance and assignment
        min_distance=-1
        for ((l=0;l<$k;l++));
        do
            distance[l]=0
            for ((d=0;d<$num_dims;d++));
            do
                if (( $(echo "${means[l*$num_dims+d]}>${data[j*$num_dims+d]}" | bc) )); then
                    distance[l]=$(echo "scale=$scale;${distance[l]}+${means[l*$num_dims+d]}-${data[j*$num_dims+d]}" | bc)
                else
                    distance[l]=$(echo "scale=$scale;${distance[l]}+${data[j*$num_dims+d]}-${means[l*$num_dims+d]}" | bc)
                fi
            done
            if (( $(echo "$min_distance==-1" | bc) )); then
                min_distance=${distance[l]};
                assignment=$l;
            elif (( $(echo "${distance[l]}<$min_distance" | bc) )); then
                min_distance=${distance[l]};
                assignment=$l;
            fi
        done
        # assign and aggregate to new means
        num_assignments[$assignment]=$(echo "scale=$scale;${num_assignments[$assignment]}+1" | bc)
        for ((d=0;d<$num_dims;d++));
        do
            new_means[$assignment*$num_dims+d]=$(echo "scale=$scale;${new_means[$assignment*$num_dims+d]}+${data[j*$num_dims+d]}" | bc)
        done
    done
    # divide by number of assignments to get new centers
    echo ${num_assignments[@]}
    for ((l=0;l<$k;l++));
    do
        for ((d=0;d<$num_dims;d++));
        do
            means[l*$num_dims+d]=$(echo "scale=$scale;${new_means[l*$num_dims+d]}/${num_assignments[l]}" | bc)
        done
    done
    echo "Iteration ${i}:"
    echo "Means:"
    echo ${means[@]}
done
