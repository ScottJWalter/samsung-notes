#!/bin/bash
#
# Notes2MD -- Convert Samsung Notes to markdown
#
# This script converts Samsung Notes to markdown.  Export one or more
# notes as PDF files from inside the app (I haven't found a way to automate 
# this, yet) into the ${DIR_IN} folder, then run this script.  It:
#
# 1. Converts the PDF to a sequence of PNG image files (placing those
#    images and the original pdf in an "assets/" subfolder)
# 2. Builds a markdown file with links to the pdf and images.
# 3. Zips the markdown file and assets subfolder into a ZIP file, placing
#    the file in the ${DIR_OUT} folder
#
# Requirements:
#   - poppler
# 
# Usage:
#   ./notes2md.sh <data>
#
# Author:
#   Scott Walter <sjwalter@gmail.com>
#
# Date:
#   2024-08-21
#
# Version:
#   1.6.0
#
# License:
#   MIT
#------------------------------------------------------------------------------
#
notes_2_markdown() 
{
    # Get the data directory
    local data_root=$1

    local DIR_IN="${data_root}/in"
    local DIR_OUT="${data_root}/out"
    local DIR_WORK="${data_root}/work"

    echo "Samsung Notes to Markdown"
    echo "========================="
    echo "Input directory: ${DIR_IN}"
    echo "Working directory: ${DIR_WORK}"
    echo "Output directory: ${DIR_OUT}"
    echo "========================="

    # (optional) -- Clean out DIR_WORK
    rm -rf ${DIR_WORK}/* && mkdir -p ${DIR_WORK}

    # (optional) -- Replace all spaces with underscores in filenames
    for file in ${DIR_IN}/*.pdf; do
        local new_name="${file// /_}"
        # if $new_name doesn't equal $file, then rename it
        if [[ "$new_name" != "$file" ]]; then
            mv "$file" "$new_name"
        fi
    done

    # loop the DIR_IN directory
    for pdf in ${DIR_IN}/*.pdf; do
        local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        local fullname="$(basename ${pdf})"
        local basename="$(basename ${pdf} .pdf)"
        local assets="${basename}_assets"
        local data="${DIR_WORK}/${basename}"

        echo "Processing ${fullname}..."

        # reset processing directory (if present)
        rm -rf ${data} && mkdir -p ${data}/${assets}
	
        # move file to processing directory
        mv ${pdf} ${data}/${assets}
	
        # convert to png file(s)
        echo "   -> generating png files..."
        pdftoppm -png ${data}/${assets}/${fullname} ${data}/${assets}/${basename}
	
        # generate markdown file
        echo "   -> generating markdown..."
        cat << EOF > ${data}/${basename}.md
---
title: $basename
slug: $basename
created: $timestamp
---
# ${basename}

## Original PDF file
* [$fullname](./$assets/$fullname)

## Pages
EOF

        # loop through generated png files, build list
        for png in ${data}/${assets}/*.png; do
            cat << EOF >> ${data}/${basename}.md
* [$(basename $png .png)](./${assets}/$(basename $png))
EOF
        done

        # zip up the bundle into DIR_OUT.  It creates a
        # subshell, setting the root directory of the
        # zip file to ${data}.
        echo "   -> zipping..."
        (cd ${data} && zip -qq -r ../../out/${basename}.zip .)

        # clean up work diretory
        rm -rf ${data}
        echo "   -> done!"
    done

    echo "========================="
    echo "ALL DONE!"
}

###
# MAIN
###
if [ $# -eq 0 ]; then
    echo "Usage: $0 <data_root>"
    exit 1
else
    notes_2_markdown $1
fi
