require 'spec_helper'

module TinyMCE
  describe Rails do
    describe ".base" do
      before(:each) do
        ::Rails.application.config.action_controller.asset_host = nil
        ActionController::Base.config.relative_url_root = nil
      end
      
      it "has a base path" do
        TinyMCE::Rails.base.should eq("/assets/tinymce")
      end
      
      it "uses the asset host in the base path when set" do
        ::Rails.application.config.action_controller.asset_host = "http://assets.example.com"
        TinyMCE::Rails.base.should eq("http://assets.example.com/assets/tinymce")
      end
      
      it "uses the relative url root in the base path when set" do
        ActionController::Base.config.relative_url_root = "/subfolder"
        TinyMCE::Rails.base.should eq("/subfolder/assets/tinymce")
      end
    end

    describe ".configuration" do
      let(:configuration_file) { ::Rails.root.join("config/tinymce.yml") }
      let(:configuration) { stub }
      
      it "loads the tinymce.yml config file" do
        TinyMCE::Rails::Configuration.should_receive(:load).with(configuration_file).and_return(configuration)
        TinyMCE::Rails.configuration.should eq(configuration)
      end
    end
  end
end
