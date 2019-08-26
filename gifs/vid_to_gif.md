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
