#!/bin/bash

#if [ ${GIT_DIFF_PATH_TOTAL}x == x ] ; then
#   echo "Must be called as git diff tool"
#   exit -1
#fi

# For testing, install missing tools
TO_INSTALL=
#[[ "$(which git 2>/dev/null)"x == "x" ]] && TO_INSTALL="$TO_INSTALL git"
[[ "$(which gs 2>/dev/null)"x == "x" ]] && TO_INSTALL="$TO_INSTALL ghostscript"

[[ "${TO_INSTALL}"x == "x" ]] || ( apt update && apt install -y $TO_INSTALL ) > /dev/null 2>&1



TOOL_PATH=$(dirname $(realpath $0))
SCH_DIFF=${SCH_DIFF:=${TOOL_PATH}/schematic-diff.sh}
LOGFILE=/dev/null
LOGFILE=$0.log

# GIT_DIFF_PATH_TOTAL is set to number of files with differences
#  (: when comparing multiple files ?)

# To be called from GIT as diff tool.
#
# Parameters:
#  - FILENAME
#  - PREVIOUS_TEMP_FILEPATH
#  - PREVIOUS_GIT_REVID
#  - PREVIOUS_FILE_MODE
#  - CURRENT_FILEPATH
#  - CURRENT_GIT_REVID
#  - CURRENT_FILE_MODE
FILENAME="$1"
PREV_TEMP_PATH="$2"
PREV_GIT_ID="$3"
PREV_FILE_MODE="$4"
CUR_TEMP_PATH="$5"
CUR_GIT_ID="$6"
CUR_FILE_MODE="$7"

if [[ 0 == 1 ] ; then
  echo "# TOOL CMD & PARAMETERS" > $LOGFILE
  echo "$0" "$@" >> $LOGFILE
  echo "# env" >> $LOGFILE
  env >> $LOGFILE
fi

PREV_GIT_SHORT_ID=${PREV_GIT_ID:0:7}
CUR_GIT_SHORT_ID=${CUR_GIT_ID:0:7}

#TODO: set to temp path,
#     copy output file for viewing on local system
#     delete tempfiles
WORKDIR="${CUR_GIT_SHORT_ID}_${PREV_GIT_SHORT_ID}"

echo "# ${SCH_DIFF} $PREV_TEMP_PATH" "$CUR_TEMP_PATH" $WORKDIR >> $LOGFILE
${SCH_DIFF}  "$PREV_TEMP_PATH" "$CUR_TEMP_PATH" $WORKDIR >> $LOGFILE 2>&1

# Provide result path to caller
echo -n $WORKDIR/ipc/montage.png
