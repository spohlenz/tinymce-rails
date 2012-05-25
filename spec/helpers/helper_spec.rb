require 'spec_helper'

module TinyMCE::Rails
  describe Helper do
    describe "#tinymce_assets" do
      it "returns a TinyMCE javascript tag" do
        tinymce_assets.should have_selector("script", :type => "text/javascript", :src => "/assets/tinymce.js")
      end
    end
    
    describe "#tinymce" do
      let(:configuration) {
        Configuration.new("theme" => "advanced", "plugins" => %w(paste table fullscreen))
      }
      
      before(:each) do
        TinyMCE::Rails.stub(:configuration).and_return(configuration)
      end
      
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
  end
end
