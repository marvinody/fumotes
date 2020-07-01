# Steps

Crop (if needed), Cut (if needed) and scale to whatever reso. (l:r is required if cropping otherwise unexpected output)
`ffmpeg -i <input> -vf "crop=w:h:l:r,scale=128:128,fps=30" -c:a copy -ss 0 -t 2.5 <output>`

Look at individual frames if need to make clear loop
`ffmpeg -i <resized> "<folder>/%03d.png"`

Write all the frames into 1 file
`echo $(ls <folder>) $(ls <folder> | sort -hr) | tee frames.txt`

Create the gif
`convert -delay 1x30 @frames.txt <gif>.gif`

Resize to get below 256kb
`gifsicle --resize-width 100 <input> > <output>`

Discord will put black if canvas size and displayed image sizes don't match

The following command saved me in one scenario. Essentially puts the image on a transparent background so the "image" takes up the whole size and not just the dims of the cropped thing

`convert reimu_bot.gif -resize 309x309 -background transparent -compose Copy -gravity North -extent 309x309 -resize 128x128 reimu_test.gif`

Get info about delay frames
`identify -format "%f canvas=%Wx%H size=%wx%h offset=%X%Y %D %Tcs\n"`

make gif from frames in a folder
`convert -delay 2x100 $(find folder/ -type f | sort) output.gif`
