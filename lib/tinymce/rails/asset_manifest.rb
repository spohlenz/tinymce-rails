module TinyMCE
  module Rails
    class AssetManifest
      attr_reader :file

      def self.load(manifest_path)
        JsonManifest.try(manifest_path, ".sprockets-manifest*.json") ||
          JsonManifest.try(manifest_path, "manifest*.json") ||
          YamlManifest.try(manifest_path) ||
          NullManifest.new
      end

      def each(pattern)
        assets.each_key do |asset|
          if asset =~ pattern && !index_asset?(asset)
            yield asset
          end
        end
      end

      def asset_path(logical_path)
        if digested = assets[logical_path]
          yield digested, logical_path if block_given?
        end
      end

      def to_s
        dump
      end

    protected
      def index_asset?(asset)
        asset =~ /\/index[^\/]*\.\w+$/
      end
    end

    class YamlManifest < AssetManifest
      def self.try(manifest_path)
        yaml_file = File.join(manifest_path, "manifest.yml")
        new(yaml_file) if File.exists?(yaml_file)
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

    class JsonManifest < AssetManifest
      def self.try(manifest_path, pattern)
        paths = Dir[File.join(manifest_path, pattern)]
        new(paths.first) if paths.any?
      end

      def initialize(file)
        @file = file
        @manifest = JSON.parse(File.read(file))
      end

      def append(logical_path, file)
        stat = File.stat(file)

        assets[logical_path] = logical_path
        files[logical_path] = {
          "logical_path" => logical_path,
          "mtime"        => stat.mtime.iso8601,
          "size"         => stat.size,
          "digest"       => nil
        }
      end

      def remove(logical_path)
        if digested = assets.delete(logical_path)
          files.delete(digested)
        end
      end

      def remove_digest(logical_path)
        asset_path(logical_path) do |digested, logical_path|
          assets[logical_path] = logical_path
          files[logical_path] = files.delete(digested).tap { |f| f["digest"] = nil }

          yield digested, logical_path if block_given?
        end
      end

      def assets
        @manifest["assets"]
      end

      def files
        @manifest["files"]
      end

      def dump
        JSON.generate(@manifest)
      end

      def write
        File.open(@file, "wb") { |f| f.write(dump) }
      end
    end

    class NullManifest < AssetManifest
      def append(*); end
      def remove(*); end
      def remove_digest(*); end
      def assets; {}; end
      def each(*); end
      def write; end
    end
  end
end
