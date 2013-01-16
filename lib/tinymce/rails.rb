module TinyMCE
  module Rails
    require 'tinymce/rails/engine'
    require 'tinymce/rails/version'
    require "tinymce/rails/configuration"
    require "tinymce/rails/helper"

    def self.configuration
      @configuration ||= Configuration.load(::Rails.root.join("config/tinymce.yml"))
    end

    def self.configuration=(configuration)
      @configuration = configuration
    end
  end
end
