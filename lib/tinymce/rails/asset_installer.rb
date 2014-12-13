require "tinymce/rails/asset_manifest"

module TinyMCE
  module Rails
    class AssetInstaller
      attr_accessor :logger
      
      def initialize(assets, target, manifest_path)
        @assets = assets
        @target = target
        @manifest_path = manifest_path || target
        
        @logger       = Logger.new($stderr)
        @logger.level = Logger::INFO
      end
      
      def install
        cleanup_assets
        copy_assets
        append_to_manifest
        
        manifest.write
      end
      
      def symlink
        manifest.each(/^tinymce\//) do |asset|
          manifest.remove_digest(asset) do |src, dest|
            symlink_asset(src, dest)
          end
        end
      end
      
      def log_level
        @logger.level
      end

      def log_level=(level)
        if level.is_a?(Integer)
          @logger.level = level
        else
          @logger.level = Logger.const_get(level.to_s.upcase)
        end
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
        with_asset(src, dest) do |src, dest|
          logger.info "Removing digest from #{src}"
          FileUtils.mv(src, dest, :force => true)
        end
      end
      
      def symlink_asset(src, dest)
        with_asset(src, dest) do |src, dest|
          unless File.exists?(dest) && File.symlink?(dest) && File.readlink(dest) == src
            logger.info "Creating symlink #{dest}"
            FileUtils.ln_s(File.basename(src), dest, :force => true)
          else
            logger.debug "Skipping symlink #{dest}, already exists"
          end
        end
      end
      
      def with_asset(src, dest)
        if src != dest
          src = File.join(@target, src)
          dest = File.join(@target, dest)
          
          yield src, dest if File.exists?(src)
        end
      end
      
      def index_asset?(asset)
        asset =~ /\/index\.js$/
      end
    end
  end
end
