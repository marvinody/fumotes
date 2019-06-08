#!/usr/bin/env bash
# call like ./falling.sh nue.png endless_falling_nue.gif
# makes no promises on filesizes but the result animation will be a square of
# the largest dimension in orig. image

# do not change to negative to go up
fallingAmt=10

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
for ((d=0; d<$maxSize; d+=fallingAmt))
do
  filename=$(printf "%s/%03d.png" $tmpframeFolder $(($d + $maxSize)) )
  offset=$(printf "+0%+d", $d)
  # paging "works" but doesn't make it look right. You need wrap around to make work
  #convert "$tmpfile" -page "$offset" -background transparent -flatten "$filename"
  convert "$tmpfile" -roll "$offset" -background transparent -flatten "$filename"
done
# and now make it with a 5/100s delay using dispose of previous frame
convert -dispose background -delay 5 "$tmpframeFolder/*" "$2"

# cleanup
rm "$tmpfile"
rm -rf "$tmpframeFolder"
