#!/bin/bash
input_dir=$1
output_dir=$2
MAX_DEPTH=$3
   



mkdir -p "$output_dir"


copy_with_unique_name() {
    local src="$1"
    local dst_dir="$2"
    local filename=$(basename "$src")
    local name="${filename%.*}"
    local ext="${filename##*.}"

  
    if [[ "$name" == "$filename" ]]; then
        ext=""
    else
        ext=".$ext"
    fi

    local newname="$name$ext"
    local counter=1
    while [[ -e "$dst_dir/$newname" ]]; do
        newname="${name}${counter}${ext}"
        ((counter++))
    done
    cp "$src" "$dst_dir/$newname"
}


if [[ -n "$MAX_DEPTH" ]]; then
    find "$input_dir" -type f -mindepth 1 -maxdepth $((MAX_DEPTH + 1)) | while read -r file; do
        copy_with_unique_name "$file" "$output_dir"
    done
else
    find "$input_dir" -type f | while read -r file; do
        copy_with_unique_name "$file" "$output_dir"
    done
fi
find "$input_dir" -type f -exec cp {} "$output_dir" \;

exit 0


