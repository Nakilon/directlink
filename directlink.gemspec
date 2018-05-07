Gem::Specification.new do |spec|
  spec.name         = "directlink"
  spec.version      = "0.0.1.0"
  spec.summary      = "converts image page URL to direct link, dimensions and image type"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.homepage     = "https://github.com/nakilon/directlink"

  spec.add_dependency "nethttputils", "~>0.2.2.0"
  spec.add_dependency "fastimage", "~>2.1.3"
  spec.add_development_dependency "minitest"

  spec.require_path = "lib"
  spec.bindir       = "bin"
  spec.executable   = "directlink"
  spec.test_file    = "test.rb"
  spec.files        = `git ls-files -z`.split(?\0) - spec.test_files

  spec.requirements << "you may need to create apps and provide their API tokens:"
  spec.requirements << "IMGUR_CLIENT_ID, FLICKR_API_KEY, _500PX_CONSUMER_KEY"
end
