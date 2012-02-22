require 'spec_helper'

module TinyMCE::Rails
  describe Configuration do
    it "has default options" do
      Configuration.defaults.should eq(
        "mode"     => "textareas",
        "theme"    => "advanced",
        "language" => "en",
        "editor_selector" => "tinymce"
      )
    end
    
    it "uses the current locale if available" do
      I18n.locale = "pirate"
      Configuration.defaults["language"].should eq("pirate")
    end
    
    it "falls back to English if the current locale is not available" do
      I18n.locale = "missing"
      Configuration.defaults["language"].should eq("en")
    end
    
    it "uses default options when instantiated without a filename" do
      config = Configuration.new
      config.options.should eq(Configuration.defaults)
    end
    
    it "loads configuration from YAML file when instantiated with a filename"
    
    it "detects available languages" do
      langs = Configuration.available_languages

      langs.should include("en")
      langs.should include("pirate")
      langs.should include("erb")
      
      langs.should_not include("missing")
    end
  end
end
