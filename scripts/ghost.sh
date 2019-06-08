#!/usr/bin/env bash
# call like ./ghost.sh junkoson.png junkosonghost.png
# makes no promises on filesizes

if [ -z "$1" ]
then
  echo "No image supplied"
  exit 1
elif [ -z "$2" ]
then
  echo "No output image supplied"
  exit 2
fi

convert "$1" -modulate 100,0 -alpha set -channel A -evaluate divide 1.5 "$2"
