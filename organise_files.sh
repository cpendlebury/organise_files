#!/bin/bash
# Author: Christopher Pendlebury

# Description: A shell script to organise a large directory of downloaded files with ambiguous filenames.
# Call ./organise_files.sh /path/to/directory


if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR=$1

if [ ! -d "$DIR" ]; then
    echo "Directory does not exist"
    exit 1
fi

cd "$DIR" || exit 1

# Organise by filetype, then year, then month
for file in *; do
    if [ -f "$file" ]; then
        # get extension
        ext="${file##*.}"
        if [ "$ext" == "$file" ]; then
            ext="noext"
        fi
        # get mtime
        mtime=$(stat -c %y "$file")
        year=$(date -d "$mtime" +%Y)
        month=$(date -d "$mtime" +%m)
        # create dir
        target_dir="$ext/$year/$month"
        mkdir -p "$target_dir"
        # move file
        mv "$file" "$target_dir/"
    fi
done

echo "Files organized successfully."
