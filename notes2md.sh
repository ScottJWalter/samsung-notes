#!/bin/sh
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
#   ./notes2md.sh
#
# Author:
#   Scott Walter <sjwalter@gmail.com>
#
# Date:
#   2024-08-21
#
# Version:
#   0.8.0
#
# License:
#   MIT
#------------------------------------------------------------------------------
#

# Global variables
#
# NOTE:  There are references below that assume that the "data" directory
# has the following structure:
#
#   data/
#   ├── in/
#   ├── out/
#   └── work/
#
# If you change this, you'll need to update the references below.
# 
DIR_IN="./data/in"
DIR_OUT="./data/out"
DIR_WORK="./data/work"

# (optional) -- Clean out DIR_WORK
rm -rf ${DIR_WORK}/* && mkdir -p ${DIR_WORK}

# loop the DIR_IN directory
for pdf in ${DIR_IN}/*.pdf; do
	timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    fullname="$(basename ${pdf})"
    basename="$(basename ${pdf} .pdf)"
    assets="${basename}_assets"
    data="${DIR_WORK}/${basename}"

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
    #
    # NOTE:  This assumes the directory structure
    # as defined above.  If you change the directory
    # structure, you'll need to change this.
    echo "   -> zipping..."
    (cd ${data} && zip -qq -r ../../out/${basename}.zip .)

    # clean up work diretory
    rm -rf ${data}
    echo "   -> done!"
done

# clean up
unset DIR_IN
unset DIR_OUT
unset DIR_WORK
unset timestamp
unset fullname
unset basename
unset data
unset assets

echo "ALL DONE!"
