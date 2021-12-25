#!/bin/bash
if [ ${GIT_DIFF_PATH_TOTAL}x == x ] ; then
   echo "Must be called as git diff tool"
   exit -1
fi

TOOL_PATH=$(dirname $(realpath $0))
GIT_DIFF=${GIT_DIFF:=${TOOL_PATH}/git-diff-sch.sh}
GIT_DIFF=./git-diff-sch.sh

TMP_DIR=./tmp/
mkdir -p ${TMP_DIR} ${TMP_DIR}left/ ${TMP_DIR}right/
# Difference tool requires the same basename
LEFT=${TMP_DIR}left/$1
RIGHT=${TMP_DIR}right/$1
cp -p "$2" "$LEFT"
cp -p "$5" "$RIGHT"

# Run command in docker, get diff filename
MONTAGE_DIFF=$(./runInKiAuto ./git-diff-sch.sh "$1" "$LEFT" "$3" "$4" "$RIGHT" "$6" "$7")

VIEW_TOOL=
[[ "$(which display 2>/dev/null)"x == "x" ]] || VIEW_TOOL=display
[[ "$(which cmd 2>/dev/null)"x == "x" ]] || VIEW_TOOL="cmd /c start"
[[ "$(which cmd 2>/dev/null)"x == "x" ]] || echo 1
MONTAGE_DIFF=$(cygpath -w "${MONTAGE_DIFF}")


if [[ "${VIEW_TOOL}x" != x ]] ; then
  #echo "Run: ${VIEW_TOOL} ${MONTAGE_DIFF}"
  ${VIEW_TOOL} ${MONTAGE_DIFF}
else
  echo "Difference image in file '${MONTAGE_DIFF}'"
fi

