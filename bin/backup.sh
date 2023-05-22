#!/bin/bash

# Name of the original file
origfile="$1"

if [ -z "$origfile" ]; then
    echo "No filename provided. Usage: $0 filename"
    exit 1
fi

if [ ! -f "$origfile" ]; then
    echo "File $origfile does not exist."
    exit 1
fi

# Initialize version number
version=1

# Find the latest version of the backup
while [ -f "${origfile}.MD.v${version}" ]; do
    version=$((version + 1))
done

# Create a new backup
cp "$origfile" "${origfile}.MD.v${version}"

echo "Backup ${origfile}.MD.v${version} created."
