module TinyMCE
  module Rails
    class AssetManifest
      class NoManifest < StandardError; end
      
      def initialize(manifest_path)
        @manifest_file = File.join(manifest_path, "manifest.yml")
        raise NoManifest unless File.exists?(@manifest_file)
        @manifest = YAML.load_file(@manifest_file)
      end
      
      def append(file)
        @manifest[file] = file
      end
      
      def write
        File.open(@manifest_file, "wb") do |f|
          YAML.dump(@manifest, f)
        end
      end
    end
  end
end
