require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    class AssetInstaller
      def initialize(assets, target, manifest_path)
        @assets = assets.is_a?(Array) ? assets : [assets]

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
        @assets.each do |asset|
          FileUtils.cp_r(asset, @target, :preserve => true)
        end
      end

      def append_to_manifest
        @assets.each do |asset|
          asset_files(asset).each do |file|
            manifest.append(logical_path(asset, file), file)
          end
        end
      end

      def asset_files(asset)
        Pathname.glob("#{asset}/**/*").select(&:file?)
      end

      def logical_path(asset, file)
        file.relative_path_from(asset.parent).to_s
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
