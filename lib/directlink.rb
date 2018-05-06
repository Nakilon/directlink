module DirectLink

  class << self
    attr_accessor :silent
  end
  self.silent = false
  class << self
    attr_accessor :logger
  end
  self.logger = Object.new
  self.logger.define_singleton_method :error do |str|
    puts str unless Module.nesting.first.silent
  end

  class ErrorMissingEnvVar < RuntimeError ; end
  class ErrorAssert < RuntimeError
    def initialize msg
      super "#{msg} -- consider reporting this issue to GitHub"
    end
  end
  @@LoggingError = Class.new RuntimeError do
    def initialize msg
      Module.nesting.first.logger.error msg
      super msg
    end
  end
  class ErrorNotFound < @@LoggingError ; end
  class ErrorBadLink < @@LoggingError
    def initialize link
      super "#{link.inspect} -- if you think this link is valid, please report the issue"
    end
  end


  def self.google src, width = 0
    case src
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[n-r][a-zA-Z0-9_-]{8}I\/AAAAAAAA[bA-V][a-zA-Z0-9]{2}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w[1-4]\d\d-h(318|353|727)-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAA[a-zA-Z0-9_-]{4}\/[a-zA-Z0-9_-]{33}(?:CJoC|CL0B(?:GAs)?)\/)w530(?:-d)?-h[2-9]\d\d-n(\/[^\/]+)\z/
      "#{$1}s#{width}#{$2}"
    when /\A(\/\/lh3\.googleusercontent\.com\/proxy\/[a-zA-Z0-9_-]{66,523}=)(?:w(?:464|504|530)-h[2-7]\d\d-[np]|s530-p)\z/
      "https:#{$1}s#{width}"
    when /\A(\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAA[AC][a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{32}[gw]CJoC\/)w530-h3\d\d-p(\/[^\/]+)\z/,
         /\A(\/\/[14]\.bp\.blogspot\.com\/-[a-zA-Z0-9_-]{11}\/W[np][a-zA-Z0-9_-]{8}I\/AAAAAAAA[DE][a-zA-Z0-9_-]{2}\/[a-zA-Z0-9_-]{33}C(?:Lc|Kg)BGAs\/)w530-h278-p(\/[^\/]+)\z/
      "https:#{$1}s#{width}#{$2}"
    else
      raise ErrorBadLink.new src
    end
  end

  require "json"
  require "nethttputils"

  def self.imgur link
    raise ErrorMissingEnvVar.new "define IMGUR_CLIENT_ID env var" unless ENV["IMGUR_CLIENT_ID"]

    case link
    when /\Ahttps?:\/\/((m|i|www)\.)?imgur\.com\/(a|gallery)\/[a-zA-Z0-9]{5}(#[a-zA-Z0-9]{2})?\z/,
         /\Ahttps?:\/\/imgur\.com\/gallery\/[a-zA-Z0-9]{5}\/new\z/
      raise ErrorBadLink.new link unless /\/(?<type>a|gallery)\/(?<id>[a-zA-Z0-9]{5})/ =~ link
      timeout = 1
      json = begin
        NetHTTPUtils.request_data "https://api.imgur.com/3/#{
          # type == "gallery" ? "gallery" : "album"
          "album"
        }/#{id}/0.json", header: { Authorization: "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
      rescue NetHTTPUtils::Error => e
        case e.code
        when 500
          logger.error "retrying in #{timeout} seconds because of Imgur HTTP ERROR 500"
          sleep timeout
          timeout *= 2
          retry
        when 404 ; raise ErrorNotFound.new link.inspect
        else ; raise ErrorAssert.new "unexpected http error for #{link}"
        end
      end
      data = JSON.load(json)["data"]
      if data["error"]
        raise ErrorAssert.new "unexpected error #{data.inspect} for #{link}"
      elsif data["images"]
        data["images"]
      elsif data["type"] && data["type"].start_with?("image/")
        [ data ]
      # elsif data["comment"]
      #   fi["https://imgur.com/" + data["image_id"]]
      else
        # one day single-video item should hit this but somehow it didn't yet
        raise ErrorAssert.new "unknown data format #{data.inspect} for #{link}"
      end
    when /\/\/i\./,
         /\Ahttps?:\/\/((m|www)\.)?imgur\.com\/(gallery\/|r\/[A-Za-z0-9][A-Za-z0-9_]{2,20}\/)?[a-zA-Z0-9]{5}([a-zA-Z0-9]{2})?(\?r|\?third_party=1#_=_|\/new|\.jpg|\.gifv|\.mp4)?\z/
      json = begin
        NetHTTPUtils.request_data "https://api.imgur.com/3/image/#{
          link[/(?<=\/)[a-zA-Z0-9]{5}([a-zA-Z0-9]{2})?(?=(\?r|\?third_party=1#_=_|\/new|\.(?:jpg|gifv|mp4|png))?\z)/] or \
            raise ErrorBadLink.new link
        }/0.json", header: { Authorization: "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
      rescue NetHTTPUtils::Error => e
        raise ErrorNotFound.new link.inspect if e.code == 404
        raise ErrorAssert.new "unexpected http error for #{link}"
      end
      [ JSON.load(json)["data"] ]
    when /\Ahttps:\/\/imgur\.com\/[a-zA-Z0-9]{5}\z/
      json = NetHTTPUtils.request_data "https://api.imgur.com/3/image/#{
        # we don't rescue this only because currently the regex is compatible with one two lines higher
        link[/(?<=\/)[a-zA-Z0-9]{5}\z/]
      }/0.json", header: { Authorization: "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
      [ JSON.load(json)["data"] ]
    else
      raise ErrorBadLink.new link
    end.map do |image|
      case image["type"]
      when "image/jpeg", "image/png", "image/gif", "video/mp4"
        image.values_at "link", "width", "height", "type"
      else
        raise ErrorAssert.new "unknown type of #{link}: #{image}"
      end
    end
  end

  def self._500px link
    raise ErrorBadLink.new link unless %r{\Ahttps://500px\.com/photo/(?<id>[^/]+)/[^/]+\z} =~ link
    raise ErrorMissingEnvVar.new "define _500PX_CONSUMER_KEY env var !!! WARNING: the 500px.com deprecates their API in summer of 2018 !!!" unless ENV["_500PX_CONSUMER_KEY"]
    JSON.load( NetHTTPUtils.request_data "https://api.500px.com/v1/photos/#{id}", form: {
      image_size: 2048,
      consumer_key: ENV["_500PX_CONSUMER_KEY"],
    } )["photo"].values_at "width", "height", "image_url", "image_format"  # could also get "camera" and "taken_at"
  end

  def self.flickr link
    raise ErrorBadLink.new link unless %r{\Ahttps://www\.flickr\.com/photos/[^/]+/(?<id>[^/]+)} =~ link ||
                                       %r{\Ahttps://flic\.kr/p/(?<id>[^/]+)\z} =~ link
    raise ErrorMissingEnvVar.new "define FLICKR_API_KEY env var" unless ENV["FLICKR_API_KEY"]

    flickr = lambda do |id, method|
      JSON.load NetHTTPUtils.request_data "https://api.flickr.com/services/rest/", form: {
        api_key: ENV["FLICKR_API_KEY"],
        format: "json",
        nojsoncallback: 1,
        photo_id: id,
        method: "flickr.photos.#{method}",
      }
    end
    json = flickr.call id, "getSizes"
    raise ErrorNotFound.new link.inspect if json == {"stat"=>"fail", "code"=>1, "message"=>"Photo not found"}
    raise ErrorAssert.new "unhandled API response stat for #{link}: #{json}" unless json["stat"] == "ok"
    json["sizes"]["size"].map do |_|
      w, h, u = _.values_at("width", "height", "source")
      [w.to_i, h.to_i, u]
    end.max_by{ |w, h, u| w * h }
  end

  def self.wiki link
    raise ErrorBadLink.new link unless %r{\Ahttps?://([a-z]{2}\.wikipedia|commons.wikimedia)\.org/wiki(/[^/]+)*/(?<id>File:.+)} =~ link
    t = JSON.load( NetHTTPUtils.request_data "https://commons.wikimedia.org/w/api.php", form: {
      format: "json",
      action: "query",
      prop: "imageinfo",
      iiprop: "url",
      titles: id,
    } )
    imageinfo = t["query"]["pages"].values.first["imageinfo"]
    raise ErrorAssert.new "unexpected format of API response about #{link}" unless imageinfo
    imageinfo.first["url"]
  end


  class_variable_set :@@directlink, Struct.new(:url, :width, :height, :type)
end


require "fastimage"

def DirectLink link
  begin
    URI link
  rescue URI::InvalidURIError
    link = URI.escape link
  end

  struct = Module.const_get(__callee__).class_variable_get :@@directlink


  if %w{ lh3 googleusercontent com } == URI(link).host.split(?.).last(3) ||
     %w{ bp blogspot com } == URI(link).host.split(?.).last(3)
    u = DirectLink.google link
    f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
    w, h = f.size
    return struct.new url: u, width: w, height: h, type: f.type
  end

  if %w{ imgur com } == URI(link).host.split(?.).last(2)
    imgur = DirectLink.imgur(link).sort_by{ |u, w, h, t| - w * h }.map do |u, w, h, t|
      struct.new url: u, width: w, height: h, type: t
    end
    return imgur.size == 1 ? imgur.first : imgur
  end

  if %w{ 500px com } == URI(link).host.split(?.).last(2)
    w, h, u, t = DirectLink._500px(link)
    return struct.new url: u, width: w, height: h, type: t
  end

  if %w{ flickr com } == URI(link).host.split(?.).last(2)
    w, h, u = DirectLink.flickr(link)
    f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
    return struct.new url: u, width: w, height: h, type: f.type
  end

  if %w{ wikipedia org } == URI(link).host.split(?.).last(2) ||
     %w{ commons wikimedia org } == URI(link).host.split(?.).last(3)
    u = DirectLink.wiki link
    f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
    w, h = f.size
    return struct.new url: u, width: w, height: h, type: f.type
  end

  f = FastImage.new(link, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
  w, h = f.size
  struct.new url: link, width: w, height: h, type: f.type

end
