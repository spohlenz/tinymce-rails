module TinyMCE
  module Rails
    class NewPropshaftManifest < AssetManifest
      def self.try(manifest_path)
        return unless defined?(Propshaft::Manifest)
        json_file = File.join(manifest_path, ".manifest.json")
        new(json_file) if File.exist?(json_file)
      end

      def initialize(file)
        @file = file
        @manifest = Propshaft::Manifest.from_path(Pathname.new(file))
      end

      def append(logical_path, file)
        entry = Propshaft::Manifest::ManifestEntry.new(
          logical_path: logical_path,
          digested_path: logical_path,
          integrity: nil
        )
        @manifest.push(entry)
      end

      def remove(logical_path)
        @manifest.delete(logical_path)
      end

      def remove_digest(logical_path)
        asset_path(logical_path) do |digested, logical_path|
          append(logical_path, nil)

          yield digested, logical_path if block_given?
        end
      end

      def assets
        @manifest.transform_values(&:digested_path)
      end

      def dump
        @manifest.to_json
      end

      def write
        File.open(@file, "wb") { |f| f.write(dump) }
      end
    end
  end
end
