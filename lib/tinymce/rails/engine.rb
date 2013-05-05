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
      File.join(relative_url_root || "", Rails.application.config.assets.prefix || "/", "tinymce")
    end
    
    def self.relative_url_root
      config = Rails.application.config
      
      if config.respond_to?(:relative_url_root)
        config.relative_url_root
      else
        # Fallback for Rails 3.1
        config.action_controller.relative_url_root
      end
    end
  end
end
