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
      
      def remove(file)
        @manifest.delete(file)
      end
      
      def remove_digest(file)
        if digested = @manifest[file]
          @manifest[file] = file
          yield digested, file if block_given?
        end
      end
      
      def each(pattern)
        @manifest.each_key do |asset|
          yield asset if asset =~ pattern
        end
      end
      
      def to_s
        dump
      end
      
      def dump(io=nil)
        YAML.dump(@manifest, io)
      end
      
      def write
        File.open(@manifest_file, "wb") { |f| dump(f) }
      end
    end
  end
end
