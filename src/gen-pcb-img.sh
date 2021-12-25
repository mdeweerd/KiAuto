#!/bin/sh
# Create PNG image from schematic for pixel to pixel compare.

PYTHON=${PYTHON:=python3}
LAYERS="F.Cu B.Cu F.Fab F.SilkS F.Mask F.Paste B.Paste B.Mask B.SilkS B.Fab"

# TODO: Move next operation to Docker Image generation, and keep a reminder here
# about the workaround
# See https://stackoverflow.com/questions/52998331/imagemagick-security-policy-pdf-blocking-conversion
IMAGICK_POLICY=/etc/ImageMagick-*/policy.xml
# Only modify once
egrep -q "coder.*read.*PDF" ${IMAGICK_POLICY} || perl -i -p -e 's@(\</policymap\>)@<policy domain="coder" rights="read | write" pattern="PDF" />\n$1@;' ${IMAGICK_POLICY}



input_path="$1"
output_path="$2"

if [ ! -d $output_path ]; then
 	mkdir -p $output_path
fi


# export [-h] [--fill_zones] [--list LIST]
#                        [--output_name OUTPUT_NAME] [--scaling SCALING]
#                        [--pads PADS] [--no-title] [--monochrome] [--mirror]
#                        [--separate]
#                        kicad_pcb_file output_dir layers [layers ...]

pcbnew_do export --separate $input_path $output_path $LAYERS
find $output_path -name \*.pdf \
  | xargs -n 1 basename -s .pdf \
  | xargs -n 1 -P 0 -I % convert +profile "icc" -density 150 $output_path/%.pdf $output_path/%.png

