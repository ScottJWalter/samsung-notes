#!/bin/sh
# simple test script to reset (wipe) the in/, out/, and work/ directories
# in the data_root directory.
#
# usage: data_reset.sh <data_root>
#
reset_data()
{
    local data_root=$1
    rm -rf ${data_root}/in && mkdir ${data_root}/in
    rm -rf ${data_root}/out && mkdir ${data_root}/out
    rm -rf ${data_root}/work && mkdir ${data_root}/work
}

###
# MAIN
###
if [ $# -eq 0 ]; then
    echo "Usage: $0 <data_root>"
    exit 1
else
    reset_data $1
fi
