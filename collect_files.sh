#!/bin/bash

input_dir=$1
output_dir=$2
max_depth=$3



mkdir -p "$output_dir"

if [ -z "$max_depth" ]; then
    find "$input_dir" -type f -exec cp --parents {} "$output_dir" \;
else
   
    find "$input_dir" -type f | while read -r file; do
        
        rel_path="${file#$input_dir}"
        rel_path="${rel_path#/}"
        depth=$(echo "$rel_path" | grep -o '/' | wc -l)
        if [ "$depth" -lt "$max_depth" ]; then
         
            mkdir -p "$output_dir/$(dirname "$rel_path")"
            cp "$file" "$output_dir/$rel_path"
        else
            
            prefix=$(dirname "$rel_path" | tr '/' '_')
            cp "$file" "$output_dir/${prefix}_$(basename "$file")"
        fi
    done
fi

exit 0


