module TinyMCE::Rails
  class Engine < ::Rails::Engine
    config.tinymce = ActiveSupport::OrderedOptions.new
    
    # Set an explicit base path for TinyMCE assets (usually defaults to /assets/tinymce)
    config.tinymce.base = nil

    initializer "precompile", :group => :all do |app|
      app.config.assets.precompile << "tinymce.js"
    end

    initializer "helper" do |app|
      ActiveSupport.on_load(:action_view) do
        include Helper
      end
    end

    def self.base
      config.tinymce.base || default_base
    end

    def self.default_base
      File.join(Rails.application.config.relative_url_root || "", Rails.application.config.assets.prefix || "/", "tinymce")
    end
  end
end
