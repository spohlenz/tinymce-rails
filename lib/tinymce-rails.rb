module TinyMCE
  class Railtie < Rails::Railtie
    initializer "configure assets" do |app|
      app.config.assets.paths.unshift File.join(File.dirname(__FILE__), "../assets/integration")
      app.config.assets.paths.unshift File.join(File.dirname(__FILE__), "../assets/vendor")
      
      app.config.assets.fingerprinting.exclude << "tiny_mce/*"
      app.config.assets.precompile << "tiny_mce/*"
    end
  end
end
