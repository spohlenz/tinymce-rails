require 'fingerprintless-assets'

module TinyMCE
  class Railtie < Rails::Railtie
    def asset_root
      File.join(File.dirname(__FILE__), "../../assets")
    end
    
    initializer "configure assets" do |app|
      app.config.assets.paths.unshift File.join(asset_root, 'integration')
      app.config.assets.paths.unshift File.join(asset_root, 'vendor')
      
      app.config.assets.fingerprinting.exclude << "tinymce/*"
      app.config.assets.precompile << "tinymce/*"
    end
  end
end
