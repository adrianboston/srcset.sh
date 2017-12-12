# NAME

**srcset.sh** -- generate multiple responsive images for web and mobile.

## SYNOPSIS

`./srset.sh [-hmz] [-q quality] [—t type] [-l legacysize] [-s sizes] [-o out path] [-f filename] filename`   
`./srset.sh [-hmz] [—n findname] [-q quality] [—t type] [-l legacysize] [-s sizes] [-o out path] [-f file hierarchy] file hierarchy`

## DESCRIPTION

The srcset.sh utility generates multiple (eight) scaled versions of an image at particular breakpoints -- 320,480,640,768,960,1024,1280,1440 pixels wide -- that match common Mobile and widescreen viewports using Imagemagick's `convert` utility and outputs the needed `<img>` tag.

A file path, whether filename or file hierarcy is required. The options are as follows:

-f   specify a file path (single file or file hierarchy) for **srcset.sh** to convert. The file path may also be specified as the operands immediately following all the options. The directory will be traversed using the unix `find` command. The type of file path, whether file or file hierarchy is determined by **srcset.sh**.

-n   specify the pattern for **srset.sh** to find when converting multiple images. The pattern is passed to unix `find` and is equivalent to its `name` primary. The default pattern is `*.jpg`.

-t   specify the type of image conversion used by **srset.sh**; defaults to the same type as the input based on the file's extension. The pixel width and the suffix `w` is appended to the source filename such that the resulting filenames resembles the format, `src="[filename]-XXXw.[type]"` where `XXX` is the specified pixel width; thus, one of `-320w, -480w, -640w, -768w, -960w, -1024w, -1280w, -1440w`.

