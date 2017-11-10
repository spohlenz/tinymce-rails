module TinyMCE
  module Rails
    require 'tinymce/rails/engine'
    require 'tinymce/rails/version'
    require "tinymce/rails/configuration"
    require "tinymce/rails/configuration_file"
    require "tinymce/rails/helper"
    require "tinymce/rails/environment" if defined?(Sprockets::Rails::Environment)

    def self.configuration
      @configuration ||= ConfigurationFile.new(Engine.config_path)
      @configuration.respond_to?(:configuration) ? @configuration.configuration : @configuration
    end

    def self.configuration=(configuration)
      @configuration = configuration
    end

    def self.each_configuration(&block)
      if configuration.is_a?(MultipleConfiguration)
        configuration.each(&block)
      else
        yield :default, configuration
      end
    end
  end
end
