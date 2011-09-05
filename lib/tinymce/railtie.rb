require 'fingerprintless-assets'

module TinyMCE
  class Railtie < Rails::Railtie
    def asset_root
      File.join(File.dirname(__FILE__), "../../assets")
    end
    
    rake_tasks do
      load "tinymce/assets.rake"
    end
    
    initializer "configure assets" do |app|
      app.config.assets.paths.unshift File.join(asset_root, 'integration')
      app.config.assets.paths.unshift File.join(asset_root, 'vendor')
      
      if app.config.assets.enabled
        app.config.assets.fingerprinting.exclude << "tinymce/*"
      end
    end
    
    initializer "static assets" do |app|
      if app.config.serve_static_assets
        app.config.assets.paths.unshift File.join(asset_root, 'precompiled')
      end
    end
  end
end
