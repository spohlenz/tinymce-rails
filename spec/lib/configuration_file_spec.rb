require 'spec_helper'

module TinyMCE::Rails
  describe ConfigurationFile do
    it "loads single-configuration YAML files" do
      file = File.expand_path("../fixtures/single.yml", File.dirname(__FILE__))
      config = ConfigurationFile.new(file).configuration
      config.should be_an_instance_of(Configuration)
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
    
    it "loads multiple-configuration YAML files" do
      file = File.expand_path("../fixtures/multiple.yml", File.dirname(__FILE__))
      config = ConfigurationFile.new(file).configuration
      
      config.should be_an_instance_of(MultipleConfiguration)
      config[:default].should be_an_instance_of(Configuration)
      config[:alternate].should be_an_instance_of(Configuration)
      
      config[:default].options.should eq(Configuration.defaults)
      config[:alternate].options.should eq(
        "mode" => "specific_textareas",
        "theme" => "advanced",
        "editor_selector" => "tinymce",
        "skin" => "alternate"
      )
    end
    
    it "uses default configuration when loading a nonexistant file" do
      config = ConfigurationFile.new("missing.yml").configuration
      config.options.should eq(Configuration.defaults)
    end
    
    describe "#changed?" do
      let(:path) { File.expand_path("../fixtures/single.yml", File.dirname(__FILE__)) }
      let(:file) { ConfigurationFile.new(path) }
      
      # Preload configuration
      before(:each) { file.configuration }
      
      it "returns true if the file has been modified (different mtime)" do
        File.stub!(:mtime).and_return(Time.now)
        file.should be_changed
      end
      
      it "returns true if the file no longer exists" do
        File.stub!(:exists?).and_return(false)
        file.should be_changed
      end
      
      it "returns false if the file has not been modified" do
        file.should_not be_changed
      end
      
      context "when the file does not originally exist" do
        let(:path) { "missing.yml" }
        
        it "returns false if a missing file is still missing" do
          file.should_not be_changed
        end
      end
    end
  end
end
