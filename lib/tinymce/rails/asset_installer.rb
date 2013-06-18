require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    class AssetInstaller
      def initialize(assets, target, manifest_path)
        @assets = assets
        @target = target
        @manifest_path = manifest_path || target
      end
      
      def install
        cleanup_assets
        copy_assets
        append_to_manifest
        
        manifest.write
      end
    
    private
      def manifest
        @manifest ||= AssetManifest.load(@manifest_path)
      end
      
      def cleanup_assets
        manifest.each(/^tinymce\//) do |asset|
          manifest.remove(asset) if index_asset?(asset)
          
          manifest.remove_digest(asset) do |src, dest|
            move_asset(src, dest)
          end
        end
      end
      
      def copy_assets
        FileUtils.cp_r(@assets, @target, :preserve => true)
      end
      
      def append_to_manifest
        asset_files.each do |file|
          manifest.append(logical_path(file), file)
        end
      end
      
      def asset_files
        Pathname.glob("#{@assets}/**/*").select(&:file?)
      end
      
      def logical_path(file)
        file.relative_path_from(@assets.parent).to_s
      end
      
      def move_asset(src, dest)
        src = File.join(@target, src)
        dest = File.join(@target, dest)
        
        FileUtils.mv(src, dest, :force => true) if src != dest && File.exists?(src)
      end
      
      def index_asset?(asset)
        asset =~ /\/index\.js$/
      end
    end
  end
end
