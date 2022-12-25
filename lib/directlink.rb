module DirectLink
  class << self
    attr_accessor :timeout
    attr_accessor :strict
    attr_accessor :logger
  end
  self.strict = false
  require "logger"
  self.logger = Logger.new STDOUT
  self.logger.formatter = lambda do |severity, datetime, progname, msg|
    "%s%s %s %s %s\n" % [
      (datetime.strftime "%y%m%d "),
      (datetime.strftime "%H%M%S"),
      name,
      severity.to_s[0],
      msg,
    ]
  end

  class ErrorAssert < RuntimeError  # gem user should not face this error
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

  require "nethttputils"
  require "fastimage"
  NORMAL_EXCEPTIONS = [
    SocketError,
    Net::OpenTimeout,
    Errno::ECONNRESET,
    Errno::ECONNREFUSED,
    Errno::ETIMEDOUT,   # from FastImage
    NetHTTPUtils::Error,
    NetHTTPUtils::EOFError_from_rbuf_fill,
    FastImage::UnknownImageType,
    FastImage::ImageFetchFailure,
    DirectLink::ErrorNotFound,
    DirectLink::ErrorBadLink,
  ]  # all known exceptions that can be raised while using Directlink but not as its fault


  def self.google src, width = 0
    # this can handle links without schema because it's used for parsing community HTML pages
    case src
    # Google Plus post image
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/[WX][a-zA-Z0-9_-]{9}I\/AAAAAAA[a-zA-Z0-9_-]{4}\/[a-zA-Z0-9_-]{33}(?:[gwAQ]?CJoC|CL0B(?:GAs)?)\/)w[1-7]\d\d(?:-d)?-h[1-9]\d\d\d?-n(?:-k-no|-rw|)\/[^\/]+\z/
      "#{$1}s#{width}/"
    when /\A(\/\/lh3\.googleusercontent\.com\/proxy\/[a-zA-Z0-9_-]{66,523}=)(?:w(?:[45]\d\d)-h\d\d\d-[np]|s530-p|s110-p-k)\z/
      "https:#{$1}s#{width}/"
    when /\A(\/\/lh3\.googleusercontent\.com\/[a-zA-Z0-9]{24}_[a-zA-Z]{30}7zGIDTJfkc1YZFX2MhgKnjA=)w530-h398-p\z/
      "https:#{$1}s#{width}/"
    when /\A(\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/[VW][a-zA-Z0-9_-]{9}I\/AAAAAAA[AC][a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{32}[gwAQ]CJoC\/)w530-h[23]\d\d-p\/[^\/]+\z/,
         /\A(?:https?:)?(\/\/[1-4]\.bp\.blogspot\.com\/-[a-zA-Z0-9_-]{11}\/[UVWX][a-zA-Z0-9_-]{9}I\/AAAAAAAA[A-Z][a-zA-Z0-9_-]{2}\/[a-zA-Z0-9_-]{33}C(?:EwYBhgL|(?:Lc|Kg)BGAs(?:YHQ)?)\/)(?:s640|w\d{2,4}-h\d\d\d?-p(?:-k-no-nu)?)\/[^\/]+\z/,
         /\A(?:https?:)?(\/\/[1-4]\.bp\.blogspot\.com\/-[a-zA-Z0-9-]{11}\/[UV][a-zA-Z0-9_-]{9}I\/AAAAAAAA[A-Z][a-zA-Z0-9]{2}\/[a-zA-Z0-9-]{11}\/)w72-h72-p-k-no-nu\/[^\/]+\z/
      "https:#{$1}s#{width}/"
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_]{11}\/AAAAAAAAAAI\/AAAAAAAAAAQ\/[a-zA-Z0-9_]{11}\/)w530-h[13]\d\d-n\/[^\/]+\z/,
         /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_]{11}\/V[a-zA-Z0-9-]{9}I\/AAAAAAAA[ML][c-q4][so0]\/[a-zA-Z0-9_]{11}\/)w530(?:-d)?-h3\d\d-n\/[^\/]+\z/
      "#{$1}s#{width}/"
    # high res (s0) Google Plus post image
    when /\Ahttps:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_-]{11}\/[a-zA-Z0-9_-]{10}I\/AAAAAAA[a-zA-Z0-9_-]{4}\/[a-zA-Z0-9_-]{33}CJoC\/s0\/[^\/]+\z/
      src
    # Google Plus userpic
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9-]{11}\/AAAAAAAAAAI\/AAAAAAAA[a-zA-Z0-9]{3}\/[a-zA-Z0-9_-]{11}\/)s\d\d-p(?:-k)?-rw-no\/photo\.jpg\z/
      "#{$1}s#{width}/"
    # Hangout userpic
    when /\A(https:\/\/lh[356]\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/AAAAAAAAAAI\/AAAAAAAA[a-zA-Z0-9]{3}\/[a-zA-Z0-9-]{11}\/)s\d\d-c-k-no\/photo\.jpg\z/,
         /\A(https:\/\/lh[356]\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/AAAAAAAAAAI\/AAAAAAAAAAA\/[a-zA-Z0-9]{11}\/)s64-c-k\/photo\.jpg\z/,
         /\A(https:\/\/lh[356]\.googleusercontent\.com\/-[a-zA-Z0-9]{11}\/AAAAAAAAAAI\/AAAAAAAAAAA\/[a-zA-Z0-9_]{34}\/)s(?:46|64)-c(?:-k(?:-no)?)?-mo\/photo\.jpg\z/
      "#{$1}s#{width}/"
    # Google Keep
    when /\A(https:\/\/lh\d\.googleusercontent\.com\/[a-zA-Z0-9_-]{104,106}=s)\d\d\d\d?\z/
      "#{$1}#{width}"
    # opensea
    when /\A(https:\/\/lh3\.googleusercontent\.com\/[a-zA-Z0-9]{78}-nGx_jf_XGqqiVANe_Jr8u2g=)w1400-k\z/
      "#{$1}s#{width}"
    # mp4
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z]{11}\/W[a-zA-Z0-9]{9}I\/AAAAAAAAODw\/[a-zA-Z0-9]{32}QCJoC\/)w530-h883-n-k-no\/[^\/]+\.mp4\z/
      "#{$1}s#{width}/"
    # something else
    when /\A(https:\/\/lh3\.googleusercontent\.com\/-[a-zA-Z0-9_]{11}\/X-[a-zA-Z0-9]{8}I\/AAAAAAAAALE\/[a-zA-Z0-9]{23}_[a-zA-Z0-9]{19}\/)w1200-h630-p-k-no-nu\/[\d-]+\.png\z/
      "#{$1}s#{width}/"
    else
      raise ErrorBadLink.new src
    end
  end


  require "json"

  # TODO make the timeout handling respect the way the Directlink method works with timeouts
  def self.imgur link, timeout = 1000
    raise ErrorMissingEnvVar.new "define IMGUR_CLIENT_ID env var" unless ENV["IMGUR_CLIENT_ID"]

    request_data = lambda do |url|
      t = 1
      begin
        NetHTTPUtils.request_data url, header: { Authorization: "Client-ID #{ENV["IMGUR_CLIENT_ID"]}" }
      rescue NetHTTPUtils::Error => e
        raise ErrorNotFound.new url.inspect if 404 == e.code
        if t < timeout && [400, 500, 502, 503].include?(e.code)
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
      elsif data["type"] && %w{ image/jpeg image/png image/gif video/mp4 }.include?(data["type"])
        # TODO check if this branch is possible at all
        [ data ]
      # elsif data["comment"]
      #   fi["https://imgur.com/" + data["image_id"]]
      else
        # one day single-video item should hit this but somehow it didn't yet
        raise ErrorAssert.new "unknown data format #{json} for #{link}"
      end
    when /\Ahttps?:\/\/(?:(?:i|m|www)\.)?imgur\.com\/([a-zA-Z0-9]{7,8})(?:\.(?:gifv|jpe?g(?:\?fb)?|png))?\z/,
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
      when *%w{ image/jpeg image/png image/gif video/mp4 }
        image.values_at "link", "width", "height", "type"
      else
        raise ErrorAssert.new "unknown type of #{link}: #{image}"
      end
    end
  end

  def self._500px link
    raise ErrorBadLink.new link unless %r{\Ahttps://500px\.com/photo/(?<id>[^/]+)/[-[a-zA-Z0-9]%]+\/?\z} =~ link
    require "nokogiri"
    f = lambda do |form|
      JSON.load(NetHTTPUtils.request_data "https://api.500px.com/v1/photos", form: form).fetch("photos").values.first
    end
    w, h = f[{"ids" => id                     }].values_at("width", "height")
    # we need the above request to find the real resolution otherwise the "url" in the next request will be wrong
    u, f = f[{"ids" => id, "image_size[]" => w}].fetch("images").first.values_at("url", "format")
    [w, h, u, f]
  end

  private_class_method def self._flickr id, method
      JSON.load NetHTTPUtils.request_data "https://api.flickr.com/services/rest/", form: {
        api_key: ENV["FLICKR_API_KEY"],
        format: "json",
        nojsoncallback: 1,
        photo_id: id,
        method: "flickr.photos.#{method}",
      }
  end
  def self.flickr link
    raise ErrorBadLink.new link unless %r{\Ahttps://www\.flickr\.com/photos/[^/]+/(?<id>[^/]+)} =~ link ||
                                       %r{\Ahttps://flic\.kr/p/(?<id>[^/]+)\z} =~ link
    raise ErrorMissingEnvVar.new "define FLICKR_API_KEY env var" unless ENV["FLICKR_API_KEY"]
    json = _flickr(id, "getSizes")
    raise ErrorNotFound.new link.inspect if json == {"stat"=>"fail", "code"=>1, "message"=>"Photo not found"}
    raise ErrorAssert.new "unhandled API response stat for #{link}: #{json}" unless json["stat"] == "ok"
    json["sizes"]["size"].map do |_|
      w, h, u = _.values_at("width", "height", "source")
      [w.to_i, h.to_i, u]
    end.max_by{ |w, h, u| w * h }
  end

  require "cgi"
  def self.wiki link
    raise ErrorBadLink.new link unless %r{\Ahttps?://(?<hostname>([a-z]{2}\.wikipedia|commons.wikimedia)\.org)/wiki(/[^/]+)*/(?<id>File:.+)} =~ link
    t = JSON.load json = NetHTTPUtils.request_data( "https://#{hostname}/w/api.php", form: {
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
    return [true, link] if URI(link).host &&
                           URI(link).host.split(?.) == %w{ i redd it } &&
                           URI(link).path[/\A\/[a-z0-9]{12,13}\.(gif|jpg)\z/]
    unless id = link[/\Ahttps:\/\/www\.reddit\.com\/gallery\/([0-9a-z]{5,6})\z/, 1]
      raise DirectLink::ErrorBadLink.new link unless id = URI(link).path[/\A(?:\/r\/[0-9a-zA-Z_]+)?(?:\/comments|\/duplicates)?\/([0-9a-z]{5,6})(?:\/|\z)/, 1]
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
    # TODO: do we handle linking Imgur albums?
    data = json["data"]["children"].first["data"]
    if data["media"]
      return [true, data["media"]["reddit_video"]["fallback_url"]] if data["media"]["reddit_video"]
      raise ErrorAssert.new "our knowledge about Reddit API seems to be outdated" unless data["media"].keys.sort == %w{ oembed type } && %w{ youtube.com gfycat.com imgur.com }.include?(data["media"]["type"])
      return [true, data["media"]["oembed"]["thumbnail_url"]]
    end
    if data["media_metadata"]
      return [true, data["media_metadata"].values.map do |media|
        next if media == {"status"=>"failed"} || media == {"status"=>"unprocessed"}
        raise ErrorAssert.new "our knowledge about Reddit API seems to be outdated (media == #{media.inspect})" unless media["status"] == "valid"
        [media["m"], *media["s"].values_at("x", "y"), CGI.unescapeHTML(media["s"][media["m"]=="image/gif" ? "gif" : "u"])]
      end.compact]
    end
    return [true, "#{"https://www.reddit.com" if /\A\/r\/[0-9a-zA-Z_]+\/comments\/[0-9a-z]{5,6}\// =~ data["url"]}#{data["url"]}"] if data["crosspost_parent"]
    return [true, CGI.unescapeHTML(data["url"])] unless data["is_self"]
    raise ErrorAssert.new "our knowledge about Reddit API seems to be outdated" if data["url"] != "https://www.reddit.com" + data["permalink"]
    return [false, data["selftext"]]
  end

  require "nakischema"
  def self.vk link
    f = lambda do |id, mtd, field|
      raise ErrorMissingEnvVar.new "define VK_ACCESS_TOKEN env var" unless ENV["VK_ACCESS_TOKEN"]

      # К методам API ВКонтакте (за исключением методов из секций secure и ads) с ключом доступа пользователя можно обращаться не чаще 3 раз в секунду.
      sleep 0.35 # unless defined?(::WebMock) && ::WebMock::HttpLibAdapters::HttpRbAdapter.enabled?
      # "error_msg"=>"Too many requests per second"

      JSON.load( NetHTTPUtils.request_data "https://api.vk.com/method/#{mtd}.getById", :POST, form: {
        :access_token => ENV["VK_ACCESS_TOKEN"],
        :v => "5.131",
        field => id,
      } ).tap do |t|
        next unless t["error"]
        case t["error"]["error_code"]
        when 5 ; raise ErrorMissingEnvVar.new "the VK_ACCESS_TOKEN is probably expired, get a new one at: https://api.vk.com/oauth/authorize?client_id=...&response_type=token&v=5.75&scope=offline"
        when 200 ; raise ErrorNotFound.new link.inspect
        else ; raise ErrorAssert.new "VK API error ##{t["error"]["error_code"]} #{t["error"]["error_msg"]}"
        end
      end.fetch("response")
    end
    case link
    when %r{\Ahttps://vk\.com/id(?<user_id>\d+)\?z=photo(?<id>\k<user_id>_\d+)(%2F(album\k<user_id>_0|photos\k<user_id>))?\z},
         %r{\Ahttps://vk\.com/[a-z_.]+\?z=photo(?<id>(?<user_id>\d+)_\d+)%2Fphotos\k<user_id>\z},
         /\Ahttps:\/\/vk\.com\/[a-z_.]+\?z=photo(?<id>(?<user_id>\d+)_\d+)%2Falbum\k<user_id>_0%2Frev\z/,
         %r{\Ahttps://vk\.com/[0-9a-z_.]+\?z=photo(?<id>(?<user_id>-?\d+)_\d+)%2F(wall\k<user_id>_\d+|album\k<user_id>_0(%2Frev)?)\z},
         %r{\Ahttps://vk\.com/photo(?<id>-?\d+_\d+)(\?(all|rev)=1)?\z},
         %r{\Ahttps://vk\.com/feed\?(?:section=likes&)?z=photo(?<_>)(?<id>(?<user_id>-?\d+)_\d+)%2F(liked\d+|album\k<user_id>_0(0%2Frev)?)\z},
         %r{\Ahttps://vk\.com/wall(?<user_id>-\d+)_\d+\?z=photo(?<id>\k<user_id>_\d+)%2F(wall\k<user_id>_\d+|album\k<user_id>_00%2Frev|\d+)\z},
         /\Ahttps:\/\/vk\.com\/bookmarks\?from_menu=1&z=photo(?<id>-(?<user_id>\d+)_\d+)%2Fwall-\k<user_id>_\d+\z/,
         /\Ahttps:\/\/vk\.com\/public(?<user_id>\d+)\?z=photo(?<id>-\k<user_id>_\d+)%2Fwall-\k<user_id>_\d+\z/,
         /\Ahttps:\/\/vk\.com\/feed\?w=wall-(?<_>(?<user_id>\d+)_\d+)&z=photo-(?<id>\k<user_id>_\d+)%2Fwall-\k<_>\z/
      f[$~[:id], :photos, :photos].tap do |_|
        raise ErrorAssert.new "our knowledge about VK API seems to be outdated" unless 1 == _.size
      end
    when %r{\Ahttps://vk\.com/wall(?<id>-?\d+_\d+)(\?hash=[a-z0-9]{18})?\z},
         %r{\Ahttps://vk\.com/[a-z\.]+\?w=wall(?<id>-?\d+_\d+)\z}
      t = f[$1, :wall, :posts].first
      (t["attachments"] || t.fetch("copy_history")[0]["attachments"]).select do |item|
          begin
            Nakischema.validate item.keys - ["type"], [[item.fetch("type")]]
          rescue Nakischema::Error
            raise ErrorAssert.new "our knowledge about VK API seems to be outdated"
          end
          "photo" == item["type"]
      end.map{ |i| i["photo"] }
    else
      raise ErrorBadLink.new link
    end.map do |photos|
      # https://vk.com/dev/objects/photo_sizes
      photos.fetch("sizes").map do |_|
        w, h, u = _.values_at("width", "height", "url")
        _ = FastImage.new(u, raise_on_failure: true)  # TODO: ради type?
        w, h = _.size if w == 0 || h == 0  # https://vk.com/dev/objects/photo_sizes - Для фотографий, загруженных на сайт до 2012 года, значения width и height могут быть недоступны, в этом случае соответствующие поля содержат 0.
        [w, h, u, _.type]
      end.max_by{ |w, h, u| w * h }
    end
  end

  class_variable_set :@@directlink, Struct.new(:url, :width, :height, :type)
end


def DirectLink link, timeout = nil, proxy = nil, giveup: false, ignore_meta: false
  timeout ||= DirectLink.timeout
  ArgumentError.new("link should be a <String>, not <#{link.class}>") unless link.is_a? String
  begin
    URI link
  rescue URI::InvalidURIError
    require "addressable"
    link = Addressable::URI.escape link
  end
  raise DirectLink::ErrorBadLink.new link, true unless URI(link).host

  struct = Module.const_get(__callee__).class_variable_get :@@directlink

  # to test that we won't hang for too long if someone like aeronautica.difesa.it will be silent for some reason:
  #   $ bundle console
  #   > NetHTTPUtils.logger.level = Logger::DEBUG
  #   > NetHTTPUtils.request_data "http://www.aeronautica.difesa.it/organizzazione/REPARTI/divolo/PublishingImages/6%C2%B0%20Stormo/2013-decollo%20al%20tramonto%20REX%201280.jpg",
  #                               max_read_retry_delay: 5, timeout: 5

  # why do we resolve redirects before trying the known adapters?
  #   because they can be hidden behind URL shorteners
  #   also it can resolve NetHTTPUtils::Error(404) before trying the adapter

    if %w{ lh3 googleusercontent com } == URI(link).host.split(?.).last(3) ||
       %w{ lh4 googleusercontent com } == URI(link).host.split(?.).last(3) ||
       %w{ lh5 googleusercontent com } == URI(link).host.split(?.).last(3) ||
       %w{ lh6 googleusercontent com } == URI(link).host.split(?.).last(3) ||
       %w{ bp blogspot com } == URI(link).host.split(?.).last(3)
      u = DirectLink.google link
      f = FastImage.new(u, raise_on_failure: true, http_header: {"User-Agent" => "Mozilla"})
      w, h = f.size
      return struct.new u, w, h, f.type
    end

  begin
    imgur = DirectLink.imgur(link, timeout).sort_by{ |u, w, h, t| - w * h }.map do |u, w, h, t|
      struct.new u, w, h, t
    end
    # `DirectLink.imgur` return value is always an Array
    return imgur.size == 1 ? imgur.first : imgur
  rescue DirectLink::ErrorMissingEnvVar
    raise if DirectLink.strict
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
    raise if DirectLink.strict
  end if %w{ www flickr com } == URI(link).host.split(?.) ||
         %w{     flic kr    } == URI(link).host.split(?.)

  if %w{         wikipedia org } == URI(link).host.split(?.).last(2) ||
     %w{ commons wikimedia org } == URI(link).host.split(?.)
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
      return f[Kramdown::Document.new(u).root].flat_map do |sublink|
        DirectLink URI.join(link, sublink).to_s, timeout, giveup: giveup   # TODO: maybe subtract from timeout the time we've already wasted
      end
    end
    if u.is_a? Hash
      return struct.new *u.values_at(*%w{ fallback_url width height }), "video"
    elsif u.is_a? Array
      return u.map do |t, x, y, u|
        struct.new u, x, y, t
      end
    end
    raise DirectLink::ErrorNotFound.new link.inspect if link == u
    return DirectLink u, timeout, giveup: giveup
  rescue DirectLink::ErrorMissingEnvVar
    raise if DirectLink.strict
  end if %w{ reddit com } == URI(link).host.split(?.).last(2) ||
         %w{   redd it  } == URI(link).host.split(?.)

  begin
    return DirectLink.vk(link).map do |w, h, u, t|
      struct.new u, w, h, t
    end
  rescue DirectLink::ErrorMissingEnvVar
    raise if DirectLink.strict
  end if %w{ vk com } == URI(link).host.split(?.)

  host = URI(link).host
  begin
    head = NetHTTPUtils.request_data link, :HEAD, header: {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36",
      **( %w{ reddit com } == URI(link).host.split(?.).last(2) ||
          %w{   redd it  } == URI(link).host.split(?.) ? {Cookie: "over18=1"} : {} ),
    }, **(proxy ? {proxy: proxy} : {}), **(timeout ? {
      timeout: timeout,
      max_start_http_retry_delay: timeout,
      max_read_retry_delay: timeout,
    } : {})
  rescue Errno::ETIMEDOUT, Net::OpenTimeout, Net::ReadTimeout
  else
    raise DirectLink::ErrorAssert.new "last_response.uri is not set" unless head.instance_variable_get(:@last_response).uri
    link = head.instance_variable_get(:@last_response).uri.to_s
    return DirectLink link, timeout, proxy, giveup: giveup, ignore_meta: ignore_meta if URI(link).host != host
  end

  begin
    f = FastImage.new link,
      raise_on_failure: true,
      timeout: timeout,
      **(proxy ? {proxy: "http://#{proxy}"} : {}),
      http_header: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36"}
  rescue FastImage::UnknownImageType
    raise if giveup
    require "nokogiri"
    head = NetHTTPUtils.request_data link, :HEAD, header: {"User-Agent" => "Mozilla"},
      max_start_http_retry_delay: timeout,
      timeout: timeout,                 # NetHTTPUtild passes this as read_timeout to Net::HTTP.start
      max_read_retry_delay: timeout     # and then compares accumulated delay to this
    # if we use :get here we will download megabytes of files just to giveup on content_type we can't process
    case head.instance_variable_get(:@last_response).content_type   # webmock should provide this
    when "text/html" ; nil
    else ; raise
    end
    html = Nokogiri::HTML NetHTTPUtils.request_data link, :GET, header: {"User-Agent" => "Mozilla"}
    if t = html.at_css("meta[@property='og:image']")
      begin
        return DirectLink URI.join(link, t[:content]).to_s, nil, *proxy, giveup: true
      rescue URI::InvalidURIError
      end
    end unless ignore_meta
    h = {}  # TODO: maybe move it outside because of possible img[:src] recursion?...
    l = lambda do |node, s = []|
      node.element_children.flat_map do |child|
        next l[child, s + [child.node_name]] unless "img" == child.node_name
        begin
          [[s, (h[child[:src]] = h[child[:src]] || DirectLink(URI.join(link, child[:src]).to_s, nil, giveup: true))]]  # ... or wait, do we giveup?
        rescue => e
          DirectLink.logger.error "#{e} (from no giveup)"
          []
        end
      end
    end
    l[html].
      tap{ |results| raise if results.empty? }.
      group_by(&:first).map{ |k, v| [k.join(?>), v.map(&:last)] }.
      max_by{ |_, v| v.map{ |i| i.width * i.height }.inject(:+) }.last
  else
    # TODO: maybe move this to right before `rescue` line
    w, h = f.size
    struct.new f.instance_variable_get(:@parsed_uri).to_s, w, h, f.type
  end
end
