unless defined? TinyMCE::VERSION
  $:.unshift File.expand_path("../lib", __FILE__)
  require "tinymce/version"
end

Gem::Specification.new do |s|
  s.name = "tinymce-rails"
  s.version = TinyMCE::VERSION
  s.summary = "Rails 3.1 integration for TinyMCE."
  s.description = "Seamlessly integrates TinyMCE into the Rails 3.1 asset pipeline."
  s.files = Dir["README.md", "Rakefile", "assets/**/*", "lib/**/*.rb"]
  s.authors = ["Sam Pohlenz"]
  s.email = "sam@sampohlenz.com"
  
  s.add_dependency "railties",   "~> 3.1.0.rc5"
  s.add_dependency "actionpack", "~> 3.1.0.rc5"
  s.add_dependency "fingerprintless-assets", "~> 1.0.pre"
end
