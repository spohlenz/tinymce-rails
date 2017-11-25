require 'active_support/core_ext/hash/keys'

module TinyMCE::Rails
  module Helper
    # Initializes TinyMCE on the current page based on the global configuration.
    #
    # Custom options can be set via the options hash, which will be passed to
    # the TinyMCE init function.
    #
    # By default, all textareas with a class of "tinymce" will have the TinyMCE
    # editor applied. The current locale will also be used as the language when
    # TinyMCE language files are available, falling back to English if not
    # available. The :editor_selector and :language options can be used to
    # override these defaults.
    #
    # @example
    #   <%= tinymce(selector: "editorClass", theme: "inlite") %>
    def tinymce(config=:default, options={})
      javascript_tag do
        unless @_tinymce_configurations_added
          concat tinymce_configurations_javascript
          @_tinymce_configurations_added = true
        end

        concat tinymce_javascript(config, options)
      end
    end

    # Returns the JavaScript code required to initialize TinyMCE.
    def tinymce_javascript(config=:default, options={})
      options, config = config, :default if config.is_a?(Hash)
      options = Configuration.new(options)

      "TinyMCERails.initialize('#{config}', #{options.to_javascript});".html_safe
    end

    # Returns the JavaScript code for initializing each configuration defined within tinymce.yml.
    def tinymce_configurations_javascript(options={})
      javascript = []

      TinyMCE::Rails.each_configuration do |name, config|
        config = config.merge(options) if options.present?
        javascript << "TinyMCERails.configuration.#{name} = #{config.to_javascript};".html_safe
      end

      safe_join(javascript, "\n")
    end

    # Returns the TinyMCE configuration object.
    # It should be converted to JavaScript (via #to_javascript) for use within JavaScript.
    def tinymce_configuration(config=:default, options={})
      options, config = config, :default if config.is_a?(Hash)
      options.stringify_keys!

      base_configuration = TinyMCE::Rails.configuration

      if base_configuration.is_a?(MultipleConfiguration)
        base_configuration = base_configuration.fetch(config)
      end

      base_configuration.merge(options)
    end

    # Includes TinyMCE javascript assets via a script tag.
    def tinymce_assets
      javascript_include_tag "tinymce", "data-turbolinks-track" => "reload"
    end

    # Allow methods to be called as module functions:
    #  e.g. TinyMCE::Rails.tinymce_javascript
    module_function :tinymce, :tinymce_javascript, :tinymce_configurations_javascript, :tinymce_configuration
    public :tinymce, :tinymce_javascript, :tinymce_configurations_javascript, :tinymce_configuration
  end
end
