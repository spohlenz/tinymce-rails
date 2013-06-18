require "tinymce/rails/asset_installer"

module TinyMCE
  module Rails
    describe AssetInstaller do
      before(:each) do
        FileUtils.stub(:cp_r)
        FileUtils.stub(:mv)
        
        stub_const("TinyMCE::Rails::AssetManifest", stub(:load => manifest))
      end
      
      let(:assets) { Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../../vendor/assets/javascripts/tinymce")) }
      let(:target) { "/assets" }
      let(:manifest_path) { nil }
      let(:manifest) { stub.as_null_object }
      
      def install
        AssetInstaller.new(assets, target, manifest_path).install
      end
      
      it "removes TinyMCE index assets" do
        asset = "tinymce/langs/es/index.js"
        
        manifest.stub(:each).and_yield(asset)
        manifest.should_receive(:remove).with(asset)
        
        install
      end
      
      it "removes digests from existing TinyMCE assets in the manifest" do
        digested_asset = "tinymce/langs/es-abcde1234567890.js"
        asset = "tinymce/langs/es.js"
        
        manifest.stub(:each).and_yield(asset)
        manifest.should_receive(:remove_digest).with(asset).and_yield(digested_asset, asset)
        File.stub(:exists?).and_return(true)
        FileUtils.should_receive(:mv).with("/assets/tinymce/langs/es-abcde1234567890.js", "/assets/tinymce/langs/es.js", :force => true)
        
        install
      end
      
      it "copies TinyMCE assets to the target directory" do
        FileUtils.should_receive(:cp_r).with(assets, target, :preserve => true)
        install
      end
      
      it "adds TinyMCE assets to the manifest" do
        manifest.should_receive(:append).with("tinymce/tiny_mce.js", assets.parent.join("tinymce/tiny_mce.js"))
        manifest.should_receive(:append).with("tinymce/themes/advanced/editor_template.js", assets.parent.join("tinymce/themes/advanced/editor_template.js"))
        install
      end
      
      it "writes the manifest" do
        manifest.should_receive(:write)
        install
      end
    end
  end
end
