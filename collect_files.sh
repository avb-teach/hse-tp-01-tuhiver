#!/bin/bash
input_dir=$1
output_dir=$2
depth=$3
find "$input_dir" -type f -exec cp {} "$output_dir" \;

exit 0


