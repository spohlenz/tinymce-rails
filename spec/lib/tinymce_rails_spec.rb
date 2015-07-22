require 'spec_helper'

module TinyMCE
  describe Rails do
    describe ".configuration" do
      after(:each) do
        TinyMCE::Rails.configuration = nil
        ::Rails.application.config.tinymce.config_path = nil
      end

      let(:configuration_file) { double(:configuration => configuration) }
      let(:configuration) { double }
      
      it "loads the tinymce.yml config file" do
        path = ::Rails.root.join("config/tinymce.yml")
        expect(TinyMCE::Rails::ConfigurationFile).to receive(:new).with(path).and_return(configuration_file)
        expect(TinyMCE::Rails.configuration).to eq(configuration)
      end

      it "loads a custom config file if config.tinymce.config is set" do
        path = ::Rails.root.join("config/tinymce-custom.yml")
        ::Rails.application.config.tinymce.config_path = path

        expect(TinyMCE::Rails::ConfigurationFile).to receive(:new).with(path).and_return(configuration_file)
        expect(TinyMCE::Rails.configuration).to eq(configuration)
      end
    end
  end
end
