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

      context "single-configuration" do
        let(:configuration) {
          Configuration.new("theme" => "advanced", "plugins" => %w(paste table fullscreen))
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

        it "initializes TinyMCE with passed options and config" do
          result = tinymce(:simple, :editor_selector => "selector")
          result.should include '"editor_selector":"selector"'
        end

        it "outputs function strings without quotes" do
          result = tinymce(:oninit => "function() { alert('Hello'); }")
          result.should include('"oninit":function() { alert(\'Hello\'); }')
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
          result.should include('"theme":"advanced"')
          result.should include('"plugins":"paste,table"')
        end

        it "merges passed in options with default configuration" do
          result = tinymce(:theme => "simple")
          result.should include('"theme":"simple"')
          result.should include('"plugins":"paste,table"')
        end

        it "initializes TinyMCE with custom configuration" do
          result = tinymce(:alternate)
          result.should include('"skin":"alternate"')
        end

        it "merges passed in options with custom configuration" do
          result = tinymce(:alternate, :theme => "simple")
          result.should include('"theme":"simple"')
          result.should include('"skin":"alternate"')
        end

        it "raises an error when given an invalid configuration" do
          expect { tinymce(:missing) }.to raise_error(KeyError)
        end
      end
    end

    describe "prepare_options_for_all_ruby_versions" do
      let(:options) {
        {:key => "value"}
      }
      let(:modified_options) {
        {"key" => "value"}
      }
      specify { prepare_options_for_all_ruby_versions(options).should == modified_options }

      specify { prepare_options_for_all_ruby_versions(modified_options).should == modified_options }
    end
  end
end
