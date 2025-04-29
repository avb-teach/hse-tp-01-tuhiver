#!/bin/bash
input_dir=$1
output_dir=$2

find "$input_dir" -type f -exec cp {} "$output_dir" \;

exit 0


