#!/bin/bash
max_depth=-1
positional_args=()
input_dir="$1"   
output_dir="$2"
find "$input_dir" -type f -exec cp {} "$output_dir" \;
exit 0
