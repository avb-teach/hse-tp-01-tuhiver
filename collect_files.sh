#!/bin/bash


input_dir="$1"
output_dir="$2"
max_depth=${3:-0}
mkdir -p "$output_dir"

unique_name() {
    local path="$1"
    local counter=1
    local original="$path"
    
    while [ -e "$path" ]; do
        if [[ "$original" =~ \.[^./]+$ ]]; then
            path="${original%.*}_${counter}.${original##*.}"
        else
            path="${original}_${counter}"
        fi
        counter=$((counter+1))
    done
    echo "$path"

process_item() {
    local src="$1"
    local rel_path="$2"
    local current_depth="$3"
    local new_rel_path="$rel_path"
    if [ $max_depth -gt 0 ] && [ $current_depth -gt $max_depth ]; then
        local overflow=$((current_depth - max_depth))
        new_rel_path=$(echo "$rel_path" | awk -F'/' -v o="$overflow" '{
            for (i=o+1; i<=NF; i++) printf "%s%s", $i, (i<NF?"/":"")
        }')
    fi

    local dest="${output_dir}/${new_rel_path}"
    
    if [ -f "$src" ]; then
        dest=$(unique_name "$dest")
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    elif [ -d "$src" ] && [ -n "$(ls -A "$src")" ]; then
        mkdir -p "$dest"
    fi
}

traverse() {
    local current_dir="$1"
    local rel_path="$2"
    local current_depth="$3"
    for item in "$current_dir"/*; do
        [ -e "$item" ] || continue
        local base=$(basename "$item")
        local new_rel_path="${rel_path:+$rel_path/}$base"
        
        process_item "$item" "$new_rel_path" "$current_depth"
        
        if [ -d "$item" ]; then
            traverse "$item" "$new_rel_path" $((current_depth + 1))
        fi
    done
}
traverse "$input_dir" "" 2

exit 0
