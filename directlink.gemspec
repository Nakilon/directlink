Gem::Specification.new do |spec|
  spec.name         = "directlink"
  spec.version      = "0.0.0.0"
  spec.summary      = "converts image page URL to direct link, dimensions and image type"

  spec.homepage     = "https://github.com/nakilon/directlink"
  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"

  spec.add_dependency "nethttputils", "~>0.2.0.0"
  spec.add_dependency "fastimage", "~>2.1.3"
  spec.add_development_dependency "minitest"

  spec.require_path = "lib"
  spec.test_files   = ["spec"]
  spec.files        = `git ls-files -z`.split(?\0) - spec.test_files
end
