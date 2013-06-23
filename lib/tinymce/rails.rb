module TinyMCE
  module Rails
    require 'tinymce/rails/engine'
    require 'tinymce/rails/version'
    require "tinymce/rails/configuration"
    require "tinymce/rails/configuration_file"
    require "tinymce/rails/helper"

    def self.configuration
      @configuration ||= ConfigurationFile.new(::Rails.root.join("config/tinymce.yml"))
      @configuration.respond_to?(:configuration) ? @configuration.configuration : @configuration
    end

    def self.configuration=(configuration)
      @configuration = configuration
    end
  end
end
