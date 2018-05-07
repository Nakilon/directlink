[![Build Status](https://travis-ci.org/Nakilon/directlink.png?)](https://travis-ci.org/Nakilon/directlink)  
![Gem Version](https://badge.fury.io/rb/directlink.png?)

## Usage:

### Binary

```
$ gem install directlink
$ directlink
usage: directlink [--debug] [--json] <link1> <link2> <link3> ...
```
When known image hosting that has handy API is recognized, the API will be used and you'll have to create app there and provide env vars:
```
$ export IMGUR_CLIENT_ID=0f99cd781...
$ export FLICKR_API_KEY=dc2bfd348b...
$ export _500PX_CONSUMER_KEY=ESkHT...
```
Converts `<img src=` attribute value from any Google web service to its high resolution version:
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

### Library

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

irb> pp DirectLink "//4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg"
#<struct
 url=
  "https://4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/s0/IMG_20171223_093922.jpg",
 width=4160,
 height=3120,
 type=:jpeg>
```
Google can serve image in arbitrary resolution so `DirectLink.google` has optional argument to specify the width:
```
irb> DirectLink.google "//4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg", 100
=> "https://4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/s100/IMG_20171223_093922.jpg"
```
To silent the logger that `DirectLink.imgur` uses:
```ruby
DirectLink.silent = true
```

#### Retries

Some network exceptions like `SocketError` may be not permanent so `NetHTTPUtils` (that resolves redirect at the beginning of `DirectLink()` call) by default retries exponentially increasing retry delay until it gets to 3600sec, but such exceptions can have permanent reasons like dead web domain. To see it (may also want to pass `-v` if running minitest tests of DirectLink):
```ruby
NetHTTPUtils.logger.level = Logger::INFO
```
```
W 180507 102210 : NetHTTPUtils : retrying in 10 seconds because of SocketError 'Failed to open TCP connection to minus.com:80 (getaddrinfo: nodename nor servname provided, or not known)' at: http://minus.com/
```
To make `DirectLink()` respond faster set an optional argument that specifies the max retry delay to any numeric value. Here we get the exception immediately:
```ruby
DirectLink "http://minus.com/", 0
```
```
SocketError: Failed to open TCP connection to minus.com:80 (getaddrinfo: nodename nor servname provided, or not known) to http://minus.com/
```

## Notes:

* methods inside `DirectLink` by design return different sets of properties -- DirectLink unites them
* this gem is a 2 or 3 libraries united so don't expect tests to be full and consistent
* the `DirectLink::ErrorAssert` should never happen and you might report it if it does
* style: `@@` and lambdas are used to keep things private
* style: all exceptions should be classified as `DirectLink::Error*` or `FastImage::*`
* ~~don't pass raw user input to `NetHTTPUtils` -- contribute to gem FastImage and expect it to raise~~  
  alright, we now use NetHTTPUtils to resolve redirects and not doubt in link validity in some cases
