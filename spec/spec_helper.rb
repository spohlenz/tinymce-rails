ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../sandbox/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}

Rails.application.assets.append_path File.expand_path("../assets", __FILE__)

RSpec.configure do |config|
end
