Gem::Specification.new do |spec|
  spec.name         = "directlink"
  spec.version      = "0.0.9.3"
  spec.summary      = "obtains from any kind of hyperlink a link to an image, its format and resolution"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.homepage     = "https://github.com/nakilon/directlink"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/directlink"}

  spec.required_ruby_version = ">=2.3"  # because <<~ heredocs in tests

  spec.add_dependency "fastimage", "~>2.2.0"
  spec.add_dependency "nokogiri"
  spec.add_dependency "nethttputils", "~>0.4.1.0"
  spec.add_dependency "reddit_bot", "~>1.7.8"
  spec.add_dependency "kramdown"
  spec.add_dependency "addressable"
  spec.add_development_dependency "minitest-around"
  spec.add_development_dependency "webmock"

  spec.require_path = "lib"
  spec.bindir       = "bin"
  spec.executable   = "directlink"
  spec.test_file    = "test.rb"
  spec.files        = %w{ LICENSE directlink.gemspec lib/directlink.rb bin/directlink }

  spec.requirements << "you may want to create apps and provide API tokens:"
  spec.requirements << "IMGUR_CLIENT_ID, FLICKR_API_KEY, REDDIT_SECRETS"
end
