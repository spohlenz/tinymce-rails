require 'spec_helper'

describe TinyMCE do
  before(:each) do
    Rails.application.config.action_controller.asset_host = nil
    ActionController::Base.config.relative_url_root = nil
  end
  
  it "has a base path" do
    TinyMCE.base.should eq("/assets/tinymce")
  end
  
  it "uses the asset host in the base path when set" do
    Rails.application.config.action_controller.asset_host = "http://assets.example.com"
    TinyMCE.base.should eq("http://assets.example.com/assets/tinymce")
  end
  
  it "uses the relative url root in the base path when set" do
    ActionController::Base.config.relative_url_root = "/subfolder"
    TinyMCE.base.should eq("/subfolder/assets/tinymce")
  end
end
