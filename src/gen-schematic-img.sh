#!/bin/sh
# Create PNG image from schematic for pixel to pixel compare.

PYTHON=${PYTHON:=python3}

# TODO: Move next operation to Docker Image generation, and keep a reminder here
# about the workaround
# See https://stackoverflow.com/questions/52998331/imagemagick-security-policy-pdf-blocking-conversion
IMAGICK_POLICY=/etc/ImageMagick-*/policy.xml
# Only modify once
egrep -q "coder.*read.*PDF" ${IMAGICK_POLICY} || perl -i -p -e 's@(\</policymap\>)@<policy domain="coder" rights="read | write" pattern="PDF" />\n$1@;' ${IMAGICK_POLICY}


input_path="$1"
output_path="$2"

if [ -f $output_path/.generated ]; then
   exit
fi

if [ ! -d $output_path ]; then
 	mkdir -p $output_path
fi

eeschema_do export -f pdf --all_pages  $input_path $output_path \
&& find $output_path -name \*.pdf \
   | xargs -n 1 basename -s .pdf \
   | xargs -n 1 -P 0 -I % convert  -set colorspace Gray -separate -average -density 150 $output_path/%.pdf $output_path/%.png \
&& touch $output_path/.generated

