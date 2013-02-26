require "multi_json"

module TinyMCE
  module Rails
    class AssetManifest
      def self.load(manifest_path)
        YamlManifest.try(manifest_path) ||
          JsonManifest.try(manifest_path) ||
          NullManifest.new
      end
    end
  end
  
  class YamlManifest
    def self.try(manifest_path)
      yaml_file = File.join(manifest_path, "manifest.yml")
      new(yaml_file) if File.exists?(yaml_file)
    end
    
    def initialize(file)
      @file = file
      @manifest = YAML.load_file(file)
    end
    
    def append(logical_path, file)
      @manifest[logical_path] = logical_path
    end
    
    def remove(logical_path)
      @manifest.delete(logical_path)
    end
    
    def remove_digest(logical_path)
      if digested = @manifest[logical_path]
        @manifest[logical_path] = logical_path
        yield digested, logical_path if block_given?
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
  
  class JsonManifest
    def self.try(manifest_path)
      paths = Dir[File.join(manifest_path, "manifest*.json")]
      new(paths.first) if paths.any?
    end
    
    def initialize(file)
      @file = file
      @manifest = MultiJson.load(File.read(file))
    end
    
    def append(logical_path, file)
      stat = File.stat(file)
      
      @manifest["assets"][logical_path] = logical_path
      @manifest["files"][logical_path] = {
        "logical_path" => logical_path,
        "mtime"        => stat.mtime.iso8601,
        "size"         => stat.size,
        "digest"       => nil
      }
    end
    
    def remove(logical_path)
      if digested = @manifest["assets"].delete(logical_path)
        @manifest["files"].delete(digested)
      end
    end
    
    def remove_digest(logical_path)
      if digested = @manifest["assets"][logical_path]
        @manifest["assets"][logical_path] = logical_path
        @manifest["files"][logical_path] = @manifest["files"].delete(digested).tap { |f| f["digest"] = nil }
        yield digested, logical_path if block_given?
      end
    end
    
    def each(pattern)
      @manifest["assets"].each_key do |asset|
        yield asset if asset =~ pattern
      end
    end
    
    def to_s
      dump
    end
    
    def dump
      MultiJson.dump(@manifest)
    end
    
    def write
      File.open(@file, "wb") { |f| f.write(dump) }
    end
  end
  
  class NullManifest
    def append(*); end
    def remove(*); end
    def remove_digest(*); end
    def each(*); end
    def write; end
  end
end
