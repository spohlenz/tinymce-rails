require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    class AssetInstaller
      ASSETS = Pathname.new(File.expand_path(File.dirname(__FILE__) + "/../../../vendor/assets/javascripts/tinymce"))
      
      def initialize(target, manifest_path)
        @target = target
        @manifest_path = manifest_path || target
      end
      
      def install
        copy_assets
        append_to_manifest
        manifest.write
      end
    
    private
      def manifest
        @manifest ||= AssetManifest.load(@manifest_path)
      end
      
      def copy_assets
        FileUtils.cp_r(ASSETS, @target, :preserve => true)
      end
      
      def append_to_manifest
        asset_files.each do |file|
          relative_path = file.relative_path_from(ASSETS.parent).to_s
          manifest.append(relative_path)
        end
      end
      
      def asset_files
        Pathname.glob("#{ASSETS}/**/*").select(&:file?)
      end
    end
  end
end
