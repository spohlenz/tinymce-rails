require 'spec_helper'

module TinyMCE::Rails
  describe Engine do
    describe ".default_base" do
      before(:each) do
        Rails.application.config.assets.prefix = "/assets"
        Rails.application.config.relative_url_root = nil
        Rails.application.config.action_controller.asset_host = nil
      end

      it "generates a default path based on the asset prefix" do
        expect(TinyMCE::Rails::Engine.default_base).to eq "/assets/tinymce"
      end

      it "ignores the asset prefix if missing" do
        Rails.application.config.assets.prefix = nil
        expect(TinyMCE::Rails::Engine.default_base).to eq "/tinymce"
      end

      it "includes the Rails relative_url_root if provided" do
        Rails.application.config.relative_url_root = "/prefix"
        expect(TinyMCE::Rails::Engine.default_base).to eq "/prefix/assets/tinymce"
      end
      
      it "includes the asset host if it is a string" do
        Rails.application.config.action_controller.asset_host = "http://assets.example.com"
        expect(TinyMCE::Rails::Engine.default_base).to eq "http://assets.example.com/assets/tinymce"
      end
      
      it "interpolates the asset host if it is a string containing %d" do
        Rails.application.config.action_controller.asset_host = "http://assets%d.example.com"
        expect(TinyMCE::Rails::Engine.default_base).to eq "http://assets0.example.com/assets/tinymce"
      end
      
      it "does not include the asset host if it is a callable" do
        Rails.application.config.action_controller.asset_host = ->(request) { "http://assets.example.com" }
        expect(TinyMCE::Rails::Engine.default_base).to eq "/assets/tinymce"
      end
      
      it "uses a protocol relative address if asset host does not include a protocol" do
        Rails.application.config.action_controller.asset_host = "assets.example.com"
        expect(TinyMCE::Rails::Engine.default_base).to eq "//assets.example.com/assets/tinymce"
      end
      
      it "includes the asset host as is if it is already a protocol relative address" do
        Rails.application.config.action_controller.asset_host = "//assets.example.com"
        expect(TinyMCE::Rails::Engine.default_base).to eq "//assets.example.com/assets/tinymce"
      end
      
      it "interpolates and uses a protocol relative address if asset host includes %d and no protocol" do
        Rails.application.config.action_controller.asset_host = "assets%d.example.com"
        expect(TinyMCE::Rails::Engine.default_base).to eq "//assets0.example.com/assets/tinymce"
      end
    end
  end
end
