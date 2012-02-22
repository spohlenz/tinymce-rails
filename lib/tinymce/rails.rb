module TinyMCE
  module Rails
    require 'tinymce/rails/engine'
    require 'tinymce/rails/version'
    require "tinymce/rails/configuration"
    require "tinymce/rails/tinymce_helper"

    def self.configuration
      Configuration.new(Configuration.defaults)
    end

    def self.base
      Engine.config.tinymce.base ||
        [::Rails.application.config.action_controller.asset_host,
         ActionController::Base.config.relative_url_root,
         ::Rails.application.config.assets.prefix, '/tinymce'].compact.join
    end
  end
end
