#!/bin/bash
max_depth=-1
positional_args=()
input_dir="$1"   
output_dir="$2"
mkdir -p "$output_dir"
if [[ "$1" == "--max_depth" ]]; then
    max_depth="$2"
    shift 2
fi
if (( max_depth == -1 )); then
    find "$input_dir" -type f -exec cp {} "$output_dir" \;
else
    find "$input_dir" -maxdepth "$max_depth" -type f -exec cp {} "$output_dir" \;
fi

exit 0
