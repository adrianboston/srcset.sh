#!/bin/sh

usage() {
	echo "Usage: $0 [-s] -d directory —n find name -f filename -q quality —t type -l legacysize -o out directory "
}

convert_file() {
	# path and no filenames
	path=${filename%/*}

	# path and filename with no extension or type
	pathfile=${filename%.*}

	# extension or type (jpg, png, etc) either from current file OR from -t option
	if ! [[ -z "$desttype" ]] ; then
		type="$desttype"
	else
		type="${filename##*.}"
	fi

	# if out directory is empty then create file in same directory as file
	if [[ -z "$outdir" ]] ; then
		outprefix="$pathfile"
	else
		# filename with no path
		nopath="${filename##*/}"
		outprefix="$outdir/$pathfile"
		# make a directory with all parents if needed
		mkdir -p "$outdir/$path"
	fi	

	# change convert options as needed. recommend that psd files use -flatten
     # uuse convert defalt quality that is the best possible
     options="-strip -interlace Plane"
     if ! [[ -z $quality ]] ; then
          options="$options -quality $quality"
     fi

	echo "Resizing $filename to 320,480,640,768,960,1024,1280,1440 sizes"

	# Various resizes
	convert $options -adaptive-resize 320 "$filename" "$outprefix-320w.$type"
	convert $options -adaptive-resize 480 "$filename" "$outprefix-480w.$type"
	convert $options -adaptive-resize 640 "$filename" "$outprefix-640w.$type"
	convert $options -adaptive-resize 768 "$filename" "$outprefix-768w.$type"
	convert $options -adaptive-resize 960 "$filename" "$outprefix-960w.$type"
	convert $options -adaptive-resize 1024 "$filename" "$outprefix-1024w.$type"
	convert $options -adaptive-resize 1280 "$filename" "$outprefix-1280w.$type"
	convert $options -adaptive-resize 1440 "$filename" "$outprefix-1440w.$type"

	if [[ -z "$legacysize" ]] ; then
          # We need to make a copy of the original with no resize
          convert $options "$filename" "$outprefix-srcset.$type"
		srcsuffix="-legacysrc"
	else
		srcsuffix="-$legacysize"w
	fi

	str='<img src="'$outprefix$srcsuffix.$type'" srcset="'$outprefix-320w.$type' 320w, '$outprefix-480w.$type' 480w, '$outprefix-640w.$type' 640w, '$outprefix-768w.$type' 768w, '$outprefix-960w.$type' 960w, '$outprefix-1024w.$type' 1024w, '$outprefix-1440w.$type' 1440w", sizes="(min-width: 768px) 50vw, 100vw" alt="An image named '$filename'"/>'

	# if no directory given then print to console
	if [ $issave = false ] ; then
		echo "$str"
	else
		echo "$str" > "$outprefix-srcset.html"
		echo "more $outprefix-srcset.html"	
	fi
}


findfiles() {
	# do a if in order to pass on the -s option in exec
	if ! [[ -z "$desttype" ]] ; then
		type="$desttype"
	else
		type="*"
	fi

	if [ $issave = false ] ; then
		find "$dirname" -type f -atime +1s \( -name "$findname" -a ! -name "*-320w*.$type" -a ! -name "*-480w*.$type" -a ! -name "*-640w*.$type" -a ! -name "*-768w*.$type" -a ! -name "*-960w*.$type" -a ! -name "*-1024w*.$type" -a ! -name "*-1280w*.$type" -a ! -name "*-1440w*.$type" ! -name "*-srcset.*" \) -exec "$0" -f {} -q "$quality" -t "$desttype" -o "$outdir" -l "$legacysize" \;
	else
		find "$dirname" -type f -atime +1s \( -name "$findname" -a ! -name "*-320w*.$type" -a ! -name "*-480w*.$type" -a ! -name "*-640w*.$type" -a ! -name "*-768w*.$type" -a ! -name "*-960w*.$type" -a ! -name "*-1024w*.$type" -a ! -name "*-1280w*.$type" -a ! -name "*-1440w*.$type" ! -name "*-srcset.*" \) -exec "$0" -f {} -q "$quality" -t "$desttype" -o "$outdir" -l "$legacysize" -s \;
	fi
}


# ————— main —————
dirname=""
filename=""
outdir=""
quality=""
legacysize=""
issave=false
findname="*.jpg"
desttype=""

while getopts ":q:d:n:f:o:l:t:sh" option; do
  case "$option" in
  d)
	dirname="$OPTARG" 
	if ! [ -e "$dirname" ] || ! [ -d "$dirname" ] ; then
    		echo 'Directory is invalid $dirname'
		exit 1
	fi
	# strip any trailing slash from the dir_name value
	dirname="${dirname%/}"
	;; 
  n)
	findname="$OPTARG" 
	;;
  t)
	desttype="$OPTARG" 
	;;
  q)
	quality="$OPTARG" 
	;;
  o)
	outdir="$OPTARG" 
	# strip any trailing slash from the dir_name value
	outdir="${outdir%/}"
	;;
  f)
	filename="$OPTARG" 
	if ! [ -e "$filename" ] || ! [ -f "$filename" ] ; then
    		echo 'File is invalid $filename'
		exit 1
	fi
	;;
  s)
	issave=true
	;;
  l)
	legacysize="$OPTARG"
	;;
  h)
     echo "HELP"
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

# if filename is not empty
if ! [[ -z "$filename" ]] ; then
	convert_file
	exit 1
fi

if ! [[ -z "$dirname" ]] ; then
	findfiles
	exit 1
fi

# need either filename or dir so error
echo "Error: Needs -f filename or -d directory" >&2
usage








  
