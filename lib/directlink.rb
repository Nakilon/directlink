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
    def initialize link, sure = false
      super "#{link.inspect}#{" -- if you think this link is valid, please report the issue" unless sure}"
    end
  end


  def self.google src, width = 0
    case src
    # Google Plus post image
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[n-r][a-zA-Z0-9_-]{8}I\/AAAAAAAA[bA-V][a-zA-Z0-9]{2}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w[1-4]\d\d-h(318|353|727)-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_]{11}\/W[a-zA-Z0-9_]{9}I\/AAAAAAAA[a-zA-Z0-9_]{3}\/[a-zA-Z0-9_]{32}[AgwQ]CJoC\/)w239-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9_]{9}I\/AAAAAAAAA20\/[a-zA-Z0-9]{32}[Qw]CJoC\/)w212-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAAA_A\/[a-zA-Z0-9_]{32}wCJoC\/)w296-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAAA[ABI][a-z0-9A-Z][a-zA-Z0-9_-]\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w265-h353-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[A-Z]{3}\/[a-zA-Z0-9_]{32}wCJoC\/)w346-h195-n-k-no(\/[^\/.]+\.gif)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/W[a-zA-Z0-9-]{9}I\/AAAAAAAAA_A\/[a-zA-Z0-9]{32}[Qw]CJoC\/)w3\d\d-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/Wv[a-zA-Z_]{7}AI\/AAAAAAAACkQ\/[a-zA-Z0-9]{32}gCJoC\/)w318-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/Wu[a-zA-Z]{7}HI\/AAAAAAAABAI\/[a-zA-Z0-9]{32}QCJoC\/)w398-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAAA[a-zA-Z0-9_]{3}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w4\d\d-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAA[a-zA-Z0-9_-]{4}\/[a-zA-Z0-9_-]{33}(?:CJoC|CL0B(?:GAs)?)\/)w530(?:-d)?-h[1-9]\d\d-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[a-zA-Z]{3}\/[a-zA-Z0-9-]{32}QCJoC\/)w530-h175-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[A-Z0-9]{3}\/[a-zA-Z0-9_]{32}gCJoC\/)w486-h864-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z-]{11}\/W[a-zA-Z-]{9}I\/AAAAAAAA[a-zA-Z]{3}\/[a-zA-Z0-9_-]{32}ACJoC\/)w179-h318-n(\/[^\/]+)\z/
      "#{$1}s#{width}#{$2}"
    when /\A(\/\/lh3\.googleusercontent\.com\/proxy\/[a-zA-Z0-9_-]{66,523}=)(?:w(?:464|504|530)-h\d\d\d-[np]|s530-p|s110-p-k)\z/
      "https:#{$1}s#{width}"
    when /\A(\/\/lh3\.googleusercontent\.com\/cOh2Nsv7EGo0QbuoKxoKZVZO_NcBzufuvPtzirMJfPmAzCzMtnEncfA7zGIDTJfkc1YZFX2MhgKnjA=)w530-h398-p\z/
      "https:#{$1}s#{width}"
    when /\A(\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAA[AC][a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w530-h3\d\d-p(\/[^\/]+)\z/,
         /\A(\/\/[124]\.bp\.blogspot\.com\/-[a-zA-Z0-9_-]{11}\/W[npw][a-zA-Z0-9_-]{8}I\/AAAAAAAA[KDE][a-zA-Z0-9_-]{2}\/[a-zA-Z0-9_-]{33}C(?:Lc|Kg)BGAs\/)w530-h[23]\d\d-p(\/[^\/]+)\z/
      "https:#{$1}s#{width}#{$2}"
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-dUQsDY2vWuE\/AAAAAAAAAAI\/AAAAAAAAAAQ\/wVFZagieszU\/)w530-h176-n(\/photo\.jpg)\z/
      "#{$1}s#{width}#{$2}"
    # high res Google Plus post image
    when /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAA[ABC][a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{33}CJoC\/s0\/[^\/]+\z/,
         /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[a-zA-Z_]{3}\/[a-zA-Z0-9]{32}gCJoC\/s0\/[^\/]+\z/,
         /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/[a-zA-Z0-9]{10}I\/AAAAAAA[a-zA-Z]{4}\/[a-zA-Z0-9]{32}wCJoC\/s0\/[^\/]+\z/
      src
    # Google Plus userpic
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/AAAAAAAAAAI\/AAAAAAAA[a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{11}\/)s\d\d-p(?:-k)?-rw-no(\/photo\.jpg)\z/
      "#{$1}s#{width}#{$2}"
    # Hangout userpic
    when /\A(https:\/\/lh5\.googleusercontent\.com\/-[a-zA-Z]{11}\/AAAAAAAAAAI\/AAAAAAAAAAA\/[a-zA-Z0-9]{11}\/)s64-c-k(\/photo\.jpg)\z/,
         /\A(https:\/\/lh[35]\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/AAAAAAAAAAI\/AAAAAAAA[a-zA-Z0-9]{3}\/[a-zA-Z0-9-]{11}\/)s\d\d-c-k-no(\/photo\.jpg)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/AAAAAAAAAAI\/AAAAAAAAAAA\/[a-zA-Z0-9]{34}\/)s64-c-mo(\/photo\.jpg)\z/,
         /\A(https:\/\/lh6\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/AAAAAAAAAAI\/AAAAAAAAAAA\/[a-zA-Z0-9_]{34}\/)s46-c-k-no-mo(\/photo\.jpg)\z/
      "#{$1}s#{width}#{$2}"
    # mp4
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAAODw\/[a-zA-Z0-9]{32}QCJoC\/)w530-h883-n-k-no(\/[^\/]+\.mp4)\z/
      "#{$1}s#{width}#{$2}"
    else
      raise ErrorBadLink.new src
    end
  end

  require "json"
  require "nethttputils"

  # TODO make the timeout handling respect the way the Directlink method works with timeouts
  def self.imgur link, timeout = 1000
    raise ErrorMissingEnvVar.new "define IMGUR_CLIENT_ID env var" unless ENV["IMGUR_CLIENT_ID"]

    case link
    when /\Ahttps?:\/\/(?:(?:i|m|www)\.)?imgur\.com\/(a|gallery)\/([a-zA-Z0-9]{5}(?:[a-zA-Z0-9]{2})?)\z/,
         /\Ahttps?:\/\/imgur\.com\/(gallery)\/([a-zA-Z0-9]{5}(?:[a-zA-Z0-9]{2})?)\/new\z/
      t = 1
      json = begin
        NetHTTPUtils.request_data "https://api.imgur.com/3/#{
          $1 == "gallery" ? "gallery" : "album"
        }/#{$2}/0.json", header: { Authorization: "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
      rescue NetHTTPUtils::Error => e
        if 500 == e.code && t < timeout
          logger.error "retrying in #{t} seconds because of Imgur HTTP ERROR 500"
          sleep t
          t *= 2
          retry
        end
        raise ErrorNotFound.new link.inspect if 404 == e.code
        raise ErrorAssert.new "unexpected http error for #{link}"
      end
      data = JSON.load(json)["data"]
      if data["error"]
        raise ErrorAssert.new "unexpected error #{data.inspect} for #{link}"
      elsif data["images"]
        raise ErrorNotFound.new link.inspect if data["images"].empty?
        data["images"]
      elsif data["type"] && data["type"].start_with?("image/")
        # TODO check if this branch is possible at all
        [ data ]
      # elsif data["comment"]
      #   fi["https://imgur.com/" + data["image_id"]]
      else
        # one day single-video item should hit this but somehow it didn't yet
        raise ErrorAssert.new "unknown data format #{data.inspect} for #{link}"
      end
    when /\Ahttps?:\/\/(?:(?:i|m|www)\.)?imgur\.com\/([a-zA-Z0-9]{7})(?:\.(?:gifv|jpg|png))?\z/,
         /\Ahttps?:\/\/(?:(?:i|m|www)\.)?imgur\.com\/([a-zA-Z0-9]{5})\.mp4\z/,
         /\Ahttps?:\/\/imgur\.com\/([a-zA-Z0-9]{5}(?:[a-zA-Z0-9]{2})?)\z/,
         /\Ahttps?:\/\/imgur\.com\/([a-zA-Z0-9]{7})(?:\?\S+)?\z/,
         /\Ahttps?:\/\/imgur\.com\/r\/[0-9_a-z]+\/([a-zA-Z0-9]{7})\z/
      t = 1
      json = begin
        NetHTTPUtils.request_data "https://api.imgur.com/3/image/#{$1}/0.json", header: { Authorization: "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
      rescue NetHTTPUtils::Error => e
        raise ErrorNotFound.new link.inspect if e.code == 404
        if t < timeout && [400, 500].include?(e.code)
          logger.error "retrying in #{t} seconds because of Imgur HTTP ERROR #{e.code}"
          sleep t
          t *= 2
          retry
        end
        raise ErrorAssert.new "unexpected http error for #{link}"
      end
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
    w, h = JSON.load(NetHTTPUtils.request_data "https://api.500px.com/v1/photos", form: {ids: id})["photos"].values.first.values_at("width", "height")
    u, f = JSON.load(NetHTTPUtils.request_data "https://api.500px.com/v1/photos", form: {"image_size[]" => w, "ids" => id})["photos"].values.first["images"].first.values_at("url", "format")
    [w, h, u, f]
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

  require "cgi"
  def self.wiki link
    raise ErrorBadLink.new link unless %r{\Ahttps?://([a-z]{2}\.wikipedia|commons.wikimedia)\.org/wiki(/[^/]+)*/(?<id>File:.+)} =~ link
    t = JSON.load json = NetHTTPUtils.request_data( "https://commons.wikimedia.org/w/api.php", form: {
      format: "json",
      action: "query",
      prop: "imageinfo",
      iiprop: "url",
      titles: CGI.unescape(id),
    } )
    imageinfo = t["query"]["pages"].values.first["imageinfo"]
    raise ErrorAssert.new "unexpected format of API response about #{link}: #{json}" unless imageinfo
    imageinfo.first["url"]
  end


  class_variable_set :@@directlink, Struct.new(:url, :width, :height, :type)
end


require "fastimage"

def DirectLink link, max_redirect_resolving_retry_delay = nil
  begin
    URI link
  rescue URI::InvalidURIError
    link = URI.escape link
  end
  raise DirectLink::ErrorBadLink.new link, true unless URI(link).host

  struct = Module.const_get(__callee__).class_variable_get :@@directlink

  if %w{ lh3 googleusercontent com } == URI(link).host.split(?.).last(3) ||
     %w{ bp blogspot com } == URI(link).host.split(?.).last(3)
    u = DirectLink.google link
    f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
    w, h = f.size
    return struct.new u, w, h, f.type
  end

  # to test that we won't hang for too long if someone like aeronautica.difesa.it will be silent for some reason:
  #   $ bundle console
  #   > NetHTTPUtils.logger.level = Logger::DEBUG
  #   > NetHTTPUtils.request_data "http://www.aeronautica.difesa.it/organizzazione/REPARTI/divolo/PublishingImages/6%C2%B0%20Stormo/2013-decollo%20al%20tramonto%20REX%201280.jpg",
  #                               max_read_retry_delay: 5, timeout: 5
  r = NetHTTPUtils.get_response link, header: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36"}, **(max_redirect_resolving_retry_delay ? {
    max_timeout_retry_delay: max_redirect_resolving_retry_delay,
    max_sslerror_retry_delay: max_redirect_resolving_retry_delay,
    max_read_retry_delay: max_redirect_resolving_retry_delay,
    max_econnrefused_retry_delay: max_redirect_resolving_retry_delay,
    max_socketerror_retry_delay: max_redirect_resolving_retry_delay,
  } : {})
  raise NetHTTPUtils::Error.new "", r.code.to_i unless "200" == r.code
  link = r.uri.to_s

  if %w{ imgur com } == URI(link).host.split(?.).last(2) ||
     %w{ i imgur com } == URI(link).host.split(?.).last(3) ||
     %w{ m imgur com } == URI(link).host.split(?.).last(3) ||
     %w{ www imgur com } == URI(link).host.split(?.).last(3)
    imgur = DirectLink.imgur(link).sort_by{ |u, w, h, t| - w * h }.map do |u, w, h, t|
      struct.new u, w, h, t
    end
    # `DirectLink.imgur` return value is always an Array
    return imgur.size == 1 ? imgur.first : imgur
  end

  if %w{ 500px com } == URI(link).host.split(?.).last(2)
    w, h, u, t = DirectLink._500px(link)
    return struct.new u, w, h, t
  end

  if %w{ www flickr com } == URI(link).host.split(?.).last(3)
    w, h, u = DirectLink.flickr(link)
    f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
    return struct.new u, w, h, f.type
  end

  if %w{ wikipedia org } == URI(link).host.split(?.).last(2) ||
     %w{ commons wikimedia org } == URI(link).host.split(?.).last(3)
    u = DirectLink.wiki link
    f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
    w, h = f.size
    return struct.new u, w, h, f.type
  end

  f = FastImage.new(link, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36"})
  w, h = f.size
  struct.new link, w, h, f.type
end
