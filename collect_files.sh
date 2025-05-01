#!/bin/bash
input_dir="$1"
output_dir="$2"
max_depth=0  

if [ "$3" == "--max_depth" ]; then
    max_depth="$4"
fi

unique_name() {
    local path="$1" counter=1
    while [ -e "$path" ]; do
        path="${path%.*}_$counter.${path##*.}"
        ((counter++))
    done
}
if [ $max_depth -eq 0 ]; then
    find "$input_dir" -type f -exec cp {} "$output_dir" \; 
    exit 0
fi

find "$input_dir" -type f | while read -r file; do
    rel_path="${file#$input_dir/}"
    depth=$(grep -o '/' <<< "$rel_path" | wc -l)
    
    if [ $depth -ge $max_depth ]; then
        rel_path=$(echo "$rel_path" | cut -d'/' -f$((max_depth))-)
    fi
    
    dest="$output_dir/$rel_path"
    mkdir -p "$(dirname "$dest")"
    cp --backup=numbered "$file" "$dest"
done



