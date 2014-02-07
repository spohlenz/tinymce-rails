require 'spec_helper'

module TinyMCE::Rails
  describe Helper do
    if defined?(Sprockets::Rails::Helper)
      include Sprockets::Rails::Helper
      
      self.assets_environment = Rails.application.assets
      self.assets_prefix      = Rails.application.config.assets.prefix
    else
      include Sprockets::Helpers::RailsHelper
    end
    
    describe "#tinymce_assets" do
      it "returns a TinyMCE javascript tag" do
        tinymce_assets.should have_selector("script[src='/assets/tinymce.js']")
      end
    end
    
    describe "#tinymce" do
      before(:each) do
        TinyMCE::Rails.stub(:configuration).and_return(configuration)
      end
      
      context "single-configuration" do
        let(:configuration) {
          Configuration.new("theme" => "advanced", "plugins" => %w(paste table fullscreen))
        }
        
        it "initializes TinyMCE using global configuration" do
          result = tinymce
          result.should have_selector("script")
          result.should include('tinyMCE.init({')
          result.should include('theme: "advanced"')
          result.should include('plugins: "paste,table,fullscreen"')
          result.should include('});')
        end
      
        it "initializes TinyMCE with passed in options" do
          result = tinymce(:theme => "simple")
          result.should include('theme: "simple"')
          result.should include('plugins: "paste,table,fullscreen"')
        end
      
        it "outputs function strings without quotes" do
          result = tinymce(:oninit => "function() { alert('Hello'); }")
          result.should include('oninit: function() { alert(\'Hello\'); }')
        end
      end
      
      context "multiple-configuration" do
        let(:configuration) {
          MultipleConfiguration.new(
            "default" => { "theme" => "advanced", "plugins" => %w(paste table) },
            "alternate" => { "skin" => "alternate" }
          )
        }
        
        it "initializes TinyMCE with default configuration" do
          result = tinymce
          result.should include('theme: "advanced"')
          result.should include('plugins: "paste,table"')
        end
        
        it "merges passed in options with default configuration" do
          result = tinymce(:theme => "simple")
          result.should include('theme: "simple"')
          result.should include('plugins: "paste,table"')
        end
        
        it "initializes TinyMCE with custom configuration" do
          result = tinymce(:alternate)
          result.should include('skin: "alternate"')
        end
        
        it "merges passed in options with custom configuration" do
          result = tinymce(:alternate, :theme => "simple")
          result.should include('theme: "simple"')
          result.should include('skin: "alternate"')
        end
        
        it "raises an error when given an invalid configuration" do
          expect { tinymce(:missing) }.to raise_error(IndexError)
        end
      end
    end
  end
end
