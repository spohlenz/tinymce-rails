module TinyMCE::Rails
  class Engine < ::Rails::Engine
    config.tinymce = ActiveSupport::OrderedOptions.new

    initializer "precompile", :group => :all do |app|
      app.config.assets.precompile << "tinymce.js"
    end

    initializer "helper" do |app|
      ActionController::Base.helper(TinyMCEHelper)
    end
  end
end
