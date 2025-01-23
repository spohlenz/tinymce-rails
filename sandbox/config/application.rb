require_relative 'boot'

require "logger"

# Pick the frameworks you want:
#  require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "active_resource/railtie"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require

module Sandbox
  class Application < Rails::Application
    # Initialize configuration defaults for current Rails version.
    config.load_defaults Rails::VERSION::STRING.to_f

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Precompile application assets
    config.assets.precompile += %w(tinymce-manual.js)
    config.assets.precompile << "tinymce/**/es.js"
    config.assets.precompile << "tinymce/**/es_dlg.js"

    # config.tinymce.install = :compile
  end
end
