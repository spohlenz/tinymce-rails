require 'spec_helper'

module TinyMCE::Rails
  describe Configuration do

    context "no configuration file" do
      it "is instantiable with an options hash" do
        options = { "option" => "value" }
        config = Configuration.load(options)
        config.options.should eq(SingleConfiguration.defaults.merge(options))
      end

      it "uses default configuration when loading a nonexistant file" do
        config = Configuration.load("missing.yml")
        config.options.should eq(SingleConfiguration.defaults)
      end
    end

    context "configuration file with one config" do
      it "loads configuration from YAML file" do
        file = File.expand_path("../../fixtures/tinymce.yml", File.dirname(__FILE__))
        config = Configuration.load(file)
        config.options.should eq(
          "mode" => "specific_textareas",
          "theme" => "advanced",
          "editor_selector" => "tinymce",
          "plugins" => %w(inlinepopups imageselector contextmenu paste table fullscreen),
          "theme_advanced_toolbar_location" => "top",
          "theme_advanced_toolbar_align" => "left",
          "option_specified_with_erb_value" => "ERB"
        )
      end
    end

    context "configuration file with multiple configs" do

      it "loads configuration from YAML file and uses default config" do
        file = File.expand_path("../../fixtures/tinymce_multiple.yml", File.dirname(__FILE__))
        config = Configuration.load(file)
        config.options.should eq(
          "mode" => "specific_textareas",
          "theme" => "advanced",
          "editor_selector" => "tinymce",
          "plugins" => %w(inlinepopups imageselector contextmenu paste table fullscreen),
          "theme_advanced_toolbar_location" => "top",
          "theme_advanced_toolbar_align" => "left",
          "option_specified_with_erb_value" => "ERB"
        )
      end
    end


    it "detects available languages" do
      langs = SingleConfiguration.available_languages

      langs.should include("en")
      langs.should include("pirate")
      langs.should include("erb")

      langs.should_not include("missing")
    end

    describe "#options_for_tinymce" do
      it "returns string options as normal" do
        config = Configuration.load("mode" => "textareas")
        config.options_for_tinymce["mode"].should eq("textareas")
      end

      it "combines arrays of strings into a single comma-separated string" do
        config = Configuration.load("plugins" => %w(paste table fullscreen))
        config.options_for_tinymce["plugins"].should eq("paste,table,fullscreen")
      end

      it "works with integer values" do
        config = Configuration.load("width" => 123)
        config.options_for_tinymce["width"].should eq(123)
      end

      it "converts javascript function strings to Function objects" do
        config = Configuration.load("oninit" => "function() {}")
        config.options_for_tinymce["oninit"].should be_a(SingleConfiguration::Function)
      end

      it "returns the language based on the current locale" do
        I18n.locale = "pirate"

        config = Configuration.load({})
        config.options_for_tinymce["language"].should eq("pirate")
      end

      it "falls back to English if the current locale is not available" do
        I18n.locale = "missing"

        config = Configuration.load({})
        config.options_for_tinymce["language"].should eq("en")
      end

      it "does not override the language if already provided" do
        config = Configuration.load("language" => "es")
        config.options_for_tinymce["language"].should eq("es")
      end
    end

    describe "#merge" do
      subject { Configuration.load("mode" => "textareas") }

      it "merges given options with configuration options" do
        result = subject.merge("theme" => "super_advanced")
        result.options.should eq(
          "mode" => "textareas",
          "editor_selector" => "tinymce",
          "theme" => "super_advanced"
        )
      end

      it "does not alter the original configuration object" do
        subject.merge("theme" => "super_advanced")
        subject.options["theme"].should_not == "super_advance"
      end
    end
  end
end
