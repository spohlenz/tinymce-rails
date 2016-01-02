require 'spec_helper'

module TinyMCE::Rails
  describe Helper do
    if defined?(Sprockets::Rails::Helper)
      include Sprockets::Rails::Helper
      
      self.assets_environment  = Rails.application.assets
      self.assets_prefix       = Rails.application.config.assets.prefix

      if respond_to?(:resolve_assets_with=)
        self.resolve_assets_with = [:environment]
      end

      if respond_to?(:precompiled_asset_checker)
        self.precompiled_asset_checker = ActionView::Base.precompiled_asset_checker
      end
    else
      include Sprockets::Helpers::RailsHelper
    end
    
    describe "#tinymce_assets" do
      it "returns a TinyMCE javascript tag" do
        expect(tinymce_assets).to have_selector("script[src='/assets/tinymce.js']", :visible => false)
      end
    end
    
    describe "#tinymce" do
      before(:each) do
        allow(TinyMCE::Rails).to receive(:configuration).and_return(configuration)
      end
      
      context "single-configuration" do
        let(:configuration) {
          Configuration.new("theme" => "advanced", "plugins" => %w(paste table fullscreen))
        }
        
        it "initializes TinyMCE using global configuration" do
          result = tinymce
          expect(result).to have_selector("script", :visible => false)
          expect(result).to include('tinyMCE.init({')
          expect(result).to include('theme: "advanced"')
          expect(result).to include('plugins: "paste,table,fullscreen"')
          expect(result).to include('});')
        end
      
        it "initializes TinyMCE with passed in options" do
          result = tinymce(:theme => "simple")
          expect(result).to include('theme: "simple"')
          expect(result).to include('plugins: "paste,table,fullscreen"')
        end
      
        it "outputs function strings without quotes" do
          result = tinymce(:oninit => "function() { alert('Hello'); }")
          expect(result).to include('oninit: function() { alert(\'Hello\'); }')
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
          expect(result).to include('theme: "advanced"')
          expect(result).to include('plugins: "paste,table"')
        end
        
        it "merges passed in options with default configuration" do
          result = tinymce(:theme => "simple")
          expect(result).to include('theme: "simple"')
          expect(result).to include('plugins: "paste,table"')
        end
        
        it "initializes TinyMCE with custom configuration" do
          result = tinymce(:alternate)
          expect(result).to include('skin: "alternate"')
        end
        
        it "merges passed in options with custom configuration" do
          result = tinymce(:alternate, :theme => "simple")
          expect(result).to include('theme: "simple"')
          expect(result).to include('skin: "alternate"')
        end
        
        it "raises an error when given an invalid configuration" do
          expect { tinymce(:missing) }.to raise_error(IndexError)
        end
      end
    end
  end
end
