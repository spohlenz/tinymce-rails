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
      File.join(asset_host || "", relative_url_root || "",
                Rails.application.config.assets.prefix || "/",
                "tinymce")
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

    def self.asset_host
      host = Rails.application.config.action_controller.asset_host
      
      if host.respond_to?(:call)
        # Callable asset hosts cannot be supported during
        # precompilation as there is no request object
        nil
      elsif host =~ /%d/
        # Load all TinyMCE assets from the first asset host
        normalize_host(host % 0)
      else
        normalize_host(host)
      end
    end
    
    def self.normalize_host(host)
      if host =~ /^https?:\/\// || host =~ /^\/\//
        host
      else
        # Use a protocol-relative URL if not otherwise specified
        "//#{host}"
      end
    end
  end
end
