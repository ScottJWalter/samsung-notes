#!/bin/sh
#
# Send2Vault -- Send converted Samsung Notes to obsidian
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
#   ./send2vault.sh ~/samsung-notes/data/out ~/Obsidian/vaults/myvault/MyNotesFolder
#
send_2_vault()
{
    source=$1
    dest=$2

    echo "Send Notes Markdown to Obsidian Vault"
    echo "====================================="
    echo "Source: $source"
    echo "Destination: $dest"
    echo "====================================="

    # if $source is a directory, loop over it and process each zip file, else just process $source
    if [ -d $source ]; then
        source=$(find $source -name "*.zip")
    fi

    if [ -z "$source" ]; then
        echo "No files to process"
    else
        echo "Sending to Vault..."

        # loop over the $source files
        for zip_file in $source; do
            local basename="$(basename ${zip_file} .zip)"

            echo "   -> Adding ${basename}..."

            unzip -q $zip_file -d $dest/$basename
        done

        echo "...DONE!"
    fi
}

###
# MAIN
###
if [ $# -eq 0 ]; then
    echo "Usage: $0 <source> <dest>"
    exit 1
else
    send_2_vault $1 $2
fi
