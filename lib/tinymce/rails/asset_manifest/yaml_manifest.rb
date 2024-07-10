module TinyMCE
  module Rails
    class YamlManifest < AssetManifest
      def self.try(manifest_path)
        yaml_file = File.join(manifest_path, "manifest.yml")
        new(yaml_file) if File.exist?(yaml_file)
      end

      def initialize(file)
        @file = file
        @manifest = YAML.load_file(file)
      end

      def append(logical_path, file)
        assets[logical_path] = logical_path
      end

      def remove(logical_path)
        assets.delete(logical_path)
      end

      def remove_digest(logical_path)
        asset_path(logical_path) do |digested, logical_path|
          assets[logical_path] = logical_path

          yield digested, logical_path if block_given?
        end
      end

      def assets
        @manifest
      end

      def dump(io=nil)
        YAML.dump(@manifest, io)
      end

      def write
        File.open(@file, "wb") { |f| dump(f) }
      end
    end
  end
end
