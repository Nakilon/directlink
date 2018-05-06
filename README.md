Notes:
* use `DirectLink.silent = true` to supress the logger -- it is used only by `DirectLink::Imgur` yet
* methods inside `DirectLink` by design return different sets of properties -- DirectLink unites them
* methods may have arguments (`width=` in `google`) so they are public for external usage
* if the Imgur link is pointing to album/gallery it returns an array sorted descending by megapixels
* this gem is a 2 or 3 libraries united so don't expect tests to be full and consistent
* when known image hosting is recognized, the API will be used and you'll have to provide env vars:  
  `IMGUR_CLIENT_ID` or `FLICKR_API_KEY` or `_500PX_CONSUMER_KEY`
* the `DirectLink::ErrorAssert` should never happen and you might report it if it does
* style: `@@` and lambdas are used to keep things private
* style: all exceptions should be classified as `DirectLink::Error*` or `FastImage::*`
* we don't call `NetHTTPUtils` on user input -- we contribute to FastImage and allow it to raise
