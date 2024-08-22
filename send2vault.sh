#!/bin/sh
#
# Unpack markdown zip files and copy them to the 
# specified markdown (obsidian) vault.
# 
# Usage:
#   ./send2vault.sh <source> <dest>
#
# where:
#   <source> - zip file(s) to unpack
#   <dest>   - destination directory
#
# Example:
#   ./send2vault.sh ~/samsung-notes/data/out ~/Obsidian/vaults/myvault/MySamsungNotes
#
usage()
{
    echo "Usage: $0 <source> <dest>"
    exit 1
}

send_2_vault()
{
    source=$1
    dest=$2

    # if $source is a directory, loop over it and process each zip file, else just process $source
    if [ -d $source ]; then
        source=$(find $source -name "*.zip")
    fi

    # loop over the $source files
    for zip_file in $source; do
        echo "   -> Adding ${zip_file}..."
        unzip $zip_file -d $dest
    done
}

###
# MAIN
###
if [ $# -eq 0 ]; then
    usage
    exit 1
fi

echo "Sending to Vault..."
send_2_vault $1 $2
echo "...DONE!"
