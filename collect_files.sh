#!/bin/bash
input_dir=$1
output_dir=$2
max_depth=$3


mkdir -p "$output_dir"

find "$input_dir" -maxdepth "$max_depth" -type f -exec cp --parents {} "$output_dir" \;
exit 0


