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
    def tinymce(options={})
      javascript_tag { tinymce_javascript(options) }
    end
    
    # Returns the JavaScript code required to initialize TinyMCE.
    def tinymce_javascript(options={})
      configuration = TinyMCE::Rails.configuration.merge(options)
      "tinyMCE.init(#{configuration.options_for_tinymce.to_json});".html_safe
    end
    
    # Includes TinyMCE javascript assets via a script tag.
    def tinymce_assets
      javascript_include_tag "tinymce"
    end
  end
end
