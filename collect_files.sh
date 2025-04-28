#!/bin/bash
input_dir=$1
output_dir=$2
max_depth=$3


if [ -z "$max_depth" ]; then
    find "$input_dir" -type f -exec cp --parents {} "$output_dir" \;
else
    # Копируем с учетом максимальной глубины
    find "$input_dir" -mindepth 1 -maxdepth "$max_depth" -type f -exec cp --parents {} "$output_dir" \;
fi

exit 0


