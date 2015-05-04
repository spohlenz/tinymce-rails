require 'spec_helper'

module TinyMCE
  describe Rails do
    describe ".configuration" do
      let(:path) { ::Rails.root.join("config/tinymce.yml") }
      
      let(:configuration_file) { double(:configuration => configuration) }
      let(:configuration) { double }
      
      it "loads the tinymce.yml config file" do
        expect(TinyMCE::Rails::ConfigurationFile).to receive(:new).with(path).and_return(configuration_file)
        expect(TinyMCE::Rails.configuration).to eq(configuration)
      end
    end
  end
end
