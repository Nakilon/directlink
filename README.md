[![Test](https://github.com/Nakilon/directlink/workflows/.github/workflows/test.yaml/badge.svg)](https://github.com/Nakilon/directlink/actions)

# gem directlink

This tool obtains from any sort of hyperlink (a thumbnail URL, a link to a photo album, a news article, etc.) a directlink(s) to high resolution images at that page. Also it tells the resulting resolution and the image type (format). The gem also includes a binary so you can use it as a CLI.

## Usage

### As an executable

```
$ gem install directlink
```
```
$ directlink
usage: directlink [--debug] [--json] [--github] <link1> <link2> <link3> ...
```
Converts `<img src=` attribute value from any Google web service to the largest available:
```
$ directlink //4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg
<= //4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg
=> https://4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/s0/IMG_20171223_093922.jpg
   jpeg 4160x3120
```
Given the link to a page it tries to find the main image on it.
```
$ directlink https://plus.google.com/107956229381790410785/posts/Gu9apRHri41
<= https://plus.google.com/107956229381790410785/posts/Gu9apRHri41
=> https://lh3.googleusercontent.com/-mRDjiHoDA30/W0mndQaRXeI/AAAAAAAAfyA/NhZGMAoQsbAb8cUFDzNWh-NXQ9O-YQhuQCJoC/s0/001
   jpeg 2000x1328
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
By default tries to parse the `<meta property="og:image"` tag in the "don't give up" mode but can also ignore it:
```
$ directlink --ignore-meta https://www.kp.ru/daily/26342.7/3222103/
<= https://www.kp.ru/daily/26342.7/3222103/
=> https://s11.stc.all.kpcdn.net/share/i/12/8024261/wx1080.jpg
   jpeg 1080x653
=> https://s13.stc.all.kpcdn.net/share/i/12/8024233/wx1080.jpg
   jpeg 1080x653
...
```
Downloads `master:HEAD` version of `lib/directlink.rb` from GitHub and uses it once instead of installed one:
```
$ directlink --github https://imgur.com/a/oacI3gl
```
When an image hosting with known API is recognized, it will try to use the API tokens you've provided as env vars (otherwise it will go the "don't give up" mode):
```
$ export IMGUR_CLIENT_ID=0f99cd781...
$ export FLICKR_API_KEY=dc2bfd348b...
$ export REDDIT_SECRETS=secrets.yaml
$ export VK_ACCESS_TOKEN=2f927d82d...
```
(check the format of reddit secrets file in the [reddit_bot gem dependency README](https://github.com/Nakilon/reddit_bot/#usage))

#### the "don't give up mode"

If the passed link is not the image link or a photo page of a known image hosting, the tool is still able to find the main images that the linked webpage contains. Like in the second example of this README or here -- it found three images in the markdown file:
```
$ directlink https://github.com/Nakilon/dhash-vips
<= https://github.com/Nakilon/dhash-vips
=> https://camo.githubusercontent.com/852607c7f4b604fc3c83b782c4f6983cf488b0d4/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f64686173682d766970732e6e616b696c6f6e2e70726f2f64686173685f69737375655f6578616d706c652e706e67
   png 592x366
=> https://camo.githubusercontent.com/5e354666bac69e32d605dbd45351bfb7d808924b/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f64686173682d766970732e6e616b696c6f6e2e70726f2f6964686173685f6578616d706c655f696e2e706e67
   png 773x679
=> https://camo.githubusercontent.com/5456cc20ae9b20c06792ddd19b533ae36404d8c1/68747470733a2f2f73746f726167652e676f6f676c65617069732e636f6d2f64686173682d766970732e6e616b696c6f6e2e70726f2f6964686173685f6578616d706c655f6f75742e706e67
   png 1610x800
```
It can even find images in the Markdown body of a Reddit self post! (new feature, needs more testing)

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
To disable the "don't give up" mode (otherwise it consumes time on analyzing all the images on the linked page):
```
irb> DirectLink "https://github.com/Nakilon/dhash-vips", nil, true
# raises FastImage::UnknownImageType
```
To silent the STDOUT logger that you may see sometimes:
```ruby
DirectLink.silent = true
```
You also may look into [`bin/directlink`](bin/directlink) as a library usage example and the list of all possible exceptions.

#### about long retries

Some network exceptions like `SocketError` may be not permanent (local network issues) so `NetHTTPUtils` (that resolves redirect at the beginning of `DirectLink()` call) by default retries exponentially increasing retry delay until it gets to 3600sec, but such exceptions can have permanent reasons like a canceled web domain. To see it:
```ruby
NetHTTPUtils.logger.level = Logger::WARN
```
```
W 180507 102210 : NetHTTPUtils : retrying in 10 seconds because of SocketError 'Failed to open TCP connection to minus.com:80 (getaddrinfo: nodename nor servname provided, or not known)' at: http://minus.com/
```
To make `DirectLink()` respond faster pass an optional argument that specifies the max retry delay. Here we get the exception immediately:
```ruby
DirectLink "http://minus.com/", 0
```
```
SocketError: Failed to open TCP connection to minus.com:80 (getaddrinfo: nodename nor servname provided, or not known) to http://minus.com/
```

#### Ruby 2.0

The `addressable` dependency (for proper URI parsing) has a dependency that by default wants Ruby 2.1 or higher. You may fix it safely by adding this line to your `Gemfile`:
```
gem "jwt", "<2"
```
Possibly you will instead have a problem with `kramdown` gem -- solve it the same way:
```
gem "kramdown", "<2"
```

(`<2` here has nothing to do with the Ruby version -- it's just a coincidence)

## Notes:

* `module DirectLink` public methods return different sets of properties -- `DirectLink()` unites them
* the `ErrorAssert`, `ErrorMissingEnvVar` and `URI::InvalidURIError` should never be raised and you might report it
* this gem is a historically 2 or 3 libraries merged -- this is why tests may look awkward
* 500px.com has discontinued API in June 2018 -- the tool now uses undocumented methods
* `DirectLink()` can return an Array of Structs for 1) Imgur 2) Reddit unless `giveup = true` is set

## Development notes/examples:

```bash
bundle install
(source api_tokens.sh && bundle exec ruby unit.test.rb)
```
```bash
# for webmocking new reddit tests:
REDDIT_SECRETS=reddit_token.yaml.secret bundle exec ruby unit.test.rb
# json_pp < body.txt | pbcopy
ruby -rpp -rjson -e "pp JSON File.read 'body.txt'" | pbcopy

# for webmocking new vk tests:
# disable the getById stub, source real secrets
(source api_tokens.sh && bundle exec ruby unit.test.rb -n '/vk#test_0012_kinds of links/')
ruby -rpp -rjson -e "pp JSON File.read 'body.txt'" | pbcopy
# edit and enable the getById stub
# edit expectation

# obfuscate urls when done
ruby -e "puts \`pbpaste\`.chars.sort.join"
```
```bash
bundle exec ruby -I./lib ./bin/directlink --debug ...
```
```bash
(source api_tokens.sh.secret && bundle exec ruby integration.test.rb)
```
```bash
env $(cat api_tokens.sh.secret | xargs) bundle exec ruby integration.test.rb -n '/kinds of links vk/'
```

`CI` env var skips vk sleep.

TODO: maybe make all these web service specific methods private and discourage to use them since they all return very different things and sometimes don't raise exceptions while the `DirectLink()` does  
TODO: what should `--json` print if exception was thrown?  
TODO: looped prompt mode
