require 'spec_helper'

module TinyMCE::Rails
  describe Helper do
    describe "#tinymce_assets" do
      it "returns a TinyMCE javascript tag" do
        tinymce_assets.should have_selector("script", :type => "text/javascript", :src => "/assets/tinymce.js")
      end
    end

    describe "#tinymce" do
      before(:each) do
        TinyMCE::Rails.stub(:configuration).and_return(configuration)
      end
      describe "single configuration" do
        let(:configuration) {
          Configuration.load("theme" => "advanced", "plugins" => %w(paste table fullscreen))
        }
        it "initializes TinyMCE using global configuration" do
          result = tinymce
          result.should have_selector("script", :type => "text/javascript")
          result.should include('tinyMCE.init({')
          result.should include('"theme":"advanced"')
          result.should include('"plugins":"paste,table,fullscreen"')
          result.should include('});')
        end

        it "initializes TinyMCE with passed in options" do
          result = tinymce(:theme => "simple")
          result.should include('"theme":"simple"')
          result.should include('"plugins":"paste,table,fullscreen"')
        end

        it "outputs function strings without quotes" do
          result = tinymce(:oninit => "function() { alert('Hello'); }")
          result.should include('"oninit":function() { alert(\'Hello\'); }')
        end
      end

      describe "multiple configuration" do
        let(:configuration) {
          Configuration.load(File.expand_path("../fixtures/tinymce_multiple.yml", File.dirname(__FILE__)))
        }

        it "initialize TimyMCE using default config" do
          result = tinymce
          result.should include('"option_specified_with_erb_value":"ERB"')
          result.should include('"plugins":"inlinepopups,imageselector,contextmenu,paste,table,fullscreen"')
        end

        it "initialize TinyMCE using custom config" do
          result = tinymce(:config => "sexy")
          result.should include('"theme_advanced_toolbar_location":"sexy_top"')
          result.should include('"theme_advanced_toolbar_align":"sexy_left"')
        end

        it "initialize TinyMCE using custom config with overriding value" do
          result = tinymce(:config => "sexy", "theme_advanced_toolbar_location" => "sexy_top_2")
          result.should include('"theme_advanced_toolbar_location":"sexy_top_2"')
          result.should include('"theme_advanced_toolbar_align":"sexy_left"')
        end

      end
    end
  end
end
