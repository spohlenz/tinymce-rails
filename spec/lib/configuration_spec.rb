require 'spec_helper'

module TinyMCE::Rails
  describe Configuration do
    it "has default options" do
      expect(Configuration.defaults).to eq(
        "mode"            => "specific_textareas",
        "theme"           => "advanced",
        "editor_selector" => "tinymce"
      )
    end
    
    it "is instantiable with an options hash" do
      options = { "option" => "value" }
      config = Configuration.new(options)
      expect(config.options).to eq(options)
    end
    
    it "detects available languages" do
      langs = Configuration.available_languages

      expect(langs).to include("en")
      expect(langs).to include("pirate")
      expect(langs).to include("erb")
      
      expect(langs).to_not include("missing")
    end
    
    describe "#options_for_tinymce" do
      it "returns string options as normal" do
        config = Configuration.new("mode" => "textareas")
        expect(config.options_for_tinymce["mode"]).to eq("textareas")
      end
      
      it "combines arrays of strings into a single comma-separated string" do
        config = Configuration.new("plugins" => %w(paste table fullscreen))
        expect(config.options_for_tinymce["plugins"]).to eq("paste,table,fullscreen")
      end
      
      it "works with integer values" do
        config = Configuration.new("width" => 123)
        expect(config.options_for_tinymce["width"]).to eq(123)
      end
      
      it "converts javascript function strings to Function objects" do
        config = Configuration.new("oninit" => "function() {}")
        expect(config.options_for_tinymce["oninit"]).to be_a(Configuration::Function)
      end
      
      it "returns the language based on the current locale" do
        I18n.locale = "pirate"
        
        config = Configuration.new({})
        expect(config.options_for_tinymce["language"]).to eq("pirate")
      end
      
      it "falls back to English if the current locale is not available" do
        I18n.locale = "missing"
        
        config = Configuration.new({})
        expect(config.options_for_tinymce["language"]).to eq("en")
      end
      
      it "does not override the language if already provided" do
        config = Configuration.new("language" => "es")
        expect(config.options_for_tinymce["language"]).to eq("es")
      end
    end
    
    describe "#merge" do
      subject { Configuration.new("mode" => "textareas") }
      
      it "merges given options with configuration options" do
        result = subject.merge("theme" => "advanced")
        expect(result.options).to eq(
          "mode" => "textareas",
          "theme" => "advanced"
        )
      end
      
      it "does not alter the original configuration object" do
        subject.merge("theme" => "advanced")
        expect(subject.options).to_not have_key("theme")
      end
    end
  end
end
