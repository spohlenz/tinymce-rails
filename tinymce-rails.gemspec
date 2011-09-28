# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tinymce/rails/version"

Gem::Specification.new do |s|
  s.name = "tinymce-rails"
  s.version = TinyMCE::Rails::VERSION
  s.summary = "Rails 3.1 integration for TinyMCE."
  s.description = "Seamlessly integrates TinyMCE into the Rails 3.1 asset pipeline."
  s.files = Dir["README.md", "LICENSE", "Rakefile", "assets/**/*", "lib/**/*"]
  s.authors = ["Sam Pohlenz"]
  s.email = "sam@sampohlenz.com"

  s.add_dependency "rails",  "~> 3.1.0"
end

