module TinyMCE
  module Rails
    class AssetInstaller
      class Copy
        delegate :assets, :target, :manifest, :logger, :logical_path, :with_asset, :to => :@installer
        
        def initialize(installer)
          @installer = installer
        end
        
        def call
          cleanup_assets
          copy_assets
          append_to_manifest
        
          manifest.write
        end
      
      private
        def cleanup_assets
          manifest.each(/^tinymce\//) do |asset|
            manifest.remove(asset) if index_asset?(asset)
          
            manifest.remove_digest(asset) do |src, dest|
              move_asset(src, dest)
            end
          end
        end
        
        def copy_assets
          FileUtils.cp_r(assets, target, :preserve => true)
        end
        
        def append_to_manifest
          asset_files.each do |file|
            manifest.append(logical_path(file), file)
          end
        end
        
        def move_asset(src, dest)
          with_asset(src, dest) do |src, dest|
            logger.info "Removing digest from #{src}"
            FileUtils.mv(src, dest, :force => true)
          end
        end
      
        def asset_files
          Pathname.glob("#{assets}/**/*").select(&:file?)
        end
        
        def index_asset?(asset)
          asset =~ /\/index\.js$/
        end
      end
    end
  end
end
