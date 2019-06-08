#!/usr/bin/env bash
# call like ./boogie.sh kokopeekaboo.png kokoboogie.gif
# makes no promises on filesizes

fractionalZoom=2.0/3

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

# get dims and find largest one
height=$(identify -format "%h" "$1")
width=$(identify -format "%w" "$1")
maxSize=$height
if (($height < $width))
then
  maxSize=$width
fi

zoomSize=$(echo "$maxSize * $fractionalZoom" | bc)
sideOffset=$(( ($width - $zoomSize) / 2 ))
crop=$(printf "%dx%d+%d+%d" $zoomSize $zoomSize $sideOffset 0)
scale=$(printf "%dx%d" $width $height )
repage=$(printf "%d+%d" -$sideOffset 0 )

# original
first="$1"
# flipped
second=$(mktemp /tmp/happy.XXXXXXX)
# zoom on first (original)
third=$(mktemp /tmp/happy.XXXXXXX)
# zoom on second (flipped)
fourth=$(mktemp /tmp/happy.XXXXXXX)

# mirror the first one
convert "$first" -flop "$second"
# first zoomin
convert "$first" -crop "$crop" -scale "$scale" -repage "$repage" "$third"
# second zoomin
convert "$second" -crop "$crop" -scale "$scale" -repage "$repage" "$fourth"

# and now make it with a 2/100s delay using dispose of previous frame
convert -dispose background -delay 33x100 "$first" "$second" "$third" "$fourth" "$2"

# cleanup

rm "$second"
rm "$third"
rm "$fourth"
