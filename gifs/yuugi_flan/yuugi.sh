for ((d=0; d<30; d+=1))
do
  in_filename=$(printf "%s/%02d.png" yuugi_frames $d )
  out_filename=$(printf "%s/%02d.png" "out" $d )
  composite $in_filename yuugi_is_now_flan.png $out_filename

done
