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
      File.exist?(path) && File.mtime(path)
    end

    def load_configuration
      @last_loaded = last_updated

      return Configuration.new_with_defaults if !File.exist?(path)

      options = load_yaml(path)

      if options && options.has_key?('default')
        MultipleConfiguration.new(options)
      else
        Configuration.new_with_defaults(options)
      end
    end

    def load_yaml(path)
      result = ERB.new(IO.read(path)).result
      method_name = YAML.respond_to?(:unsafe_load) ? :unsafe_load : :load

      begin
        YAML.public_send(method_name, result, aliases: true) || {}
      rescue ArgumentError
        YAML.public_send(method_name, result) || {}
      end
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{path}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{e.message}"
    end
  end
end
