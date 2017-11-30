#!/bin/sh
if [[ $# -eq 0 ]] ; then
    echo 'Filename needed'
    exit 1
fi

filename="$1"
basename=${filename%.*}
type="${filename##*.}"

quality=80
if ! [[ -z "$2" ]] ; then
  quality=$2
fi
# change convert options as needed
options="-strip -interlace Plane -quality $quality"

echo "Resizing $filename to 320,480,640,768,960,1024,1280,1440 sizes using $quality quality"

# Various resizes
convert $options -adaptive-resize 320 "$filename" "$basename-320w.$type"
convert $options -adaptive-resize 480 "$filename" "$basename-480w.$type"
convert $options -adaptive-resize 640 "$filename" "$basename-640w.$type"
convert $options -adaptive-resize 768 "$filename" "$basename-768w.$type"
convert $options -adaptive-resize 960 "$filename" "$basename-960w.$type"
convert $options -adaptive-resize 1024 "$filename" "$basename-1024w.$type"
convert $options -adaptive-resize 1280 "$filename" "$basename-1280w.$type"
convert $options -adaptive-resize 1440 "$filename" "$basename-1440w.$type"
echo ""

echo '<img src="'$basename-768w.$type'" srcset="'$basename-320w.$type' 320w, '$basename-480w.$type' 480w, '$basename-640w.$type' 640w, '$basename-768w.$type' 768w, '$basename-960w.$type' 960w, '$basename-1024w.$type' 1024w, '$basename-1440w.$type' 1440w", sizes="(min-width: 768px) 50vw, 100vw" alt="An image named '$filename'"/>'
