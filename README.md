[![Build Status](https://travis-ci.org/Nakilon/directlink.png?)](https://travis-ci.org/Nakilon/directlink)  
![Gem Version](https://badge.fury.io/rb/directlink.png?)

# gem directlink

This tool converts any sort of image hyperlink (a thumbnail URL, a link to an album, etc.) to a high resolution one. Also it tells the resulting resolution and the image type (format). I wanted such automation often so I made a gem with a binary.

## Usage

### As a binary

```
$ gem install directlink
```
```
$ directlink
usage: directlink [--debug] [--json] [--github] <link1> <link2> <link3> ...
```
Converts `<img src=` attribute value from any Google web service (current Google regexes are very strict and may often fail -- it is a [defensive programming](https://en.wikipedia.org/wiki/Defensive_programming) practice -- report me your links!) to the largest available:
```
$ directlink //4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg
<= //4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg
=> https://4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/s0/IMG_20171223_093922.jpg
   jpeg 4160x3120
```
Retrieves all images from Imgur album or gallery, orders them by resolution from high to low:
```
$ directlink https://imgur.com/a/oacI3gl
<= https://imgur.com/a/oacI3gl
=> https://i.imgur.com/QpOBvRY.png
   image/png 460x460
=> https://i.imgur.com/9j4KdkJ.png
   image/png 100x100
```
Follows redirects:
```
$ directlink https://goo.gl/ySqUb5
<= https://goo.gl/ySqUb5
=> https://i.imgur.com/QpOBvRY.png
   image/png 460x460
```
Accepts multiple input links:
```
$ directlink https://imgur.com/a/oacI3gl https://goo.gl/ySqUb5
<= https://imgur.com/a/oacI3gl
=> https://i.imgur.com/QpOBvRY.png
   image/png 460x460
=> https://i.imgur.com/9j4KdkJ.png
   image/png 100x100
<= https://goo.gl/ySqUb5
=> https://i.imgur.com/QpOBvRY.png
   image/png 460x460
```
Emits JSON:
```
$ directlink --json https://imgur.com/a/oacI3gl https://avatars1.githubusercontent.com/u/2870363?100
[
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
  ],
  {
    "url": "https://avatars1.githubusercontent.com/u/2870363?100",
    "width": 460,
    "height": 460,
    "type": "jpeg"
  }
]
```
Downloads master:HEAD version of `lib/directlink.rb` from GitHub and uses it once instead of installed one (this is easier than installing gem from repo):
```
$ directlink --github https://imgur.com/a/oacI3gl
```
When an image hosting with known API is recognized, the API will be used and you'll have to create app there and provide env vars:
```
$ export IMGUR_CLIENT_ID=0f99cd781...
$ export FLICKR_API_KEY=dc2bfd348b...
```

### As a library

```
irb> require "directlink"
irb> require "pp"

irb> pp DirectLink "https://imgur.com/a/oacI3gl"
[#<struct
  url="https://i.imgur.com/QpOBvRY.png",
  width=460,
  height=460,
  type="image/png">,
 #<struct
  url="https://i.imgur.com/9j4KdkJ.png",
  width=100,
  height=100,
  type="image/png">]
```
Google can serve image in arbitrary resolution so `DirectLink.google` has an optional argument to specify the desired width:
```
irb> DirectLink.google "//4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg", 100
=> "https://4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/s100/IMG_20171223_093922.jpg"
```
To silent the logger that `DirectLink.imgur` uses:
```ruby
DirectLink.silent = true
```
You also may look into [`bin/directlink`](bin/directlink) for usage example.

#### about slow retries

Some network exceptions like `SocketError` may be not permanent (local network issues) so `NetHTTPUtils` (that resolves redirect at the beginning of `DirectLink()` call) by default retries exponentially increasing retry delay until it gets to 3600sec, but such exceptions can have permanent reasons like a canceled web domain. To see it:
```ruby
NetHTTPUtils.logger.level = Logger::WARN
```
```
W 180507 102210 : NetHTTPUtils : retrying in 10 seconds because of SocketError 'Failed to open TCP connection to minus.com:80 (getaddrinfo: nodename nor servname provided, or not known)' at: http://minus.com/
```
To make `DirectLink()` respond faster pass an optional argument that specifies the max retry delay as any numeric value. Here we get the exception immediately:
```ruby
DirectLink "http://minus.com/", 0
```
```
SocketError: Failed to open TCP connection to minus.com:80 (getaddrinfo: nodename nor servname provided, or not known) to http://minus.com/
```

## Notes:

* `module DirectLink` public methods return different sets of properties -- `DirectLink()` unites them
* the `DirectLink::ErrorAssert` should never happen and you might report it if it does
* style: `@@` and lambdas are used to keep things private
* this gem is a 2 or 3 libraries merged so don't expect tests to be full and consistent
