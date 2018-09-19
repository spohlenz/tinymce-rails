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

    FUNCTION_REGEX = /^function\s*\(/
    RELATIVE_PATH_REGEX = /^(\/|\.{1,2})\S*/

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

    OPTION_TRANSFORMERS = {
      # Check for files provided in the content_css option to replace them with their actual path.
      # If no corresponding stylesheet is found for a file, it will remain unchanged.
      "content_css" => ->(value) {
        helpers = ActionView::Base.new
        separator = OPTION_SEPARATORS["content_css"]

        value.split(separator).map { |file|
          next file if RELATIVE_PATH_REGEX =~ file
          helpers.stylesheet_path(file.strip) || file
        }.join(separator)
      }
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
        if array_option?(key, value)
          result[key] = value.join(OPTION_SEPARATORS[key])
        elsif function_option?(value)
          result[key] = Function.new(value)
        else
          result[key] = value
        end

        if OPTION_TRANSFORMERS[key]
          result[key] = OPTION_TRANSFORMERS[key].call(result[key])
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

  private
    def array_option?(key, value)
      value.is_a?(Array) && OPTION_SEPARATORS[key]
    end

    def function_option?(value)
      FUNCTION_REGEX =~ value.to_s
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
