WebMock.enable_net_connect!
WebMock.disable!  # the above command does .enable! implicitely

# executes the request to make us know what to stub it with
WebMock.after_request real_requests_only: true do |req_signature, response|
  puts "Request:\n#{req_signature}"
  if response.body
    dup = response.dup
    File.write "body.txt", dup.body
    dup.body = "<<< FILE: ./body.txt >>>"
    puts "Response:\n#{dup.pretty_inspect}"
  else
    puts "Response:\n#{response.pretty_inspect}"
  end
  raise WebMock::NetConnectNotAllowedError.new req_signature
end
WebMock.module_eval do
  define_method(:net_connect_allowed?){ |*| true }
end

# https://github.com/bblimke/webmock/issues/469#issuecomment-752411256
WebMock::HttpLibAdapters::NetHttpAdapter.instance_variable_get(:@webMockNetHTTP).class_eval do
  old_request = instance_method :request
  define_method :request do |request, &block|
    old_request.bind(self).(request, &block).tap do |response|
      response.uri = request.uri
    end
  end
end
