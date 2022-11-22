Gem::Specification.new do |spec|
  spec.name         = "directlink"
  spec.version      = "0.0.12.0"
  spec.summary      = "obtains from any kind of hyperlink a link to an image, its format and resolution"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.homepage     = "https://github.com/nakilon/directlink"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/directlink"}

  spec.required_ruby_version = ">=2.3"

  spec.add_dependency "fastimage", "~>2.2.0"
  spec.add_dependency "nokogiri", "<1.11"   # 1.11 requires ruby 2.5  # TODO: switch to Oga?
  spec.add_dependency "reddit_bot", "~>1.10.0"
  spec.add_dependency "kramdown"
  spec.add_dependency "addressable"
  spec.add_dependency "nakischema"

  # spec.require_path = "lib"
  # spec.bindir       = "bin"
  spec.executable   = "directlink"
  spec.test_file    = "unit.test.rb"
  spec.files        = %w{ LICENSE directlink.gemspec lib/directlink.rb bin/directlink }

  spec.requirements << "you may want to create apps and provide API tokens:"
  spec.requirements << "IMGUR_CLIENT_ID, FLICKR_API_KEY, REDDIT_SECRETS, VK_ACCESS_TOKEN, VK_CLIENT_SECRET"
end
