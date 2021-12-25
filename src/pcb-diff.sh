#!/bin/sh
# Usage: pcb-diff.sh <left.kicad_pcb> <right.kicad_pcb> WORKDIR 

pcb1=$1
pcb2=$2

workdir=$3
workdir=${workdir:=/tmp/brd}

IPC_DIR=$workdir/brd
DIFF_DIR=$workdir/diff

LEFT_DIR=${workdir}/left
RIGHT_DIR=${workdir}/right
DIFF_DIR=${workdir}/diff

mkdir -p "${LEFT_DIR}" "${RIGHT_DIR}" "${DIFF_DIR}" "${IPC_DIR}"

./gen-pcb-img.sh $pcb1 $LEFT_DIR
./gen-pcb-img.sh $pcb2 $RIGHT_DIR


# This recipe is from https://gist.github.com/brechtm/891de9f72516c1b2cbc1
# It does not work at all for differently sized images

find $LEFT_DIR -name \*.png \
  | xargs -n 1 basename -s .png \
  | xargs -n 1 -P 0 -I % \
      convert '(' $LEFT_DIR/%.png -flatten -grayscale Rec709Luminance ')'  \
              '(' $RIGHT_DIR/%.png -flatten -grayscale Rec709Luminance ')' \
              '(' -clone 0-1 -compose darken -composite ')'  \
              -channel RGB -combine $DIFF_DIR/%.png


#find $LEFT_DIR -name \*.png |xargs -n 1 basename -s .png | xargs -n 1 -P 0 -I % composite -stereo 0 $LEFT_DIR/%.png $RIGHT_DIR/%.png $DIFF_DIR/%.png

find $DIFF_DIR -name \*png \
  | xargs -n 1 -P 0 -I % convert -trim % %

DIFF_FILES=$(ls -a $DIFF_DIR/*.png)


#montage -mode concatenate -tile 1x $DIFF_DIR/*-Bottom.png $DIFF_DIR/*-CuBottom.png $DIFF_DIR/*-CuTop.png $DIFF_DIR/*-Top.png $IPC_DIR/montage.png
montage -mode concatenate -tile 1x $DIFF_FILES $IPC_DIR/montage.png

exit


## Try for a left - diff - right montage. not happy yet
#  montage -mode concatenate -tile 3x  \
#  $LEFT_DIR/*-Bottom.png \
#  $DIFF_DIR/*-Bottom.png \
#  $RIGHT_DIR/*-Bottom.png \
#  $LEFT_DIR/*-CuBottom.png \
#  $DIFF_DIR/*-CuBottom.png \
#  $RIGHT_DIR/*-CuBottom.png \
#  $LEFT_DIR/*-CuTop.png \
#  $DIFF_DIR/*-CuTop.png \
#  $RIGHT_DIR/*-CuTop.png \
#  $LEFT_DIR/*-Top.png \
#  $DIFF_DIR/*-Top.png \
#  $RIGHT_DIR/*-Top.png \
#  $IPC_DIR/montage.png


