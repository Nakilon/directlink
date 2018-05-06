Notes:
* use `DirectLink.silent = true` to supress the logger -- it is used only by DirectLink::Imgur yet
* methods inside DirectLink by design return different sets of properties -- DirectLink unites them
* some even have arguments (like `s=` in `google`) so they are public for usage outside of DirectLink
* this gem is a 2 or 3 libraries united so don't except tests to be full and consistent
* style: `@@` and lambdas are used to keep things private
* style: exceptions should be classified as `DirectLink::Error*` or `FastImage::ImageFetchFailure`
* we don't call NetHTTPUtils on user input -- we contribute to FastImage and allow it to raise
