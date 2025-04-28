#!/bin/bash
depth=""
input_dir="$1"   
output_dir="$2"
if [ "$1" == "--max_depth" ]; then
    depth="-maxdepth $2"
    shift 2
fi
mkdir -p "$output_dir"
find "$input_dir" $depth -type f | while read file; do
    name=$(basename "$file")
    

    if [ -f "$output_dir/$name" ]; then
        i=1
        while [ -f "$output_dir/${name%.*}_$i.${name##*.}" ]; do
            ((i++))
        done
        name="${name%.*}_$i.${name##*.}"
    fi
    
    
    cp "$file" "$output_dir/$name"
done

exit 0


