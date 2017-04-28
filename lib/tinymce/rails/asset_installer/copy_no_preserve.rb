require "tinymce/rails/asset_installer/copy"

module TinyMCE
  module Rails
    class AssetInstaller
      class CopyNoPreserve < Copy
        def copy_assets
          logger.info "Copying assets (without preserving modes) to #{File.join(target, "tinymce")}"
          FileUtils.cp_r(assets, target)
        end
      end
    end
  end
end
