# srcset
A command line script that generates 8 scaled versions -- 320,480,640,768,960,1024,1280,1440 px wide matching common Mobile and widescreen desktop/laptop vieports -- of an image using imagemagick's convert utility and outputs that tiresome `<img/>` tag, which is then cut and pasted into the html.

## Background

Images are eye-catching but they are often the largest payload of a web site or page. Google suggests that a web page load in under 3 seconds or users will abandon the site. With Mobile the situation is aggravated: the connection is slower and expensive. So in comes the new `srcset` field to help. The html `<img/>` tag takes an optional set of images that are essentially scaled versions of the original. The Mobile or Web browser selects an image given its current width and resolution capabilities. The problem solved with srcset is recommending images that don't waste expensive Mobile bandwidth yet provide a image suitable for the device's resolution. In desktops the browser will select an image based on the current width of its window. In other words, the `srcset` field permits the use of an image that is not too big yet not too small. The `srcset` field is ignored and `src` is used in legacy browsers.

In order to speed up the web further it is suggested that images are compressed at particular quality. There is no hard recommendation but we use `80` as our default. During conversion srcset will interlace the image versions as suggested by webpagetest. Remove it from the script as needed.

## Usage

`./srset [imagename] [quality]`

- imagename is necessary 
- quality is optional and defaults to 80

## Example

./srset images/model_wavy_hair.jpg 90

## Output

`<img src="images/model_wavy_hair-768w.jpg" srcset="images/model_wavy_hair-320w.jpg 320w, images/model_wavy_hair-480w.jpg 480w, images/model_wavy_hair-640w.jpg 640w, images/model_wavy_hair-768w.jpg 768w, images/model_wavy_hair-960w.jpg 960w, images/model_wavy_hair-1024w.jpg 1024w, images/model_wavy_hair-1440w.jpg 1440w", sizes="(min-width: 768px) 50vw, 100vw" alt="An image named images/model_wavy_hair.jpg"/>`

## Requirements

Imagemagick's convert utility. https://www.imagemagick.org/script/convert.php

## Additional Resources

See the following links
https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images
https://developers.google.com/speed/

Use the following performance tool for measuring your web page speed.
https://www.webpagetest.org
