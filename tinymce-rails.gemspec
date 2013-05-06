require File.expand_path('../lib/tinymce/rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "tinymce-rails"
  s.version = TinyMCE::Rails::VERSION
  s.summary = "Rails asset pipeline integration for TinyMCE."
  s.description = "Seamlessly integrates TinyMCE into the Rails asset pipeline introduced in Rails 3.1."
  s.files = Dir["README.md", "LICENSE", "Rakefile", "app/**/*", "lib/**/*", "vendor/**/*"]
  s.authors = ["Sam Pohlenz"]
  s.email = "sam@sampohlenz.com"
  s.homepage = "https://github.com/spohlenz/tinymce-rails"
  
  s.add_dependency "railties",  ">= 3.1.1"
end
