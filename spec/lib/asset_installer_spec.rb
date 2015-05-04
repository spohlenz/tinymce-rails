require "tinymce/rails/asset_installer"

module TinyMCE
  module Rails
    describe AssetInstaller do
      let(:assets) { Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../../vendor/assets/javascripts/tinymce")) }
      let(:target) { "/assets" }
      let(:manifest_path) { nil }
      let(:manifest) { double.as_null_object }

      let(:installer) do
        AssetInstaller.new(assets, target, manifest_path).tap do |installer|
          installer.strategy = strategy
          installer.log_level = :warn
        end
      end

      def install
        installer.install
      end

      before(:each) do
        stub_const("TinyMCE::Rails::AssetManifest", double(:load => manifest))
      end

      describe "compile strategy" do
        let(:strategy) { :compile }

        before(:each) do
          allow(FileUtils).to receive(:ln_s)
        end

        it "symlinks non-digested asset paths" do
          digested_asset = "tinymce/langs/es-abcde1234567890.js"
          asset = "tinymce/langs/es.js"

          allow(manifest).to receive(:each).and_yield(asset)
          expect(manifest).to receive(:asset_path).with(asset).and_yield(digested_asset, asset)

          allow(File).to receive(:exists?).and_return(true)

          expect(FileUtils).to receive(:ln_s).with("es-abcde1234567890.js", "/assets/tinymce/langs/es.js", :force => true)

          install
        end
      end

      describe "copy strategy" do
        let(:strategy) { :copy }

        before(:each) do
          allow(FileUtils).to receive(:cp_r)
          allow(FileUtils).to receive(:mv)
        end
        
        it "removes digests from existing TinyMCE assets in the manifest" do
          digested_asset = "tinymce/langs/es-abcde1234567890.js"
          asset = "tinymce/langs/es.js"
          
          allow(manifest).to receive(:each).and_yield(asset)
          expect(manifest).to receive(:remove_digest).with(asset).and_yield(digested_asset, asset)
          allow(File).to receive(:exists?).and_return(true)
          expect(FileUtils).to receive(:mv).with("/assets/tinymce/langs/es-abcde1234567890.js", "/assets/tinymce/langs/es.js", :force => true)
          
          install
        end
        
        it "copies TinyMCE assets to the target directory" do
          expect(FileUtils).to receive(:cp_r).with(assets, target, :preserve => true)
          install
        end
        
        it "adds TinyMCE assets to the manifest" do
          expect(manifest).to receive(:append).with("tinymce/tinymce.js", assets.parent.join("tinymce/tinymce.js"))
          expect(manifest).to receive(:append).with("tinymce/themes/modern/theme.js", assets.parent.join("tinymce/themes/modern/theme.js"))
          install
        end
        
        it "writes the manifest" do
          expect(manifest).to receive(:write)
          install
        end
      end
    end
  end
end
