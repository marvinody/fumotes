#!/usr/bin/env bash
# call like ./happy.sh junkson.png junkosonhappy.gif
# makes no promises on filesizes
fallingAmtPerFrame=3
totalFrames=3


totalDrop=$((fallingAmtPerFrame * totalFrames))
totalOffset=$(printf "+0+%d" $totalDrop)
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

# we'll make the centered piece to here
start="$1"
end=$(mktemp /tmp/happy.XXXXXXX)
# this is our max translation
convert "$start" -repage "$totalOffset" -background none -flatten "$end"
# hold each frame
tmpframeFolder=$(mktemp /tmp/happy.XXXXXX -d)

# actually gen each frame
for ((d=1; d<$totalFrames; d+=1))
do
  filename=$(printf "%s/%03d.png" $tmpframeFolder $d )
  offset=$(printf "+0%+d" $(($d * $fallingAmtPerFrame)) )
	
  # regular page seems to move the images by double the offset
  # repage seems to move them to the correct offset
  convert "$start" -repage "$offset" -background none -flatten "$filename"
done

middleFrames=$(find $tmpframeFolder -type f -print| sort -h)
revMiddleFrames=$(find $tmpframeFolder -type f -print| sort -hr)
images=$(printf "%s %s %s %s" "$start" "$middleFrames" "$end" "$revMiddleFrames")

# and now make it with a 2/100s delay using dispose of previous frame
convert -dispose background -delay 2x100 $images "$2"

# cleanup
rm "$end"
rm -rf "$tmpframeFolder"
