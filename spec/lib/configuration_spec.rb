require 'spec_helper'

module TinyMCE::Rails
  describe Configuration do
    it "has default options" do
      expect(Configuration.defaults).to eq("selector" => "textarea.tinymce")
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
        config = Configuration.new("oninit" => "function() {}")
        expect(config.options_for_tinymce["oninit"]).to be_a(Configuration::Function)
      end

      it "does not convert relative content_css values to asset paths" do
        config = Configuration.new("content_css" => "./relative_styles.css")
        expect(ActionController::Base.helpers).to_not receive(:stylesheet_path)
        expect(config.options_for_tinymce["content_css"]).to eq("./relative_styles.css")
      end

      it "does not convert relative content_css values to asset paths (when passed as comma-separated string)" do
        config = Configuration.new("content_css" => "/layout.css,./custom1.css,../custom2.css")
        expect(ActionController::Base.helpers).to_not receive(:stylesheet_path)
        expect(config.options_for_tinymce["content_css"]).to eq("/layout.css,./custom1.css,../custom2.css")
      end

      it "does not convert relative content_css values to asset paths (when passed as array)" do
        config = Configuration.new("content_css" => ["/layout.css", "./custom1.css", "../custom2.css"])
        expect(ActionController::Base.helpers).to_not receive(:stylesheet_path)
        expect(config.options_for_tinymce["content_css"]).to eq("/layout.css,./custom1.css,../custom2.css")
      end

      it "converts content_css values to asset paths (when passed as comma-separated string)" do
        config = Configuration.new("content_css" => "editor1.css, editor2.css,missing.css")
        expect(ActionController::Base.helpers).to receive(:stylesheet_path).with("editor1.css").and_return("/assets/editor1-1234.css")
        expect(ActionController::Base.helpers).to receive(:stylesheet_path).with("editor2.css").and_return("/assets/editor2-1234.css")
        expect(ActionController::Base.helpers).to receive(:stylesheet_path).with("missing.css").and_return(nil)
        expect(config.options_for_tinymce["content_css"]).to eq("/assets/editor1-1234.css,/assets/editor2-1234.css,missing.css")
      end

      it "converts content_css values to asset paths (when passed as array)" do
        config = Configuration.new("content_css" => ["editor1.css", "editor2.css", "missing.css"])
        expect(ActionController::Base.helpers).to receive(:stylesheet_path).with("editor1.css").and_return("/assets/editor1-1234.css")
        expect(ActionController::Base.helpers).to receive(:stylesheet_path).with("editor2.css").and_return("/assets/editor2-1234.css")
        expect(ActionController::Base.helpers).to receive(:stylesheet_path).with("missing.css").and_return(nil)
        expect(config.options_for_tinymce["content_css"]).to eq("/assets/editor1-1234.css,/assets/editor2-1234.css,missing.css")
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
