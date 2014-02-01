ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../sandbox/config/application", __FILE__)

Sandbox::Application.config.assets.paths << File.expand_path("../assets", __FILE__)
Sandbox::Application.initialize!

require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

I18n.enforce_available_locales = false

RSpec.configure do |config|
end
