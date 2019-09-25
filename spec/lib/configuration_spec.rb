require 'spec_helper'

module TinyMCE::Rails
  describe Configuration do
    it "has default options" do
      expect(Configuration.defaults).to eq("selector" => "textarea.tinymce", "cache_suffix" => "?v=#{VERSION}")
    end

    it "is instantiable with an options hash" do
      options = { "option" => "value" }
      config = Configuration.new(options)
      expect(config.options).to eq(options)
    end

    describe "#options_for_tinymce" do
      it "returns string options as normal" do
        config = Configuration.new("mode" => "textareas")
        expect(config.options_for_tinymce["mode"]).to eq("textareas")
      end

      it "returns arrays without predefined separators as normal" do
        config = Configuration.new("toolbar" => ["styleselect", "bold italic"])
        expect(config.options_for_tinymce["toolbar"]).to eq(["styleselect", "bold italic"])
      end

      it "combines arrays of plugins into a single comma-separated string" do
        config = Configuration.new("plugins" => %w(paste table fullscreen))
        expect(config.options_for_tinymce["plugins"]).to eq("paste,table,fullscreen")
      end

      it "returns string of plugins as normal" do
        config = Configuration.new("plugins" => "paste,table,fullscreen")
        expect(config.options_for_tinymce["plugins"]).to eq("paste,table,fullscreen")
      end

      it "combines arrays of font_formats into a single semicolon-separated string" do
        config = Configuration.new("font_formats" => ["Andale Mono=andale mono,times", "Comic Sans MS=comic sans ms,sans-serif"])
        expect(config.options_for_tinymce["font_formats"]).to eq("Andale Mono=andale mono,times;Comic Sans MS=comic sans ms,sans-serif")
      end

      it "works with integer values" do
        config = Configuration.new("width" => 123)
        expect(config.options_for_tinymce["width"]).to eq(123)
      end

      it "converts javascript function strings to Function objects" do
        config = Configuration.new("oninit" => "function() {}", "setup" => "function (editor) {}")
        expect(config.options_for_tinymce["oninit"]).to be_a(Configuration::Function)
        expect(config.options_for_tinymce["setup"]).to be_a(Configuration::Function)
      end

      it "converts javascript function strings to Function objects within nested hash" do
        config = Configuration.new("nested" => { "oninit" => "function() {}", "setup" => "function (editor) {}" })
        expect(config.options_for_tinymce["nested"]["oninit"]).to be_a(Configuration::Function)
        expect(config.options_for_tinymce["nested"]["setup"]).to be_a(Configuration::Function)
      end

      describe "content_css option" do
        it "does not convert relative content_css values to asset paths" do
          config = Configuration.new("content_css" => "./relative_styles.css")
          expect(config.options_for_tinymce["content_css"]).to eq("./relative_styles.css")
        end

        it "does not convert relative content_css values to asset paths (when passed as comma-separated string)" do
          config = Configuration.new("content_css" => "/layout.css,./custom1.css,../custom2.css")
          expect(config.options_for_tinymce["content_css"]).to eq("/layout.css,./custom1.css,../custom2.css")
        end

        it "does not convert relative content_css values to asset paths (when passed as array)" do
          config = Configuration.new("content_css" => ["/layout.css", "./custom1.css", "../custom2.css"])
          expect(config.options_for_tinymce["content_css"]).to eq("/layout.css,./custom1.css,../custom2.css")
        end

        it "converts content_css values to asset paths (when passed as comma-separated string)" do
          config = Configuration.new("content_css" => "editor1.css, editor2.css")
          expect(config.options_for_tinymce["content_css"]).to eq("/assets/editor1.css,/assets/editor2.css")
        end

        it "converts content_css values to asset paths (when passed as array)" do
          config = Configuration.new("content_css" => ["editor1.css", "editor2.css"])
          expect(config.options_for_tinymce["content_css"]).to eq("/assets/editor1.css,/assets/editor2.css")
        end
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
