require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    describe AssetManifest do
      def fixture(directory)
        File.expand_path("../fixtures/#{directory}", File.dirname(__FILE__))
      end
      
      def reload_manifest(manifest)
        YAML.load(manifest.to_s)
      end
      
      it "raises an exception if it can't find a manifest" do
        expect { AssetManifest.new(fixture("no_manifest")) }.to raise_error(AssetManifest::NoManifest)
      end
      
      it "keeps existing manifest data" do
        manifest = AssetManifest.new(fixture("yaml_manifest"))
        
        result = reload_manifest(manifest)
        result["application.js"].should == "application-025f3a2beeeb18ce2b5f2dafdb14eb86.js"
      end
      
      describe "#append" do
        it "adds files to the manifest without a fingerprint" do
          manifest = AssetManifest.new(fixture("yaml_manifest"))
          manifest.append("tinymce.js")
          
          result = reload_manifest(manifest)
          result["tinymce.js"].should == "tinymce.js"
        end
      end
    end
  end
end
