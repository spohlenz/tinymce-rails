module TinyMCE
  module Rails
    class Engine < ::Rails::Engine
      config.tinymce = ActiveSupport::OrderedOptions.new
    end
  end
end
