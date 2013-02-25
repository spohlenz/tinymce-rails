module TinyMCE
  module Rails
    class AssetManifest
      class NullManifest
        def append(*); end
        def remove(*); end
        def remove_digest(*); end
        def each(*); end
        def write; end
      end
      
      def initialize(file)
        @file = file
        @manifest = YAML.load_file(file)
      end
      
      def self.load(manifest_path)
        yaml_file = File.join(manifest_path, "manifest.yml")
        
        if File.exists?(yaml_file)
          new(yaml_file)
        else
          NullManifest.new
        end
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
        File.open(@file, "wb") { |f| dump(f) }
      end
    end
  end
end
