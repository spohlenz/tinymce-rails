module TinyMCE
  module Rails
    require 'tinymce/rails/engine'
    require 'tinymce/rails/version'
    require 'tinymce/rails/configuration/configuration'
    require 'tinymce/rails/configuration/single_configuration'
    require 'tinymce/rails/configuration/multiple_configuration'
    require 'tinymce/rails/helper'

    def self.configuration
      @configuration ||= Configuration.load(::Rails.root.join("config/tinymce.yml"))
    end
  end
end
