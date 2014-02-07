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
    #   <%= tinymce(:theme => "advanced", :editor_selector => "editorClass") %>
    def tinymce(config=:default, options={})
      javascript_tag { tinymce_javascript(config, options) }
    end
    
    # Returns the JavaScript code required to initialize TinyMCE.
    def tinymce_javascript(config=:default, options={})
      "tinyMCE.init(#{tinymce_configuration(config, options).to_javascript});".html_safe
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
      javascript_include_tag "tinymce"
    end
  end
end
