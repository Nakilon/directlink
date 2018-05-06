[![Build Status](https://travis-ci.org/Nakilon/directlink.png?)](https://travis-ci.org/Nakilon/directlink)  
![Gem Version](https://badge.fury.io/rb/directlink.png?)

TODO: make this README neat. Or not.

## Usage:
```
$ directlink
usage: directlink [--debug] [--json] <link1> <link2> <link> ...
```
Converts `<img src=` attributes from Google services to high resolution version:
```
$ directlink //4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg
https://4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/s0/IMG_20171223_093922.jpg
jpeg 4160x3120
```
Retrieves all images from Imgur albums and galleries, orders them by resolution:
```
$ directlink https://imgur.com/a/oacI3gl
https://i.imgur.com/QpOBvRY.png
image/png 460x460
https://i.imgur.com/9j4KdkJ.png
image/png 100x100
```
Accepts multiple input links:
```
$ directlink https://imgur.com/a/oacI3gl https://avatars1.githubusercontent.com/u/2870363?100
https://i.imgur.com/QpOBvRY.png
image/png 460x460
https://i.imgur.com/9j4KdkJ.png
image/png 100x100

https://avatars1.githubusercontent.com/u/2870363?100
jpeg 460x460
```
Emits JSON:
```
$ directlink --json https://avatars1.githubusercontent.com/u/2870363?100 https://imgur.com/a/oacI3gl
[
  {
    "url": "https://avatars1.githubusercontent.com/u/2870363?100",
    "width": 460,
    "height": 460,
    "type": "jpeg"
  },
  [
    {
      "url": "https://i.imgur.com/QpOBvRY.png",
      "width": 460,
      "height": 460,
      "type": "image/png"
    },
    {
      "url": "https://i.imgur.com/9j4KdkJ.png",
      "width": 100,
      "height": 100,
      "type": "image/png"
    }
  ]
]
```

## Notes:
* use `DirectLink.silent = true` to supress the logger -- it is used only by `DirectLink::Imgur` yet
* methods inside `DirectLink` by design return different sets of properties -- DirectLink unites them
* methods may have arguments (`width=` in `google`) so they are public for external usage
* this gem is a 2 or 3 libraries united so don't expect tests to be full and consistent
* when known image hosting is recognized, the API will be used and you'll have to provide env vars:  
  `IMGUR_CLIENT_ID` or `FLICKR_API_KEY` or `_500PX_CONSUMER_KEY`
* the `DirectLink::ErrorAssert` should never happen and you might report it if it does
* style: `@@` and lambdas are used to keep things private
* style: all exceptions should be classified as `DirectLink::Error*` or `FastImage::*`
* we don't call `NetHTTPUtils` on user input -- we contribute to FastImage and allow it to raise
