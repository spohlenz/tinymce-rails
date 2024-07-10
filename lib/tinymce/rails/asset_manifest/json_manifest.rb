module TinyMCE
  module Rails
    class JsonManifest < AssetManifest
      def self.try(manifest_path, pattern=nil)
        if pattern
          paths = Dir[File.join(manifest_path, pattern)]
          new(paths.first) if paths.any?
        elsif File.file?(manifest_path)
          new(manifest_path)
        end
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
  end
end
