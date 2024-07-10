module TinyMCE
  module Rails
    class PropshaftManifest < AssetManifest
      def self.try(manifest_path)
        json_file = File.join(manifest_path, ".manifest.json")
        new(json_file) if File.exist?(json_file)
      end

      def initialize(file)
        @file = file
        @manifest = JSON.parse(File.read(file))
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

      def dump
        JSON.generate(@manifest)
      end

      def write
        File.open(@file, "wb") { |f| f.write(dump) }
      end
    end
  end
end
