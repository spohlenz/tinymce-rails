Gem::Specification.new do |s|
  s.name = "tinymce-rails"
  s.version = "3.4.8.1"
  s.summary = "Rails asset pipeline integration for TinyMCE."
  s.description = "Seamlessly integrates TinyMCE into the Rails asset pipeline introduced in Rails 3.1."
  s.files = Dir["README.md", "LICENSE", "Rakefile", "assets/**/*", "lib/**/*"]
  s.authors = ["Sam Pohlenz"]
  s.email = "sam@sampohlenz.com"
  
  s.add_dependency "railties",  ">= 3.1"
  s.add_dependency "rails", ">= 3.1"
end
