module TinyMCE::Rails
  class ConfigurationFile
    attr_reader :path
    
    def initialize(path)
      @path = path
    end
    
    def configuration
      @configuration = load_configuration if reload?
      @configuration
    end
    
    def reload?
      @configuration.nil? || (reloadable? && changed?)
    end
    
    def changed?
      @last_loaded != last_updated
    end
    
  private
    def reloadable?
      !::Rails.application.config.cache_classes
    end
    
    def last_updated
      File.exists?(path) && File.mtime(path)
    end
    
    def load_configuration
      @last_loaded = last_updated
      
      return Configuration.new_with_defaults if !File.exists?(path)
      
      options = load_yaml(path)
      
      if options && options.has_key?('default')
        MultipleConfiguration.new(options)
      else
        Configuration.new_with_defaults(options)
      end
    end
    
    def load_yaml(path)
      YAML::load(ERB.new(IO.read(path)).result)
    end
  end
end
