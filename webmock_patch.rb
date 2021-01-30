WebMock.enable_net_connect!

# executes the request to make us know how what to stub it with


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
end
WebMock.module_eval do
  define_method(:net_connect_allowed?){ |*| true }
end
WebMock::HttpLibAdapters::NetHttpAdapter.instance_variable_get(:@webMockNetHTTP).class_eval do
  old_start_with_connect = instance_method :start_with_connect
  define_method :start_with_connect do |&block|
    begin
      old_start_with_connect.bind(self).(&block)
    ensure
      raise WebMock::NetConnectNotAllowedError.new(eval "request_signature", block.binding)
    end
  end

  # see https://github.com/bblimke/webmock/issues/469#issuecomment-752411256
  old_request = instance_method :request
  define_method :request do |request, &block|
    old_request.bind(self).(request, &block).tap do |response|
      response.uri = request.uri
    end
  end

end
