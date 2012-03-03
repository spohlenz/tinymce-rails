require 'spec_helper'

module TinyMCE
  describe Rails do
    describe ".configuration" do
      let(:configuration_file) { ::Rails.root.join("config/tinymce.yml") }
      let(:configuration) { stub }
      
      it "loads the tinymce.yml config file" do
        TinyMCE::Rails::Configuration.should_receive(:load).with(configuration_file).and_return(configuration)
        TinyMCE::Rails.configuration.should eq(configuration)
      end
    end
  end
end
