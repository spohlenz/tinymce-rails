module TinyMCE::Rails
  class Engine < ::Rails::Engine
    config.tinymce = ActiveSupport::OrderedOptions.new
    
    # Set an explicit base path for TinyMCE assets (usually defaults to /assets/tinymce)
    config.tinymce.base = nil

    initializer "precompile", :group => :all do |app|
      app.config.assets.precompile << "tinymce.js"
    end

    initializer "helper" do |app|
      ActionController::Base.helper(Helper)
    end
  end
end
