require "active_support/hash_with_indifferent_access"

module TinyMCE::Rails
  class Configuration
    class Function < String
      def to_javascript
        self
      end
    end
    
    def self.defaults
      {
        "selector" => "textarea.tinymce"
      }
    end
    
    COMMA = ",".freeze
    SPACE = " ".freeze
    SEMICOLON = ";".freeze
    
    OPTION_SEPARATORS = {
      "plugins"                       => COMMA,
      "custom_elements"               => COMMA,
      "entities"                      => COMMA,
      "extended_valid_elements"       => COMMA,
      "font_formats"                  => SEMICOLON,
      "fontsize_formats"              => COMMA,
      "invalid_elements"              => COMMA,
      "block_formats"                 => SEMICOLON,
      "valid_children"                => COMMA,
      "valid_elements"                => COMMA,
      "body_id"                       => COMMA,
      "body_class"                    => COMMA,
      "content_css"                   => COMMA,
      "tabfocus_elements"             => COMMA,
      "table_clone_elements"          => SPACE,
      "paste_word_valid_elements"     => COMMA,
      "paste_webkit_styles"           => SPACE,
      "paste_retain_style_properties" => SPACE,
      "spellchecker_languages"        => COMMA
    }
    
    attr_reader :options
    
    def initialize(options)
      @options = options
    end
    
    def self.new_with_defaults(options={})
      config = new(defaults)
      config = config.merge(options) if options
      config
    end
    
    def options_for_tinymce
      result = {}
      
      options.each do |key, value|
        if OPTION_SEPARATORS[key] && value.is_a?(Array)
          result[key] = value.join(OPTION_SEPARATORS[key])
        elsif value.to_s.starts_with?("function(")
          result[key] = Function.new(value)
        else
          result[key] = value
        end
      end
      
      result
    end
    
    def to_javascript
      pairs = options_for_tinymce.inject([]) do |result, (k, v)|
        if v.respond_to?(:to_javascript)
          v = v.to_javascript
        elsif v.respond_to?(:to_json)
          v = v.to_json
        end
        
        result << [k, v].join(": ")
      end
      
      "{\n  #{pairs.join(",\n  ")}\n}"
    end
    
    def merge(options)
      self.class.new(self.options.merge(options))
    end
  end
  
  class MultipleConfiguration < ActiveSupport::HashWithIndifferentAccess
    def initialize(configurations={})
      configurations = configurations.each_with_object({}) { |(name, options), h|
        h[name] = Configuration.new_with_defaults(options)
      }
      
      super(configurations)
    end
  end
end
