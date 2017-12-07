# NAME

**srcset.sh** -- generate multiple responsive images for web and mobile

## SYNOPSIS

`./srset.sh [-hs] -f filename —t type -q quality -l legacysize -o out directory`   
`./srset.sh [-hs] -d directory -n name —t type -q quality -l legacysize -o out directory`

## DESCRIPTION

The srcset.sh utility generates eight scaled versions -- *320,480,640,768,960,1024,1280,1440 pixels wide* -- of an image that match common Mobile and widescreen desktop/laptop viewports using Imagemagick's `convert` utility and outputs the needed `<img>` tag.

A filename *or* directory is needed for basic usage. The options are as follows:

-f   specify a source file for **srcset.sh** to convert.

-d   specify a directory for **srset.sh** to convert. The directory will be traversed using the unix `find` command.  

-n   specify the extension for **srset.sh** to find when converting multiple images; default is `*.jpg`.  

-t   specify the destination type of image conversion used by **srset.sh**; defaults to the same type as the input based on extension.  

-q   specify the quality of compression used by **srset.sh**; otherwise uses `converts` default that is suited to source image. See [`convert's` manual](https://www.imagemagick.org/script/command-line-options.php#quality).  

-l   specify the pixel size to use within the `src` attribute that is used by legacy browsers not supporting `srcset`.  

-o   specify a destination directory for the file or files converted by **srset.sh**. Otherwise the file is saved to the input file directory. The tree hierarchy is reserved.  

-s   a flag with no value to specify whether to save the resulting `<img>` tag in a html file; default is to not save and print the tag to console.  

-h   display the help.  

Typical usage when converting a single file uses the -f flag:   
`./srset.sh [-s] -f filename -q quality —t type -l legacysrc -o out directory`

Typical usage when converting several files of a type in a directory:   
`./srset.sh [-s] -d directory —n find name -q quality —t type -l legacysrc -o out directory`

## Example

The following converts one file `images/model_wavy_hair.jpg` using the compression quality of 90 and pixel size of 768 for the legacy `src`:

`./srset.sh -f /Website/images/model_wavy_hair.jpg -q 90 -l 768`

The ouput shows the set of images plus the `-768w` suffix in the `src` legacy attribute:

`<img src="images/model_wavy_hair-768w.jpg" srcset="images/model_wavy_hair-320w.jpg 320w, images/model_wavy_hair-480w.jpg 480w, images/model_wavy_hair-640w.jpg 640w, images/model_wavy_hair-768w.jpg 768w, images/model_wavy_hair-960w.jpg 960w, images/model_wavy_hair-1024w.jpg 1024w, images/model_wavy_hair-1440w.jpg 1440w", sizes="(min-width: 768px) 50vw, 100vw" alt="An image named images/model_wavy_hair.jpg"/>`

The following converts all the images ending in .jpg found in the `Website/images` folder using the compression quality of 75; the created files are placed into the `/var/htdocs/my-site` directory and each `<img>` tag is saved into a  html file within the output directory:  

`./srset.sh -d Website/images -n "*.jpg" -q 75 -o /var/htdocs/my-site -s`

## The problem

Generating multiple responsive images using Photoshop, Lightroom or other GUI application is an irksome and error-prone task. Further, the needed `<img>` tag referencing multiple images in the `srcset` attribute is long and tedious to generate. On the other hand, the sweet script *srcset.sh* can be be easily added into a automated build workflow. And that long `<img>` tag with the full set of `srcset` images is generated which can then be pasted from the console or from the saved file with a few simple flicks of the ol' ctrl-v wrist. 

In addition and of interest, *srcset.sh* permits the use of an image in its largest and highest resolution format including Photoshop's PSD and TIFF format -- that is often the second step after Nikon, Canon and other 'raw' native formats -- from which `convert` can generate the final HTML-ready images. Or you can stick with the tried JPEG, PNG and GIF. The full list of available formats are found [on Imagemagick's site](http://imagemagick.sourceforge.net/http/www/formats.html)


## Background

Images are eye-catching but usually the largest payload of a web site or page. Google suggests that a web page load in under 3 seconds or users will abandon the site. With Mobile the situation is aggravated: the connection is slower and expensive; users are even more likely to not bother waiting.

In comes the HTML5 `srcset` attribute to help, whether Mobile or desktop Web. The html `<img>` tag takes an optional set of images that should be scaled versions of the original. The Mobile or Web browser selects an image given its current width and resolution capabilities. 'srcset' recommends images that don't waste expensive Mobile bandwidth yet provide a image suitable for the device's resolution. In desktops the browser will select an image based on its current width (opposed to the device's width). In other words, the `srcset` attribute permits the use of an image that is not too big yet not too small. The `srcset` attribute is ignored and `src` is used in legacy browsers.

In order to speed up the web further it is suggested that images are compressed to a particular quality. There is no hard recommendation; `convert` uses `92` if it cannot determine a best fit. That number runs high on the side of a  image quality and low on overall web page download speed. During conversion *srcset.sh* will interlace the image versions as suggested by webpagetest.org. Remove it from the script as needed.

### Requirements

Imagemagick's convert utility. https://www.imagemagick.org/script/convert.php

Download here https://www.imagemagick.org/script/download.php

#### Mac OS X Binary Release
[They] recommend MacPorts which custom builds ImageMagick in your environment (some users prefer Homebrew). Download MacPorts and type:

`sudo port install ImageMagick`


### Useful Resources

##### Imagemagick list of formats
- http://imagemagick.sourceforge.net/http/www/formats.html

The srcset tag and responsive design
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
- Stick with release v0.0.5 if your shell lacks getops and then use the following for processing directories noting the use of `-a -name` to prevent file recursion

`find . -type f -atime +1s \( -name *.jpg -a ! -name "*-320w.*" -a ! -name "*-480w.*" -a ! -name "*-640w.*" -a ! -name "*-768w.*" -a ! -name "*-960w.*" -a ! -name "*-1024w.*" -a ! -name "*-1280w.*" -a ! -name "*-1440w.*" ! -name "*-srcset.*" \) -exec ./srcset.sh {} \;`
