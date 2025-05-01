#!/bin/bash


input_dir="$1"
output_dir="$2"
max_depth=0  


if [ $# -eq 4 ] && [ "$3" == "--max_depth" ] && [[ "$4" =~ ^[0-9]+$ ]]; then
    max_depth="$4"
elif [ $# -gt 2 ]; then
    echo "Ошибка: Неправильные аргументы. Используйте:"
    echo "  $0 <input_dir> <output_dir> [--max_depth N]"
    exit 1
fi


if [ ! -d "$input_dir" ]; then
    echo "Ошибка: Входная директория не существует: $input_dir"
    exit 1
fi


mkdir -p "$output_dir"


unique_name() {
    local path="$1"
    local counter=1
    while [ -e "$path" ]; do
        if [[ "$path" =~ \.[^./]+$ ]]; then
            path="${path%.*}_${counter}.${path##*.}"
        else
            path="${path}_${counter}"
        fi
        counter=$((counter + 1))
    done
    echo "$path"
}


if [ $max_depth -eq 0 ]; then
    find "$input_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
        dest="$output_dir/$(basename "$file")"
        dest=$(unique_name "$dest")
        cp "$file" "$dest"
    done
    echo "Все файлы скопированы в $output_dir"
    exit 0
fi


find "$input_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
    # Получаем относительный путь
    rel_path="${file#$input_dir/}"

    depth=$(tr -cd '/' <<< "$rel_path" | wc -c)
    depth=$((depth + 1))
    
  
    if [ $depth -gt $max_depth ]; then
        overflow=$((depth - max_depth))
        rel_path=$(echo "$rel_path" | awk -F'/' -v o="$overflow" '{
            for (i=o+1; i<=NF; i++) printf "%s%s", $i, (i<NF?"/":"")
        }')
    fi
    
    dest="$output_dir/$rel_path"
    mkdir -p "$(dirname "$dest")"
    dest=$(unique_name "$dest")
    cp "$file" "$dest"
done

echo "Файлы скопированы в $output_dir с максимальной глубиной $max_depth"

