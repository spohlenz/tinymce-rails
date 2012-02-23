module TinyMCE
  module Rails

    require 'tinymce/rails/engine'
    require 'tinymce/rails/railtie'
    require 'tinymce/rails/version'

    def self.base
      [
        ::Rails.application.config.action_controller.asset_host,
        ::ActionController::Base.config.relative_url_root,
        ::Rails.application.config.assets.prefix,
        '/tinymce'
      ].compact.join
    end

  end
end
