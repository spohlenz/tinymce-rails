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
        "mode"            => "specific_textareas",
        "editor_selector" => "tinymce",
        "theme"           => "advanced"
      }
    end

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
        if value.is_a?(Array) && value.all? { |v| v.is_a?(String) }
          result[key] = value.join(",")
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

      "{\n#{pairs.join(",\n")}\n}"
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
