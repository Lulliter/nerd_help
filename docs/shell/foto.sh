#!/bin/zsh

# Directory contenente le immagini .HEIC
input_dir="/Users/luisamimmi/Downloads/foto sandali vero cuoio"
# Directory dove salvare le immagini convertite
output_dir="/Users/luisamimmi/Downloads/foto sandali vero cuoio/output"

# Funzione per convertire le immagini .HEIC in .jpg
convert_heic_to_jpg() {
    # Check if input directory exists
    if [ ! -d "$input_dir" ]; then
        echo "Input directory $input_dir does not exist."
        return 1
    fi

    # Check if output directory exists, if not, create it
    if [ ! -d "$output_dir" ]; then
        mkdir -p "$output_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to create output directory $output_dir."
            return 1
        fi
    fi

    # Check if there are any .HEIC files in the input directory
    shopt -s nullglob
    heic_files=("$input_dir"/*.HEIC)
    shopt -u nullglob

    if [ ${#heic_files[@]} -eq 0 ]; then
        echo "No .HEIC files found in $input_dir."
        return 1
    fi

    # Convert each .HEIC file to .jpg
    for file in "${heic_files[@]}"; do
        base_name=$(basename "$file" .HEIC)
        convert "$file" -quality 85 "$output_dir/$base_name.jpg"
        if [ $? -eq 0 ]; then
            echo "Converted $file to $output_dir/$base_name.jpg"
        else
            echo "Failed to convert $file."
        fi
    done
}

# Call the 1 function
convert_heic_to_jpg

# Funzione per ridurre la dimensione dei file a meno di 2 megabyte
reduce_image_size() {
    # Check if output directory exists
    if [ ! -d "$output_dir" ]; then
        echo "Output directory $output_dir does not exist."
        return 1
    fi

    # Check if there are any .jpg files in the output directory
    shopt -s nullglob
    jpg_files=("$output_dir"/*.jpg)
    shopt -u nullglob

    if [ ${#jpg_files[@]} -eq 0 ]; then
        echo "No .jpg files found in $output_dir."
        return 1
    fi

    # Reduce each .jpg file to less than 2 megabytes
    for file in "${jpg_files[@]}"; do
        while [ $(stat -f%z "$file") -ge 1000000 ]; do
            mogrify -resize 90% "$file"
        done
        echo "Reduced size of $file"
    done
}

# Call the 2 function
reduce_image_size


# secondoo esempio 

# Directory contenente le immagini .HEIC
input_dir="/Users/luisamimmi/Downloads/foto_pedaliera"
# Directory dove salvare le immagini convertite
output_dir="/Users/luisamimmi/Downloads/foto_pedaliera/output"

# Call the 1 function
convert_heic_to_jpg
# Call the 2 function
reduce_image_size

# 3 esempio 
# Directory contenente le immagini .HEIC
input_dir="/Users/luisamimmi/Downloads/foto stivali timberland"
# Directory dove salvare le immagini convertite
output_dir="/Users/luisamimmi/Downloads/foto stivali timberland/output"

# Call the 1 function
convert_heic_to_jpg
# Call the 2 function
reduce_image_size