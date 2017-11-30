#!/bin/sh
if [[ $# -eq 0 ]] ; then
    echo 'File needed'
    exit 1
fi

input="$1"
pathfile=${input%.*}
type="${input##*.}"

quality=80
if ! [[ -z "$2" ]] ; then
  quality=$2
fi

final="$pathfile"
if ! [[ -z "$3" ]] ; then
  # filename with no path
  filename="${input##*/}"  
  final="$3/${filename%.*}"
fi

# change convert options as needed
options="-strip -interlace Plane -quality $quality"

echo "Resizing $input to 320,480,640,768,960,1024,1280,1440 sizes using $quality quality"

# Various resizes
convert $options -adaptive-resize 320 "$input" "$final-320w.$type"

convert $options -adaptive-resize 480 "$input" "$final-480w.$type"
convert $options -adaptive-resize 640 "$input" "$final-640w.$type"
convert $options -adaptive-resize 768 "$input" "$final-768w.$type"
convert $options -adaptive-resize 960 "$input" "$final-960w.$type"
convert $options -adaptive-resize 1024 "$input" "$final-1024w.$type"
convert $options -adaptive-resize 1280 "$input" "$final-1280w.$type"
convert $options -adaptive-resize 1440 "$input" "$final-1440w.$type"

str='<img src="'$final-480w.$type'" srcset="'$final-320w.$type' 320w, '$final-480w.$type' 480w, '$final-640w.$type' 640w, '$final-768w.$type' 768w, '$final-960w.$type' 960w, '$final-1024w.$type' 1024w, '$final-1440w.$type' 1440w", sizes="(min-width: 768px) 50vw, 100vw" alt="An image named '$input'"/>'

if ! [[ -z "$3" ]] ; then
  echo "$str" > "$final-srcset.html"
  echo "more $final-srcset.html"	
else
  echo "$str"
fi
