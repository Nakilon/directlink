Gem::Specification.new do |spec|
  spec.name         = "directlink"
  spec.version      = "0.0.8.1"
  spec.summary      = "converts any kind of image hyperlink to direct link, type of image and its resolution"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.homepage     = "https://github.com/nakilon/directlink"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/directlink"}

  spec.add_dependency "fastimage", "~>2.1.3"
  spec.add_dependency "nokogiri"
  spec.add_dependency "nethttputils", "~>0.3.2.3"   # HEAD form fix
  spec.add_dependency "reddit_bot", "~>1.7.0"
  spec.add_dependency "kramdown"
  spec.add_dependency "addressable"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "byebug"

  spec.require_path = "lib"
  spec.bindir       = "bin"
  spec.executable   = "directlink"
  spec.test_file    = "test.rb"
  spec.files        = `git ls-files -z`.split(?\0) - spec.test_files

  spec.requirements << "you may need to create apps and provide their API tokens:"
  spec.requirements << "IMGUR_CLIENT_ID, FLICKR_API_KEY, REDDIT_SECRETS"
end
