module TinyMCE::Rails
  class Configuration
    class Function < String
      def encode_json(encoder)
        self
      end
    end
    
    def self.defaults
      {
        "mode"            => "specific_textareas",
        "editor_selector" => "tinymce",
        "theme"           => "advanced"
      }
    end
    
    attr_reader :options
    
    def initialize(options)
      @options = options
    end
    
    def options_for_tinymce
      result = {}
      
      options.each do |key, value|
        if value.is_a?(Array) && value.all? { |v| v.is_a?(String) }
          result[key] = value.join(",")
        elsif value.to_s.starts_with?("function(")
          result[key] = Function.new(value)
        else
          result[key] = value
        end
      end
      
      result["language"] ||= self.class.default_language
      
      result
    end
    
    def merge(options)
      self.class.new(self.options.merge(options))
    end
    
    def load(filename)
      options.merge!(YAML::load(ERB.new(IO.read(filename)).result))
    end
    
    def self.load(filename)
      config = new(defaults)
      config.load(filename) if File.exists?(filename)
      config
    end
    
    # Default language falls back to English if current locale is not available.
    def self.default_language
      available_languages.include?(I18n.locale.to_s) ? I18n.locale.to_s : "en"
    end
    
    # Searches asset paths for TinyMCE language files.
    def self.available_languages
      assets.paths.map { |path|
        files = assets.entries(File.join(path, "tinymce/langs"))
        files.map { |file|
          asset = assets.attributes_for(File.join(path, file))
          asset.logical_path.sub(/\.js$/, "")
        }
      }.flatten.uniq
    end
  
    def self.assets
      Rails.application.assets
    end
  end
end
