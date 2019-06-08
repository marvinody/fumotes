#!/usr/bin/env bash
# call like ./rolling.sh thinkasen.png rollkasen.gif
# makes no promises on filesizes but the result animation will be a square of
# the largest dimension in orig. image

# number should be a common divisor of 100 and 360
# 1 2 4 5 10 20
# more steps means better "resolution" ie more frames
# you can use non common div. but I think using 20 should be fine
# fractions might mess something up
stepCount=20

if [ -z "$1" ]
then
  echo "No image supplied"
  exit 1
elif [ -z "$2" ]
then
  echo "No output image supplied"
  exit 2
elif [[ !("$2" == *.gif)]]
then
  echo "Output image must end in .gif"
  exit 3
fi
file=$1
# get dims and find largest one
height=$(identify -format "%h" "$file")
width=$(identify -format "%w" "$file")
maxSize=$height
if (($height < $width))
then
  maxSize=$width
fi
# we'll make the centered piece to here
tmpfile=$(mktemp /tmp/falling.XXXXXXX)
sizeS=$(printf "%sx%s" $maxSize $maxSize)
# this is our translation basis
convert "$1" -gravity center -background transparent -extent "$sizeS" "$tmpfile"
# hold each frame
tmpframeFolder=$(mktemp /tmp/falling.XXXXXX -d)

# actually gen each frame
for ((d=0; d<$stepCount; d++))
do
  filename=$(printf "%s/%03d.png" $tmpframeFolder $(($d + $maxSize)) )
  # find actual offsets from step counter
  # x is based off of the actual width of the image
  # I think it'll look weird if original image doesn't take up full width tho?
  xOffset=$(($maxSize * $d / $stepCount))
  angleOffset=$((360 * $d / $stepCount))

  rollOffset=$(printf "%+d+0", $xOffset)
  convert "$tmpfile" -background transparent -distort SRT "$angleOffset" -roll "$rollOffset" -flatten "$filename"
done
# and now make it with a 5/100s delay using dispose of previous frame
convert -dispose background -delay 5 "$tmpframeFolder/*" "$2"

# cleanup
rm "$tmpfile"
rm -rf "$tmpframeFolder"
