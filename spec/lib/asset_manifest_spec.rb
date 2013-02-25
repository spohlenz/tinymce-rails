require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    describe AssetManifest do
      subject(:manifest) { AssetManifest.load(fixture("yaml_manifest")) }
      
      def fixture(directory)
        File.expand_path("../fixtures/#{directory}", File.dirname(__FILE__))
      end
      
      def reload_manifest(manifest)
        YAML.load(manifest.to_s)
      end
      
      describe ".load" do
        it "returns a NullManifest if it can't find a manifest" do
          manifest = AssetManifest.load(fixture("no_manifest"))
          manifest.should be_an_instance_of(AssetManifest::NullManifest)
        end
      end
      
      describe AssetManifest::NullManifest do
        subject { AssetManifest::NullManifest.new }
        
        it { should respond_to(:append) }
        it { should respond_to(:remove) }
        it { should respond_to(:remove_digest) }
        it { should respond_to(:each) }
        it { should respond_to(:write) }
      end
      
      it "keeps existing manifest data" do
        result = reload_manifest(manifest)
        result["application.js"].should == "application-d41d8cd98f00b204e9800998ecf8427e.js"
      end
      
      describe "#append" do
        it "adds files to the manifest without a fingerprint" do
          manifest.append("tinymce/tiny_mce_jquery.js")
          
          result = reload_manifest(manifest)
          result["tinymce/tiny_mce_jquery.js"].should == "tinymce/tiny_mce_jquery.js"
        end
      end
      
      describe "#remove" do
        it "removes files from the manifest" do
          manifest.remove("tinymce.js")
          
          result = reload_manifest(manifest)
          result.should_not have_key("tinymce.js")
        end
      end
      
      describe "#remove_digest" do
        it "sets the file digest value to its non-digested version" do
          manifest.remove_digest("tinymce.js")
          
          result = reload_manifest(manifest)
          result["tinymce.js"].should == "tinymce.js"
        end
        
        it "yields the digested and non-digested file names" do
          expect { |block|
            manifest.remove_digest("tinymce.js", &block)
          }.to yield_with_args("tinymce-025f3a2beeeb18ce2b5f2dafdb14eb86.js", "tinymce.js")
        end
      end
      
      describe "#each" do
        it "yields the logical path for each asset that matches the given pattern" do
          result = []
          manifest.each(/^tinymce\//) { |asset| result << asset }
          result.should == ["tinymce/tiny_mce.js"]
        end
      end
    end
  end
end
