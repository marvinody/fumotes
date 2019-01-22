#!/usr/bin/env bash
# used to make seki frames to pinged frames
# call with input dir followed by output dir
# then
# convert -delay 5 $(find seki_ping_frames/ -type f| sort | tr '\n' ' ') seki_ping_deattachment.gif
# where you change 65 until size is just under 256kb
# gifsicle seki_ping_deattachment.gif --resize-width 65 > seki_ping_detachment_resized.gif

for Output in $(ls $1)
do
  composite -geometry 30x30+1+1 ~/Downloads/fumotes/ping.png "$1/$Output" "$2/$Output"
done
