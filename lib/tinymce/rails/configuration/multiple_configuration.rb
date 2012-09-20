module TinyMCE::Rails
  class MultipleConfiguration < SingleConfiguration

    DEFAULT_SCOPE = "default"

    class << self
      def defaults
        wrap_options(self.superclass.defaults)
      end

      private

      def wrap_options(options)
        { DEFAULT_SCOPE => options }
      end
    end

    def options
      @options["default"]
    end

    def merge(options)
      config = options.delete(:config) if options[:config]
      selected = config ? @options[config] : @options[DEFAULT_SCOPE]
      self.class.superclass.new(selected.merge(options))
    end

  end
end
