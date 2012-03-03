module TinyMCE
  module Rails
    class Engine < ::Rails::Engine
      config.tinymce = ActiveSupport::OrderedOptions.new
      
      # Set an explicit base path for TinyMCE assets (usually defaults to /assets/tinymce)
      config.tinymce.base = nil
    end
  end
end
