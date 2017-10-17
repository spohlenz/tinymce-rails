module TinyMCE
  module Rails
    class AssetInstaller
      class Compile
        delegate :target, :manifest, :logger, :logical_path, :with_asset, :to => :@installer

        def initialize(installer)
          @installer = installer
        end

        def call
          symlink_assets
        end

      private
        def symlink_assets
          manifest.each(/^tinymce\//) do |asset|
            manifest.asset_path(asset) do |src, dest|
              symlink_asset(src, dest)
            end
          end
        end

        def symlink_asset(src, dest)
          with_asset(src, dest) do |src, dest|
            create_symlink(src, dest)
            create_symlink("#{src}.gz", "#{dest}.gz") if File.exists?("#{src}.gz")
          end
        end

        def create_symlink(src, dest)
          target = File.basename(src)

          unless File.exists?(dest) && File.symlink?(dest) && File.readlink(dest) == target
            logger.info "Creating symlink #{dest}"
            FileUtils.ln_s(target, dest, :force => true)
          else
            logger.debug "Skipping symlink #{dest}, already exists"
          end
        end
      end
    end
  end
end
