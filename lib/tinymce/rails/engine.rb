module TinyMCE
  module Rails
    class Engine < ::Rails::Engine
      config.tinymce = ActiveSupport::OrderedOptions.new

      rake_tasks do
        load File.join(File.dirname(__FILE__), 'assets.rake')
      end
    end
  end
end