-q   specify the quality from 1 (lowest image quality) to 100 (best quality) of compression used by **srset.sh**; otherwise use the `convert` best fit for the source image. See [`convert's` manual](https://www.imagemagick.org/script/command-line-options.php#quality).

-l   specify the width in pixels set within the `src` attribute that is utilized by legacy browsers not supporting `srcset`. The resulting attribute references the specified width filename. Without, the default creates a copy of the original image **with no resizing**, appends the suffix `-srcw` such that the attribute resembles `src="[filename]-srcw"` followed by the extension. No `-srcw` file is created if a width is specified.

-o   specify a destination directory for the files converted by **srset.sh**. Otherwise the files are saved to the directory of the specified input file path.

-s   specify the `sizes` attribute found in the `<img>` tag; the default is `(min-width: 768px) 50vw, 100vw`.

-m   a flag with no argument directing **srcset.sh** to pipe the resulting `<img>` markup into a file. Without the flag **srcset.sh* will print the `<img>` markup to the console. 

-z   a flag with no argument directing **srcset.sh** to run a test or dry run. File paths are traversed but no images are generated and no new file path is created. The `<img>` markup will be generated to the console, a `-m` directive will be ignored.

-i   a flag with no argument directing **srcset.sh** to interlace the specified image using `convert`. Interlacing an image helps the user decide more quickly whether to abort a page download; interlacing is recommended by Google and webpagetest.org for speed but is not generally favored for image quality.

-h   display the help.

## Examples

The following examples are shown as given to the shell:

- `./srcset.sh images/background1.jpg`   
Generate a set of eight responsive images from one source file `images/background1.jpg` using the compression quality provided by `convert`. The created files are placed alongside the source files within the `images` directory. The resulting `<img>` tag is printed to the console.

- `./srcset.sh -q 90 -l 768 images/background1.jpg`   
Generate a set of eight responsive images from one source file `images/background1.jpg` using the compression quality of `90` and pixel size of `768` for the legacy `src` attribute. 

- `./srcset.sh images`   
Generate a set of eight responsive images for each of all files matching the default `*.jpg` pattern found in the `images` directory using the default compression provided by `convert`. The created files are placed alongside the source files within the `images` directory. The resulting `<img>` tag is printed to the console.

- `./srcset.sh -n "*.psd" -q 75 -m -o /var/htdocs/my-site images`   
Generate a set of responsive images from Photoshop files (files matching the `*.psd` pattern) found in the `images` directory using the compression quality of `75`. The created files are placed into the `/var/htdocs/my-site` directory and each `<img>` tag is saved into a  html file within the matching `/var/htdocs/my-site` output directory.

## The problem

Generating multiple responsive images using Photoshop, Lightroom or other GUI application is an irksome and error-prone task. Further, the needed `<img>` tag referencing multiple images in the `srcset` attribute is long and tedious to generate. On the other hand, the sweet script *srcset.sh* is a generator that can be be easily added into a automated build workflow. And that long `<img>` tag with the full set of `srcset` images is the standard output which can then be dropped into the target html file(s). 

In addition and of interest, *srcset.sh* permits the use of an image in its largest and highest resolution format including Photoshop's PSD and TIFF format -- that is often the second step after Nikon, Canon and other 'raw' native formats -- from which `convert` can generate the final HTML-ready images. Or you can stick with the tried JPEG, PNG and GIF. The full list of available formats are found [on Imagemagick's site](http://imagemagick.sourceforge.net/http/www/formats.html)

## Background

Images are eye-catching and  but usually the largest payload of a web site or page. Google suggests that a web page load in under 3 seconds or users will abandon the site. With Mobile the situation is aggravated: the connection is slower and expensive; users are even more likely to not bother waiting.

In comes the HTML5 `srcset` attribute to help, whether Mobile or desktop Web. The html `<img>` tag takes an optional set of images that should be scaled versions of the original. The Mobile or Web browser selects an image given its current width and resolution capabilities. 'srcset' recommends images that don't waste expensive Mobile bandwidth yet provide a image suitable for the device's resolution. In desktops the browser will select an image based on its current width (opposed to the device's width). In other words, the `srcset` attribute permits the use of an image that is not too big yet not too small. The `srcset` attribute is ignored and `src` is used in legacy browsers.

In order to speed up the web further it is suggested that images are compressed. There is no hard recommendation; `convert` uses `92` if it cannot determine a best fit. That runs high on the side of a image quality but low on overall web page download speed; load test a site for a balance between speed and beauty. During conversion *srcset.sh* will interlace the image versions as suggested by webpagetest.org.

### Requirements

Imagemagick's convert utility. https://www.imagemagick.org/script/convert.php

Download here https://www.imagemagick.org/script/download.php

##### Mac OS X Binary Release
[Imagemagick] recommend [MacPorts](https://www.macports.org/) which custom builds ImageMagick in your environment (some users prefer [Homebrew](https://brew.sh/). Download MacPorts and type:

`sudo port install ImageMagick`


### Useful Resources

##### Imagemagick list of formats
- http://imagemagick.sourceforge.net/http/www/formats.html

##### The srcset tag and responsive design
- https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images
- https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img
- https://css-tricks.com/responsive-images-youre-just-changing-resolutions-use-srcset/

##### Common screen sizes

- http://mediag.com/news/popular-screen-resolutions-designing-for-all/
- https://mydevice.io/devices/
- https://deviceatlas.com/blog/most-used-smartphone-screen-resolutions-in-2016

##### A word about Speed
- https://developers.google.com/speed/
- Use the following performance tool for measuring your web page speed https://www.webpagetest.org

### NOTES

- Make sure to `chmod u+x srcset.sh` for executable permissions
- Move to a known path such as `/usr/local/bin`
- Stick with release v0.0.5 if your shell lacks getops and then use the following for processing directories noting the use of `-a -name` to prevent file recursion

`find . -type f -atime +1s \( -name *.jpg -a ! -name "*-320w.*" -a ! -name "*-480w.*" -a ! -name "*-640w.*" -a ! -name "*-768w.*" -a ! -name "*-960w.*" -a ! -name "*-1024w.*" -a ! -name "*-1280w.*" -a ! -name "*-1440w.*" ! -name "*-srcw.*" \) -exec ./srcset.sh {} \;`
