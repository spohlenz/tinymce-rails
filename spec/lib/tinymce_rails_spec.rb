require 'spec_helper'

module TinyMCE
  describe Rails do
    describe ".configuration" do
      let(:path) { ::Rails.root.join("config/tinymce.yml") }
      
      let(:configuration_file) { double(:configuration => configuration) }
      let(:configuration) { double }
      
      it "loads the tinymce.yml config file" do
        TinyMCE::Rails::ConfigurationFile.should_receive(:new).with(path).and_return(configuration_file)
        TinyMCE::Rails.configuration.should eq(configuration)
      end
    end
  end
end
