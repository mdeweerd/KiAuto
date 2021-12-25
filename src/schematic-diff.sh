#!/bin/sh
# Usage: schematic-diff.sh <left_schematic.sch> <right_schematic.sch> WORKDIR 

schema1=$1
schema2=$2

workdir=$3
workdir=${workdir:=/tmp}

IPC_DIR=$workdir/ipc
DIFF_DIR=$diffdir/ipc

LEFT_CACHE_DIR=${workdir}/left
RIGHT_CACHE_DIR=${workdir}/right
DIFF_DIR=${workdir}/diff

mkdir -p "${LEFT_CACHE_DIR}" "${RIGHT_CACHE_DIR}" "${DIFF_DIR}" "${IPC_DIR}"

./gen-schematic-img.sh $schema1 $LEFT_CACHE_DIR
./gen-schematic-img.sh $schema2 $RIGHT_CACHE_DIR

find $LEFT_CACHE_DIR -name \*.png \
  | xargs -n 1 basename -s .png \
  | xargs -n 1 -P 0 -I % \
      composite -stereo 0 $LEFT_CACHE_DIR/%.png $RIGHT_CACHE_DIR/%.png $DIFF_DIR/%.png


find $DIFF_DIR -name \*png \
  | xargs -n 1 -P 0 -I %  \
      convert -trim % %

montage -mode concatenate -tile 1x $DIFF_DIR/*.png $IPC_DIR/montage.png
