require 'spec_helper'

module TinyMCE::Rails
  describe Configuration do
    it "has default options" do
      Configuration.defaults.should eq(
        "mode"            => "specific_textareas",
        "theme"           => "advanced",
        "editor_selector" => "tinymce"
      )
    end
    
    it "is instantiable with an options hash" do
      options = { "option" => "value" }
      config = Configuration.new(options)
      config.options.should eq(options)
    end
    
    it "detects available languages" do
      langs = Configuration.available_languages

      langs.should include("en")
      langs.should include("pirate")
      langs.should include("erb")
      
      langs.should_not include("missing")
    end
    
    describe "#options_for_tinymce" do
      it "returns string options as normal" do
        config = Configuration.new("mode" => "textareas")
        config.options_for_tinymce["mode"].should eq("textareas")
      end
      
      it "combines arrays of strings into a single comma-separated string" do
        config = Configuration.new("plugins" => %w(paste table fullscreen))
        config.options_for_tinymce["plugins"].should eq("paste,table,fullscreen")
      end
      
      it "works with integer values" do
        config = Configuration.new("width" => 123)
        config.options_for_tinymce["width"].should eq(123)
      end
      
      it "converts javascript function strings to Function objects" do
        config = Configuration.new("oninit" => "function() {}")
        config.options_for_tinymce["oninit"].should be_a(Configuration::Function)
      end
      
      it "returns the language based on the current locale" do
        I18n.locale = "pirate"
        
        config = Configuration.new({})
        config.options_for_tinymce["language"].should eq("pirate")
      end
      
      it "falls back to English if the current locale is not available" do
        I18n.locale = "missing"
        
        config = Configuration.new({})
        config.options_for_tinymce["language"].should eq("en")
      end
      
      it "does not override the language if already provided" do
        config = Configuration.new("language" => "es")
        config.options_for_tinymce["language"].should eq("es")
      end
    end
    
    describe "#merge" do
      subject { Configuration.new("mode" => "textareas") }
      
      it "merges given options with configuration options" do
        result = subject.merge("theme" => "advanced")
        result.options.should eq(
          "mode" => "textareas",
          "theme" => "advanced"
        )
      end
      
      it "does not alter the original configuration object" do
        subject.merge("theme" => "advanced")
        subject.options.should_not have_key("theme")
      end
    end
  end
end
