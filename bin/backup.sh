#!/bin/bash
# define the command. We use cp for a file and mv for directory
cmd='cp'

# Name of the original file
origfile="$1"


if [ -z "$origfile" ]; then
    echo "No filename provided. Usage: $0 filename"
    exit 1

elif [ -d "$origfile" ]; then
    echo "$origfile is a directory, we will move instead of copy."
    cmd='mv'

elif [ ! -f "$origfile" ]; then
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
$cmd "$origfile" "${origfile}.MD.v${version}"

echo "Backup ${origfile}.MD.v${version} created."
