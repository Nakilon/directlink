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

  class ErrorAssert < RuntimeError
    def initialize msg
      super "#{msg} -- consider reporting this issue to GitHub"
    end
  end
  logging_error = Class.new RuntimeError do
    def initialize msg
      Module.nesting.first.logger.error "#{self.class}: #{msg}"
      super msg
    end
  end
  class ErrorNotFound < logging_error ; end
  class ErrorBadLink < logging_error
    def initialize link, sure = false
      super "#{link.inspect}#{" -- if you think this link is valid, please report the issue" unless sure}"
    end
  end
  class ErrorMissingEnvVar < logging_error
    def initialize msg
      super "(warning/recommendation) #{msg}"
    end
  end


  def self.google src, width = 0
    case src
    # Google Plus post image
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAAA[a-zA-Z0-9_]{3}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w[1-4]\d\d-h(318|353|727)-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAAA[ABI][a-z0-9A-Z][a-zA-Z0-9_-]\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w265-h353-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[A-Z]{3}\/[a-zA-Z0-9_]{32}wCJoC\/)w346-h195-n-k-no(\/[^\/.]+\.gif)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAAA[a-zA-Z_]{3}\/[a-zA-Z0-9]{32}[gQw]CJoC\/)w3\d\d-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAAA[a-zA-Z0-9_]{3}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w4\d\d-h318-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{32}[gw]CJoC\/)w48\d-h8\d\d-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAA[a-zA-Z0-9_-]{4}\/[a-zA-Z0-9_-]{33}(?:CJoC|CL0B(?:GAs)?)\/)w530(?:-d)?-h[1-9]\d\d-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z-]{11}\/W[a-zA-Z-]{9}I\/AAAAAAAA[a-zA-Z]{3}\/[a-zA-Z0-9_-]{32}ACJoC\/)w179-h318-n(\/[^\/]+)\z/
      "#{$1}s#{width}#{$2}"
    when /\A(\/\/lh3\.googleusercontent\.com\/proxy\/[a-zA-Z0-9_-]{66,523}=)(?:w(?:[45]\d\d)-h\d\d\d-[np]|s530-p|s110-p-k)\z/
      "https:#{$1}s#{width}"
    when /\A(\/\/lh3\.googleusercontent\.com\/cOh2Nsv7EGo0QbuoKxoKZVZO_NcBzufuvPtzirMJfPmAzCzMtnEncfA7zGIDTJfkc1YZFX2MhgKnjA=)w530-h398-p\z/
      "https:#{$1}s#{width}"
    when /\A(\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/[VW][a-zA-Z0-9_-]{9}I\/AAAAAAA[AC][a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w530-h3\d\d-p(\/[^\/]+)\z/,
         /\A(\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[a-zA-Z0-9]{3}\/[a-zA-Z0-9_]{32}ACJoC\/)w530-h298-p(\/[^\/]+)\z/,
         /\A(\/\/[124]\.bp\.blogspot\.com\/-[a-zA-Z0-9_-]{11}\/W[npw][a-zA-Z0-9_-]{8}I\/AAAAAAAA[KDE][a-zA-Z0-9_-]{2}\/[a-zA-Z0-9_-]{33}C(?:Lc|Kg)BGAs\/)w530-h[23]\d\d-p(\/[^\/]+)\z/,
         /\A(\/\/[2]\.bp\.blogspot\.com\/-[a-zA-Z-]{11}\/W[a-zA-Z0-9]{8}_I\/AAAAAAAAHDs\/[a-zA-Z0-9-]{33}CEwYBhgL\/)w530-h353-p(\/[^\/]+)\z/,
         /\A(\/\/4\.bp\.blogspot\.com\/-[a-zA-Z0-9-]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAAHHg\/[a-zA-Z0-9-]{33}CLcBGAs\/)w530-h353-p(\/[^\/]+)\z/
      "https:#{$1}s#{width}#{$2}"
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-dUQsDY2vWuE\/AAAAAAAAAAI\/AAAAAAAAAAQ\/wVFZagieszU\/)w530-h176-n(\/photo\.jpg)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-t_ab__91ChA\/VeLaObkUlgI\/AAAAAAAAL4s\/VjO6KK_lkRw\/)w530-h351-n(\/[^\/]+)\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-s655sojwyvw\/VcNB4YMCz-I\/AAAAAAAALqo\/kW98MOcJJ0g\/)w530-h398-n\/06\.08\.15%2B-%2B1\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-u3FhiUTmLCY\/Vk7dMQnxR2I\/AAAAAAAAMc0\/I76_52swA4s\/)w530-h322-n\/Harekosh_A%252520Concert_YkRqQg\.jpg\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-t_ab__91ChA\/VeLaObkUlgI\/AAAAAAAAL4s\/VjO6KK_lkRw\/)w530-d-h351-n\/30\.08\.15%2B-%2B1\z/
      "#{$1}s#{width}#{$2}"
    # high res (s0) Google Plus post image
    when /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/W[a-zA-Z0-9_-]{9}I\/AAAAAAA[ABC][a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{33}CJoC\/s0\/[^\/]+\z/,
         /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAA[a-zA-Z_]{3}\/[a-zA-Z0-9]{32}gCJoC\/s0\/[^\/]+\z/,
         /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/[a-zA-Z0-9]{10}I\/AAAAAAA[a-zA-Z0-9]{4}\/[a-zA-Z0-9_-]{32}wCJoC\/s0\/[^\/]+\z/,
         /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/[a-zA-Z0-9]{10}I\/AAAAAAA[A-Z]{4}\/[a-zA-Z0-9-]{32}gCJoC\/s0\/[^\/]+\z/,
         /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/[a-zA-Z0-9-]{10}I\/AAAAAAA[a-zA-Z]{4}\/[a-zA-Z0-9_-]{32}ACJoC\/s0\/[^\/]+\z/,
         /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/[a-zA-Z0-9-]{10}I\/AAAAAAA[a-zA-Z-]{4}\/[a-zA-Z0-9_]{32}gCJoC\/s0\/[^\/]+\z/
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

    request_data = lambda do |url|
      t = 1
      begin
        NetHTTPUtils.request_data url, header: { Authorization: "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
      rescue NetHTTPUtils::Error => e
        raise ErrorNotFound.new url.inspect if 404 == e.code
        if t < timeout && [400, 500, 503].include?(e.code)
          logger.error "retrying in #{t} seconds because of Imgur HTTP ERROR #{e.code}"
          sleep t
          t *= 2
          retry
        end
        raise ErrorAssert.new "unexpected http error #{e.code} for #{url}"
      end
    end
    case link
    when /\Ahttps?:\/\/(?:(?:i|m|www)\.)?imgur\.com\/(a|gallery)\/([a-zA-Z0-9]{5}(?:[a-zA-Z0-9]{2})?)\z/,
         /\Ahttps?:\/\/imgur\.com\/(gallery)\/([a-zA-Z0-9]{5}(?:[a-zA-Z0-9]{2})?)\/new\z/
      json = request_data["https://api.imgur.com/3/#{$1 == "gallery" ? "gallery" : "album"}/#{$2}/0.json"]
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
    when /\Ahttps?:\/\/(?:(?:i|m|www)\.)?imgur\.com\/([a-zA-Z0-9]{7,8})(?:\.(?:gifv|jpg|png))?\z/,
         /\Ahttps?:\/\/(?:(?:i|m|www)\.)?imgur\.com\/([a-zA-Z0-9]{5})\.mp4\z/,
         /\Ahttps?:\/\/imgur\.com\/([a-zA-Z0-9]{5}(?:[a-zA-Z0-9]{2})?)\z/,
         /\Ahttps?:\/\/imgur\.com\/([a-zA-Z0-9]{7})(?:\?\S+)?\z/,
         /\Ahttps?:\/\/imgur\.com\/r\/[0-9_a-z]+\/([a-zA-Z0-9]{7})\z/,
         /\Ahttps?:\/\/api\.imgur\.com\/3\/image\/([a-zA-Z0-9]{7})\/0\.json\z/
      json = request_data["https://api.imgur.com/3/image/#{$1}/0.json"]
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
    require "nokogiri"
    resp = NetHTTPUtils.request_data link
    f = lambda do |form|
      JSON.load(
        NetHTTPUtils.request_data "https://api.500px.com/v1/photos",
          form: form,
          header: {
            "Cookie" => resp.instance_variable_get(:@last_response).to_hash.fetch("set-cookie").join(?\s),
            "X-CSRF-Token" => Nokogiri::HTML(resp).at_css("[name=csrf-token]")[:content]
          }
      ).fetch("photos").values.first
    end
    w, h = f[{"ids" => id                     }].values_at("width", "height")
    # we need the above request to find the real resolution otherwise the "url" in the next request will be wrong
    u, f = f[{"ids" => id, "image_size[]" => w}].fetch("images").first.values_at("url", "format")
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

  class << self
    attr_accessor :reddit_bot
  end
  def self.reddit link, timeout = 1000
    unless id = URI(link).path[/\A(?:\/r\/[0-9a-zA-Z_]+)?(?:\/comments)?\/([0-9a-z]{5,6})(?:\/|\z)/, 1]
      raise DirectLink::ErrorBadLink.new link unless URI(link).host &&
                                                     URI(link).host.split(?.) == %w{ i redd it } &&
                                                     URI(link).path[/\A\/[a-z0-9]{12,13}\.(gif|jpg)\z/]
      return [true, link]
    end
    retry_on_json_parseerror = lambda do |&b|
      t = 1
      begin
        b.call
      rescue JSON::ParserError => e
        raise ErrorBadLink.new link if t > timeout
        logger.error "#{e.message[0, 500].gsub(/\s+/, " ")}, retrying in #{t} seconds"
        sleep t
        t *= 2
        retry
      end
    end
    json = if ENV["REDDIT_SECRETS"]
      require "reddit_bot"
      RedditBot.logger.level = Logger::ERROR
      require "yaml"
      self.reddit_bot ||= RedditBot::Bot.new YAML.load_file ENV["REDDIT_SECRETS"]
      retry_on_json_parseerror.call{ self.reddit_bot.json :get, "/by_id/t3_#{id}" }
    else
      raise ErrorMissingEnvVar.new "defining REDDIT_SECRETS env var is highly recommended" rescue nil
      json = retry_on_json_parseerror.call{ JSON.load NetHTTPUtils.request_data "https://www.reddit.com/#{id}.json", header: {"User-Agent" => "Mozilla"} }
      raise ErrorAssert.new "our knowledge about Reddit API seems to be outdated" unless json.size == 2
      json.find{ |_| _["data"]["children"].first["kind"] == "t3" }
    end
    data = json["data"]["children"].first["data"]
    if data["media"]["reddit_video"]
      return [true, data["media"]["reddit_video"]["fallback_url"]]
    else
      raise ErrorAssert.new "our knowledge about Reddit API seems to be outdated" unless data["media"].keys.sort == %w{ oembed type } && %w{ youtube.com gfycat.com }.include?(data["media"]["type"])
      return [true, data["media"]["oembed"]["thumbnail_url"]]
    end if data["media"]
    return reddit data["url"] if data["crosspost_parent"]   # TODO: test that it does it
    return [true, data["url"]] unless data["is_self"]
    raise ErrorAssert.new "our knowledge about Reddit API seems to be outdated" if data["url"] != "https://www.reddit.com" + data["permalink"]
    return [false, data["selftext"]]
  end

  class_variable_set :@@directlink, Struct.new(:url, :width, :height, :type)
end


require "fastimage"

def DirectLink link, max_redirect_resolving_retry_delay = nil, giveup = false
  ArgumentError.new("link should be a <String>, not <#{link.class}>") unless link.is_a? String
  begin
    URI link
  rescue URI::InvalidURIError
    require "addressable"
    link = Addressable::URI.escape link
  end
  raise DirectLink::ErrorBadLink.new link, true unless URI(link).host

  struct = Module.const_get(__callee__).class_variable_get :@@directlink

  google_without_schema_crutch = lambda do
    if %w{ lh3 googleusercontent com } == URI(link).host.split(?.).last(3) ||
       %w{ bp blogspot com } == URI(link).host.split(?.).last(3)
      u = DirectLink.google link
      f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
      w, h = f.size
      struct.new u, w, h, f.type
    end
  end
  t = google_without_schema_crutch[] and return t

  # to test that we won't hang for too long if someone like aeronautica.difesa.it will be silent for some reason:
  #   $ bundle console
  #   > NetHTTPUtils.logger.level = Logger::DEBUG
  #   > NetHTTPUtils.request_data "http://www.aeronautica.difesa.it/organizzazione/REPARTI/divolo/PublishingImages/6%C2%B0%20Stormo/2013-decollo%20al%20tramonto%20REX%201280.jpg",
  #                               max_read_retry_delay: 5, timeout: 5

  begin
    head = NetHTTPUtils.request_data link, :head, header: {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36"
    }, **(max_redirect_resolving_retry_delay ? {timeout: max_redirect_resolving_retry_delay, max_start_http_retry_delay: max_redirect_resolving_retry_delay, max_read_retry_delay: max_redirect_resolving_retry_delay} : {})
  rescue Net::ReadTimeout
  rescue NetHTTPUtils::Error => e
    raise unless e.code == 401
  else
    link = case head.instance_variable_get(:@last_response).code
    when "200" ; link
    when "302"
      URI( head.instance_variable_get(:@last_response).to_hash.fetch("location").tap do |a|
        raise DirectLink::ErrorAssert.new "unexpected size of locations after redirect" unless a.size == 1
      end.first )
    else ; raise NetHTTPUtils::Error.new "", (head.instance_variable_get(:@last_response).code || fail).to_i
    end
  end

  # why do we resolve redirects before trying the known adapters?
  #   because they can be hidden behind URL shorteners
  #   also it can resolve NetHTTPUtils::Error(404) before trying the adapter

  t = google_without_schema_crutch[] and return t

  begin
    imgur = DirectLink.imgur(link).sort_by{ |u, w, h, t| - w * h }.map do |u, w, h, t|
      struct.new u, w, h, t
    end
    # `DirectLink.imgur` return value is always an Array
    return imgur.size == 1 ? imgur.first : imgur
  rescue DirectLink::ErrorMissingEnvVar
  end if %w{ imgur com } == URI(link).host.split(?.).last(2)

  if %w{ 500px com } == URI(link).host.split(?.).last(2)
    w, h, u, t = DirectLink._500px(link)
    return struct.new u, w, h, t
  end

  begin
    w, h, u = DirectLink.flickr(link)
    f = FastImage.new(u, raise_on_failure: true) # , http_header: {"User-Agent" => "Mozilla"}
    return struct.new u, w, h, f.type
  rescue DirectLink::ErrorMissingEnvVar
  end if %w{ www flickr com } == URI(link).host.split(?.).last(3)

  if %w{         wikipedia org } == URI(link).host.split(?.).last(2) ||
     %w{ commons wikimedia org } == URI(link).host.split(?.).last(3)
    u = DirectLink.wiki link
    f = FastImage.new(u, raise_on_failure: true) # , http_header: {"User-Agent" => "Mozilla"}
    w, h = f.size
    return struct.new u, w, h, f.type
  end

  # TODO protect in two places from eternal recursion

  begin
    s, u = DirectLink.reddit(link)
    unless s
      raise DirectLink::ErrorBadLink.new link if giveup   # TODO: print original url in such cases if there was a recursion
      f = ->_{ _.type == :a ? _.attr["href"] : _.children.flat_map(&f) }
      require "kramdown"
      return f[Kramdown::Document.new(u).root].map do |sublink|
        DirectLink URI.join(link, sublink).to_s, max_redirect_resolving_retry_delay, giveup
      end
    end
    return struct.new *u.values_at(*%w{ fallback_url width height }), "video" if u.is_a? Hash
    link = u
  rescue DirectLink::ErrorMissingEnvVar
  end if %w{ reddit com } == URI(link).host.split(?.).last(2) ||
         %w{ redd it    } == URI(link).host.split(?.)

  begin
    f = FastImage.new(link, raise_on_failure: true, timeout: 5, http_header: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36"})
  rescue FastImage::UnknownImageType
    raise if giveup
    require "nokogiri"
    head = NetHTTPUtils.request_data link, :head, header: {"User-Agent" => "Mozilla"}
    case head.instance_variable_get(:@last_response).content_type
    when "text/html" ; nil
    else ; raise
    end
    html = Nokogiri::HTML NetHTTPUtils.request_data link, header: {"User-Agent" => "Mozilla"}
    h = {}  # TODO: maybe move it outside because of possible img[:src] recursion?...
    l = lambda do |node, s = []|
      node.element_children.flat_map do |child|
        next l[child, s + [child.node_name]] unless "img" == child.node_name
        begin
          [[s, (h[child[:src]] = h[child[:src]] || DirectLink(URI.join(link, child[:src]).to_s, nil, true))]]  # ... or wait, do we giveup?
        rescue => e
          DirectLink.logger.error "#{e} (from no giveup)"
          []
        end
      end
    end
    l[html].group_by(&:first).map{ |k, v| [k.join(?>), v.map(&:last)] }.tap do |result|
      next unless result.empty?
      raise unless t = html.at_css("meta[@property='og:image']")
      return DirectLink t[:content], nil, true
    end.max_by{ |_, v| v.map{ |i| i.width * i.height }.inject(:+) / v.size }.last
  else
    # TODO: maybe move this to right before `rescue` line
    w, h = f.size
    struct.new f.instance_variable_get(:@parsed_uri).to_s, w, h, f.type
  end
end
