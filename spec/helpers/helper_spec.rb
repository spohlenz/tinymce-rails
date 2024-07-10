require 'spec_helper'

module TinyMCE::Rails
  describe Helper do
    if defined?(Sprockets)
      include Sprockets::Rails::Helper

      app, config = Rails.application, Rails.application.config

      self.debug_assets      = config.assets.debug
      self.digest_assets     = config.assets.digest
      self.assets_prefix     = config.assets.prefix
      self.assets_precompile = config.assets.precompile

      self.assets_environment = app.assets
      self.assets_manifest    = app.assets_manifest

      self.resolve_assets_with = [:environment] if respond_to?(:resolve_assets_with=)
    elsif defined?(Propshaft)
      include Propshaft::Helper
    end

    let(:content_security_policy_nonce) { "nonce" }

    describe "#tinymce_assets" do
      context "using Sprockets", if: defined?(Sprockets) do
        it "returns a bundled TinyMCE javascript tag" do
          script = tinymce_assets
          expect(script).to have_selector("script[src='#{asset_path("tinymce.js")}'][data-turbolinks-track='reload']", visible: false)
        end

        it "allows custom attributes to be set on the script tag" do
          script = tinymce_assets(defer: true, data: { turbo_track: "reload" })
          expect(script).to have_selector("script[src='#{asset_path("tinymce.js")}'][defer][data-turbo-track='reload']", visible: false)
        end
      end

      context "using Propshaft", if: defined?(Propshaft) do
        it "returns TinyMCE preinit code and separate javascript asset tags" do
          result = tinymce_assets
          expect(result).to include(tinymce_preinit)
          expect(result).to have_selector("script[src='#{asset_path("tinymce/tinymce.js")}'][data-turbolinks-track='reload']", visible: false)
          expect(result).to have_selector("script[src='#{asset_path("tinymce/rails.js")}'][data-turbolinks-track='reload']", visible: false)
        end

        it "allows custom attributes to be set on the script tags" do
          result = tinymce_assets(defer: true, data: { turbo_track: "reload" })
          expect(result).to include(tinymce_preinit)
          expect(result).to have_selector("script[src='#{asset_path("tinymce/tinymce.js")}'][defer][data-turbo-track='reload']", visible: false)
          expect(result).to have_selector("script[src='#{asset_path("tinymce/rails.js")}'][defer][data-turbo-track='reload']", visible: false)
        end
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
          expect(result).to have_selector("script", visible: false)
          expect(result).to include('TinyMCERails.configuration.default = {')
          expect(result).to include('theme: "advanced"')
          expect(result).to include('plugins: "paste,table,fullscreen"')
          expect(result).to include('};')
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

        it "outputs nested function strings without quotes" do
          result = tinymce(:nested => { :oninit => "function() { alert('Hello'); }" })
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
      end
    end

    describe "#tinymce_preinit" do
      it "returns TinyMCE preinit script" do
        result = tinymce_preinit
        expect(result).to have_selector("script", visible: false)
        expect(result).to include("window.tinymce = window.tinymce || { base: '/assets/tinymce', suffix: '' };")
      end
    end
  end
end
