require "tinymce/rails/asset_manifest"

require "tinymce/rails/asset_installer/copy"
require "tinymce/rails/asset_installer/symlink"

module TinyMCE
  module Rails
    class AssetInstaller
      attr_reader :assets, :target
      attr_accessor :logger, :strategy
      
      def initialize(assets, target, manifest_path)
        @assets = assets
        @target = target
        @manifest_path = manifest_path || target
        
        @logger       = Logger.new($stderr)
        @logger.level = Logger::INFO
      end
      
      def install
        (strategy || Copy).new(self).call
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
      
      def manifest
        @manifest ||= AssetManifest.load(@manifest_path)
      end
    
      def logical_path(file)
        file.relative_path_from(@assets.parent).to_s
      end
      
      def with_asset(src, dest)
        if src != dest
          src = File.join(@target, src)
          dest = File.join(@target, dest)
          
          yield src, dest if File.exists?(src)
        end
      end
    end
  end
end
