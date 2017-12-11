#!/bin/sh

usage() {
	echo "usage: $0 [-hmz] [-q quality] [—t type] [-l legacysize] [-s sizes] [-o outdirectory] [-f filename] filename"
     echo "usage: $0 [-hmz] [—n findname] [-q quality] [—t type] [-l legacysize] [-s sizes] [-o outpath] [-f filepath] filepath"
}

convert_file() {
	# path and no filenames
	path=${filename%/*}

	# path and filename with no extension or type
	pathfile=${filename%.*}

	# extension or type (jpg, png, etc) either from current file OR from -t option
	if ! [ -z "$desttype" ] ; then
		type="$desttype"
	else
		type="${filename##*.}"
	fi

	# if out directory is empty then create file in same directory as file
	if [ -z "$outdir" ] ; then
		outprefix="$pathfile"
	else
		# filename with no path
		nopath="${filename##*/}"
		outprefix="$outdir/$pathfile"

		# make a directory with all parents if needed -- unless running a test
          if [ -z "$istest" ] ; then
               mkdir -p "$outdir/$path"
          fi
	fi	

	# change convert options as needed. recommend that psd files use -flatten
     # uuse convert defalt quality that is the best possible
     options="-strip -interlace Plane"
     if ! [ -z "$quality" ] ; then
          options="$options -quality $quality"
     fi

	echo "Resizing $filename"

     if [ -z "$istest" ] ; then
          # Various resizes
          convert $options -adaptive-resize 320 "$filename" "$outprefix-320w.$type"
          convert $options -adaptive-resize 480 "$filename" "$outprefix-480w.$type"
          convert $options -adaptive-resize 640 "$filename" "$outprefix-640w.$type"
          convert $options -adaptive-resize 768 "$filename" "$outprefix-768w.$type"
          convert $options -adaptive-resize 960 "$filename" "$outprefix-960w.$type"
          convert $options -adaptive-resize 1024 "$filename" "$outprefix-1024w.$type"
          convert $options -adaptive-resize 1280 "$filename" "$outprefix-1280w.$type"
          convert $options -adaptive-resize 1440 "$filename" "$outprefix-1440w.$type"
     fi

	if [ -z "$legacysize" ] ; then
          # We need to make a copy of the original with no resize
		srcsuffix="-srcw"
          if [ -z "$istest" ] ; then
               convert $options "$filename" "$outprefix-srcw.$type"
          fi
	else
		srcsuffix="-$legacysize"w
	fi

	str='<img src="'$outprefix$srcsuffix.$type'" srcset="'$outprefix-320w.$type' 320w, '$outprefix-480w.$type' 480w, '$outprefix-640w.$type' 640w, '$outprefix-768w.$type' 768w, '$outprefix-960w.$type' 960w, '$outprefix-1024w.$type' 1024w, '$outprefix-1440w.$type' 1440w", sizes="'$sizes'" alt="An image named '$filename'"/>'

     # if 'save' argument then save to file
     if [ -z "$ismarkup" ] || ! [ -z "$istest" ] ; then
		echo "$str"
	else
		echo "$str" > "$outprefix-srcset.html"
		echo "more $outprefix-   srcset.html"
	fi
}


find_files() {
     find "$dirname" -type f -atime +1s \( -name "$pattern" -a ! -name "*-320w.*" -a ! -name "*-480w.*" -a ! -name "*-640w.*" -a ! -name "*-768w.*" -a ! -name "*-960w.*" -a ! -name "*-1024w.*" -a ! -name "*-1280w.*" -a ! -name "*-1440w.*" ! -name "*-srcw.*" \) -exec "$0" -q "$quality" -t "$desttype" -o "$outdir" -l "$legacysize" -s "$sizes" $ismarkup $istest {} \;

}

# —————————————————————————————— main ——————————————————————————————
dirname=""
filename=""
outdir=""
quality=""
legacysize=""
ismarkup=""
istest=""
pattern="*.jpg"
desttype=""
sizes="(min-width: 768px) 50vw, 100vw"

# now get options
while getopts ":f:n:q:o:s:t:l:hmz" option; do
  case "$option" in
  f)
	tmp="$OPTARG"
	;;
  n)
	pattern="$OPTARG" 
	;;
  q)
	quality="$OPTARG" 
	;;
  o)
     outdir="$OPTARG"
     # strip any trailing slash from the dir_name value
     outdir="${outdir%/}"
     ;;
  s)
     sizes="$OPTARG"
     ;;
  m)
     # This trick is used for rercusive shells (see the find arguments)
     ismarkup="-m"
	;;
  z)
     # This trick is used for rercusive shells (see the find arguments)
     istest="-z"
     ;;
  t)
     desttype="$OPTARG"
     ;;
  l)
	legacysize="$OPTARG"
	;;
  h)
     usage
     exit 0
     ;;
  :)
     echo "Error: -$OPTARG requires an argument" >&2
     usage
     exit 1
     ;;
  \?)
     echo "Error: unknown option -$OPTARG" >&2
     usage
     exit 1
     ;;
  esac
done

# LAST parameter *may* to be file or directory. if none specifed (using -f) then use last argument
if [ -z "$tmp" ] ; then
          isfile="${!#}"
     else
          isfile="$tmp"
fi

# need either filename or dir so error
if [ -z "$isfile" ] || [ -b "$isfile" ] || [ -c "$isfile" ] || ! [ -e "$isfile" ] ; then
     echo "Error: Needs valid filename or directory as argument" >&2
     usage
     exit 1
fi

# if filename is not empty then we convert a single file
if [ -f "$isfile" ]; then
     filename="$isfile"
     convert_file
     exit 1
fi

if [ -d "$isfile" ] ; then
     dirname="$isfile"
     # strip any trailing slash from the filename value
     dirname="${dirname%/}"
     find_files
     exit 1
fi

echo 'File or directory is required $isfile' >&2
usage
exit 1









  
